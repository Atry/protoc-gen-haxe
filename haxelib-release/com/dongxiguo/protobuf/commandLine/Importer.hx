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

#if sys

import com.dongxiguo.protobuf.binaryFormat.LimitableFileInput;
import com.dongxiguo.protobuf.compiler.NameConverter;
import com.dongxiguo.protobuf.compiler.ProtoData;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet_Builder;
import haxe.macro.Compiler;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Expr;
import haxe.macro.Context;
import sys.io.File;
import sys.FileSystem;
import com.dongxiguo.protobuf.binaryFormat.ReadUtils;
import com.dongxiguo.protobuf.binaryFormat.WriteUtils;
#if haxe3
import haxe.ds.IntMap;
import haxe.ds.StringMap;
#else
private typedef StringMap<Value> = Hash<Value>;
private typedef IntMap<Value> = IntHash<Value>;
#end
using com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet_Merger;
using com.dongxiguo.protobuf.compiler.BinaryFormat;
using com.dongxiguo.protobuf.compiler.Extension;

/**
  @author 杨博
**/
class Importer
{

  public static var DEFAULT_READONLY_MESSAGE_NAME_CONVERTER(default, never):MessageNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return NameConverter.getClassName(protoFullyQualifiedName);
    },
    getHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return NameConverter.replaceKeywords(NameConverter.getLowerCamelCasePackage(fullyQualifiedName));
    },
    toHaxeFieldName: function(fieldName:String):String
    {
      return NameConverter.replaceKeyword(NameConverter.lowerCaseUnderlineToLowerCamelCase(fieldName));
    },
  };

  public static var DEFAULT_BUILDER_NAME_CONVERTER(default, never):MessageNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return NameConverter.getClassName(protoFullyQualifiedName) + "_Builder";
    },
    getHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return NameConverter.replaceKeywords(NameConverter.getLowerCamelCasePackage(fullyQualifiedName));
    },
    toHaxeFieldName: function(fieldName:String):String
    {
      return NameConverter.replaceKeyword(NameConverter.lowerCaseUnderlineToLowerCamelCase(fieldName));
    },
  };

  public static var DEFAULT_ENUM_NAME_CONVERTER(default, never):EnumNameConverter =
  {
    toHaxeEnumConstructorName: NameConverter.replaceKeyword,
    getHaxeEnumName: NameConverter.getClassName,
    getHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return NameConverter.replaceKeywords(NameConverter.getLowerCamelCasePackage(fullyQualifiedName));
    },
  };

  public static var DEFAULT_PACKAGE_SETTER_NAME_CONVERTER(default, never):PackageExtensionNameConverter =
  {
    getHaxeClassName: function(protoPackageName:String):String
    {
      if (protoPackageName == ".")
      {
        return "Setter";
      }
      else
      {
        return NameConverter.getClassName(protoPackageName) + "_Setter";
      }
    },
    getHaxePackage: function(protoPackageName:String):Array<String>
    {
      return NameConverter.replaceKeywords(NameConverter.getLowerCamelCasePackage(protoPackageName));
    },
    toHaxeFieldName: function(fieldName:String):String
    {
      return NameConverter.replaceKeyword(NameConverter.lowerCaseUnderlineToLowerCamelCase(fieldName));
    },
  };

  public static var DEFAULT_PACKAGE_GETTER_NAME_CONVERTER(default, never):PackageExtensionNameConverter =
  {
    getHaxeClassName: function(protoPackageName:String):String
    {
      return NameConverter.getClassName(protoPackageName) + "_Getter";
    },
    getHaxePackage: function(protoPackageName:String):Array<String>
    {
      return NameConverter.replaceKeywords(NameConverter.getLowerCamelCasePackage(protoPackageName));
    },
    toHaxeFieldName: function(fieldName:String):String
    {
      return NameConverter.replaceKeyword(NameConverter.lowerCaseUnderlineToLowerCamelCase(fieldName));
    },
  };

  public static var DEFAULT_MESSAGE_SETTER_NAME_CONVERTER(default, never):MessageNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return NameConverter.getClassName(protoFullyQualifiedName) + "_Setter";
    },
    getHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return NameConverter.replaceKeywords(NameConverter.getLowerCamelCasePackage(fullyQualifiedName));
    },
    toHaxeFieldName: function(fieldName:String):String
    {
      return NameConverter.replaceKeyword(NameConverter.lowerCaseUnderlineToLowerCamelCase(fieldName));
    },
  };

  public static var DEFAULT_MESSAGE_GETTER_NAME_CONVERTER(default, never):MessageNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return NameConverter.getClassName(protoFullyQualifiedName) + "_Getter";
    },
    getHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return NameConverter.replaceKeywords(NameConverter.getLowerCamelCasePackage(fullyQualifiedName));
    },
    toHaxeFieldName: function(fieldName:String):String
    {
      return NameConverter.replaceKeyword(NameConverter.lowerCaseUnderlineToLowerCamelCase(fieldName));
    },
  };

  public static var DEFAULT_MERGER_NAME_CONVERTER(default, never):UtilityNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return NameConverter.getClassName(protoFullyQualifiedName) + "_Merger";
    },
    getHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return NameConverter.replaceKeywords(NameConverter.getLowerCamelCasePackage(fullyQualifiedName));
    },
  };

  public static var DEFAULT_WRITER_NAME_CONVERTER(default, never):UtilityNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return NameConverter.getClassName(protoFullyQualifiedName) + "_Writer";
    },
    getHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return NameConverter.replaceKeywords(NameConverter.getLowerCamelCasePackage(fullyQualifiedName));
    },
  };

  @:noUsing
  public static function readProtoData(fileName:String):ProtoData
  {
    var builder:FileDescriptorSet = { file: [] };
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
      #if neko
      neko.Lib.rethrow(e);
      #elseif cpp
      cpp.Lib.rethrow(e);
      #elseif php
      php.Lib.rethrow(e);
      #else
      throw e;
      #end
    }
    haxeInput.close();
    return new ProtoData(builder);
  }

  #if macro
  public static function defineAllEnums(self:ProtoData):Void
  {
    for (fullName in self.enums.keys())
    {
      Context.defineType(
        self.getEnumDefinition(
          fullName,
          DEFAULT_ENUM_NAME_CONVERTER));
    }
  }

  public static function defineAllReadonlyMessages(self:ProtoData):Void
  {
    var lazyTypes = new StringMap<TypeDefinition>();
    Context.onTypeNotFound(function(typeName)
    {
      return lazyTypes.get(typeName);
    });
    for (fullName in self.messages.keys())
    {
      var td = self.getReadonlyMessageDefinition(
          fullName,
          DEFAULT_READONLY_MESSAGE_NAME_CONVERTER,
          DEFAULT_ENUM_NAME_CONVERTER);
      lazyTypes.set(td.pack.concat([ td.name ]).join("."), td);
    }
  }

  public static function defineAllMessageSetters(self:ProtoData):Void
  {
    for (fullName in self.messages.keys())
    {
      var typeDefinition =
        self.getMessageSetterDefinition(
          fullName,
          DEFAULT_MESSAGE_SETTER_NAME_CONVERTER,
          DEFAULT_BUILDER_NAME_CONVERTER,
          DEFAULT_WRITER_NAME_CONVERTER);
      if (typeDefinition != null)
      {
        Context.defineType(typeDefinition);
      }
    }
  }

  public static function defineAllPackageSetters(self:ProtoData):Void
  {
    for (fullName in self.packages.keys())
    {
      var typeDefinition =
        self.getPackageSetterDefinition(
          fullName,
          DEFAULT_PACKAGE_SETTER_NAME_CONVERTER,
          DEFAULT_BUILDER_NAME_CONVERTER,
          DEFAULT_WRITER_NAME_CONVERTER);
      if (typeDefinition != null)
      {
        Context.defineType(typeDefinition);
      }
    }
  }

  public static function defineAllMessageGetters(self:ProtoData):Void
  {
    for (fullName in self.messages.keys())
    {
      var typeDefinition =
        self.getMessageGetterDefinition(
          fullName,
          DEFAULT_MESSAGE_GETTER_NAME_CONVERTER,
          DEFAULT_READONLY_MESSAGE_NAME_CONVERTER,
          DEFAULT_BUILDER_NAME_CONVERTER,
          DEFAULT_ENUM_NAME_CONVERTER,
          DEFAULT_MERGER_NAME_CONVERTER);
      if (typeDefinition != null)
      {
        Context.defineType(typeDefinition);
      }
    }
  }

  public static function defineAllPackageGetters(self:ProtoData):Void
  {
    for (fullName in self.packages.keys())
    {
      var typeDefinition =
        self.getPackageGetterDefinition(
          fullName,
          DEFAULT_PACKAGE_GETTER_NAME_CONVERTER,
          DEFAULT_READONLY_MESSAGE_NAME_CONVERTER,
          DEFAULT_BUILDER_NAME_CONVERTER,
          DEFAULT_ENUM_NAME_CONVERTER,
          DEFAULT_MERGER_NAME_CONVERTER);
      if (typeDefinition != null)
      {
        Context.defineType(typeDefinition);
      }
    }

  }

  public static function defineAllBuilders(self:ProtoData):Void
  {
    for (fullName in self.messages.keys())
    {
      Context.defineType(
        self.getBuilderDefinition(
          fullName,
          DEFAULT_BUILDER_NAME_CONVERTER,
          DEFAULT_ENUM_NAME_CONVERTER));
    }
  }

  public static function defineAllBinaryMergers(self:ProtoData):Void
  {
    for (fullName in self.messages.keys())
    {
      Context.defineType(
        self.getMergerDefinition(
          fullName,
          DEFAULT_MERGER_NAME_CONVERTER,
          DEFAULT_BUILDER_NAME_CONVERTER,
          DEFAULT_ENUM_NAME_CONVERTER));
    }
  }

  public static function defineAllBinaryWriters(self:ProtoData):Void
  {
    for (fullName in self.messages.keys())
    {
      Context.defineType(
        self.getWriterDefinition(
          fullName,
          DEFAULT_WRITER_NAME_CONVERTER,
          DEFAULT_READONLY_MESSAGE_NAME_CONVERTER));
    }
  }

  @:noUsing
  public static function importDescroptorFileSet(fileName:String):Void
  {
    var protoData = readProtoData(fileName);
    defineAllEnums(protoData);
    defineAllReadonlyMessages(protoData);
    defineAllBuilders(protoData);
    defineAllBinaryWriters(protoData);
    defineAllBinaryMergers(protoData);
    defineAllMessageGetters(protoData);
    defineAllPackageGetters(protoData);
    defineAllMessageSetters(protoData);
    defineAllPackageSetters(protoData);
  }
  #end
}
#end
