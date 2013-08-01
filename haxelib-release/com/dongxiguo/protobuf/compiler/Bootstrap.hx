package com.dongxiguo.protobuf.compiler;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Printer;
import haxe.PosInfos;
import sys.io.File;
import sys.FileSystem;
import com.dongxiguo.protobuf.binaryFormat.BinaryFileInput;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet_Builder;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet;
using com.dongxiguo.protobuf.compiler.BinaryFormat;
using com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet_Merger;

/**
  @author 杨博
**/
class Bootstrap
{
  static var BOOTSTRAP_PACKAGE_PREFIX(default, never) = [ "com", "dongxiguo", "protobuf", "compiler", "bootstrap" ];

  static var BOOTSTRAP_MERGER_NAME_CONVERTER(default, never):NameConverter.UtilityNameConverter =
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
  
  static var BOOTSTRAP_BUILDER_NAME_CONVERTER(default, never):NameConverter.MessageNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return NameConverter.getClassName(protoFullyQualifiedName) + "_Builder";
    },
    getHaxePackage: function(protoPackage:String):Array<String>
    {
      return BOOTSTRAP_PACKAGE_PREFIX.concat(NameConverter.getLowerCamelCasePackage(protoPackage));
    },
    toHaxeFieldName: NameConverter.DEFAULT_BUILDER_NAME_CONVERTER.toHaxeFieldName,
  };
  
  static var BOOTSTRAP_READONLY_MESSAGE_NAME_CONVERTER(default, never):NameConverter.MessageNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return NameConverter.getClassName(protoFullyQualifiedName);
    },
    getHaxePackage: function(protoPackage:String):Array<String>
    {
      return BOOTSTRAP_PACKAGE_PREFIX.concat(NameConverter.getLowerCamelCasePackage(protoPackage));
    },
    toHaxeFieldName: NameConverter.DEFAULT_BUILDER_NAME_CONVERTER.toHaxeFieldName,
  };

  static var BOOTSTRAP_ENUM_NAME_CONVERTER(default, never):NameConverter.EnumNameConverter =
  {
    toHaxeEnumConstructorName: NameConverter.identity,
    getHaxeEnumName: NameConverter.getClassName,
    getHaxePackage: function(protoPackage:String):Array<String>
    {
      return BOOTSTRAP_PACKAGE_PREFIX.concat(NameConverter.getLowerCamelCasePackage(protoPackage));
    },
  };

  static var BOOTSTRAP_ENUM_CLASS_NAME_CONVERTER(default, never):NameConverter.UtilityNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return NameConverter.getClassName(protoFullyQualifiedName) + "_EnumClass";
    },
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
    var builder:FileDescriptorSet = { file: [] };
    var haxeInput = File.read(fileName);
    var builder = new FileDescriptorSet_Builder();
    try
    {
      var input = new BinaryFileInput(haxeInput, FileSystem.stat(fileName).size);
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
        protoData.getRealEnumClassDefinition(
          fullName,
          BOOTSTRAP_ENUM_CLASS_NAME_CONVERTER,
          BOOTSTRAP_ENUM_NAME_CONVERTER));
      writeHxFile(
        outputDirectory,
        protoData.getRealEnumDefinition(
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
          BOOTSTRAP_ENUM_CLASS_NAME_CONVERTER));
    }
  }

}