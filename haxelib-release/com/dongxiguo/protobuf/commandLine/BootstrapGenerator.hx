// Copyright (c) 2013, 杨博 (Yang Bo)
// All rights reserved.
//
// Author: 杨博 (Yang Bo) <pop.atry@gmail.com>
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// * Neither the name of the <ORGANIZATION> nor the names of its contributors
//   may be used to endorse or promote products derived from this software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

package com.dongxiguo.protobuf.commandLine;

#if neko

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Printer;
import haxe.PosInfos;
import sys.io.File;
import sys.FileSystem;
import com.dongxiguo.protobuf.binaryFormat.LimitableFileInput;
import com.dongxiguo.protobuf.compiler.NameConverter;
import com.dongxiguo.protobuf.compiler.ProtoData;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet_Builder;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet;

using com.dongxiguo.protobuf.compiler.BinaryFormat;
using com.dongxiguo.protobuf.compiler.Extension;
using com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet_Merger;

/**
  @author 杨博
**/
class BootstrapGenerator
{
  static var BOOTSTRAP_PACKAGE_PREFIX(default, never) = [ "com", "dongxiguo", "protobuf", "compiler", "bootstrap" ];

  static var BOOTSTRAP_MERGER_NAME_CONVERTER(default, never):UtilityNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return NameConverter.getClassName(protoFullyQualifiedName) + "_Merger";
    },
    getHaxePackage: function(protoPackage:String):Array<String>
    {
      return BOOTSTRAP_PACKAGE_PREFIX.concat(NameConverter.getLowerCamelCasePackage(protoPackage));
    },
  };

  static var BOOTSTRAP_BUILDER_NAME_CONVERTER(default, never):MessageNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return NameConverter.getClassName(protoFullyQualifiedName) + "_Builder";
    },
    getHaxePackage: function(protoPackage:String):Array<String>
    {
      return BOOTSTRAP_PACKAGE_PREFIX.concat(NameConverter.getLowerCamelCasePackage(protoPackage));
    },
    toHaxeFieldName: function(fieldName:String):String
    {
      return NameConverter.replaceKeyword(NameConverter.lowerCaseUnderlineToLowerCamelCase(fieldName));
    },
  };

  static var BOOTSTRAP_READONLY_MESSAGE_NAME_CONVERTER(default, never):MessageNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return NameConverter.getClassName(protoFullyQualifiedName);
    },
    getHaxePackage: function(protoPackage:String):Array<String>
    {
      return BOOTSTRAP_PACKAGE_PREFIX.concat(NameConverter.getLowerCamelCasePackage(protoPackage));
    },
    toHaxeFieldName: function(fieldName:String):String
    {
      return NameConverter.replaceKeyword(NameConverter.lowerCaseUnderlineToLowerCamelCase(fieldName));
    },
  };

  static var BOOTSTRAP_ENUM_NAME_CONVERTER(default, never):EnumNameConverter =
  {
    toHaxeEnumConstructorName: NameConverter.identity,
    getHaxeEnumName: NameConverter.getClassName,
    getHaxePackage: function(protoPackage:String):Array<String>
    {
      return BOOTSTRAP_PACKAGE_PREFIX.concat(NameConverter.getLowerCamelCasePackage(protoPackage));
    },
  };

  static function createParentDirectories(path:String):Void
  {
    var eReg = ~/(.*)[\\\/]([^\\\/]*)/;
    if (eReg.match(path))
    {
      var baseDirectory = eReg.matched(1);
      if (!FileSystem.exists(baseDirectory))
      {
        createParentDirectories(baseDirectory);
      }
      FileSystem.createDirectory(baseDirectory);
    }
  }

  static function createPackageDirectories(
    outputDirectory:String,
    pack:Array<String>):String
  {
    var d = outputDirectory;
    for (part in pack)
    {
      d = '$d/$part';
      if (!FileSystem.exists(d))
      {
        FileSystem.createDirectory(d);
      }
    }
    return d;
  }

  static function writeHxFile(
    outputDirectory:String,
    typeDefinition:TypeDefinition):Void
  {
    var d = createPackageDirectories(outputDirectory, typeDefinition.pack);
    var hxFile = '$d/${typeDefinition.name}.hx';
    var output = File.write(hxFile);
    try
    {
      var p = new Printer();
      output.writeString(p.printTypeDefinition(typeDefinition));
    }
    catch (e:Dynamic)
    {
      output.close();
      neko.Lib.rethrow(e);
    }
    output.close();
  }

  static function readProtoData(fileName:String):ProtoData
  {
    var haxeInput = File.read(fileName);
    var builder = new FileDescriptorSet_Builder();
    try
    {
      var input = new LimitableFileInput(haxeInput, FileSystem.stat(fileName).size);
      builder.mergeFrom(input);
    }
    catch (e:Dynamic)
    {
      haxeInput.close();
      neko.Lib.rethrow(e);
    }
    haxeInput.close();
    return new ProtoData(builder);
  }

  public static function generateBootstrapFiles(
    descriptorFileName:String,
    outputDirectory:String):Void
  {
    var protoData = readProtoData(descriptorFileName);
    for (fullName in protoData.enums.keys())
    {
      writeHxFile(
        outputDirectory,
        protoData.getEnumDefinition(
          fullName,
          BOOTSTRAP_ENUM_NAME_CONVERTER));
    }
    for (fullName in protoData.messages.keys())
    {
      writeHxFile(
        outputDirectory,
        protoData.getBuilderDefinition(
          fullName,
          BOOTSTRAP_BUILDER_NAME_CONVERTER,
          BOOTSTRAP_ENUM_NAME_CONVERTER));
      writeHxFile(
        outputDirectory,
        protoData.getReadonlyMessageDefinition(
          fullName,
          BOOTSTRAP_READONLY_MESSAGE_NAME_CONVERTER,
          BOOTSTRAP_ENUM_NAME_CONVERTER));
      writeHxFile(
        outputDirectory,
        protoData.getMergerDefinition(
          fullName,
          BOOTSTRAP_MERGER_NAME_CONVERTER,
          BOOTSTRAP_BUILDER_NAME_CONVERTER,
          BOOTSTRAP_ENUM_NAME_CONVERTER));
    }
  }

}
#end
