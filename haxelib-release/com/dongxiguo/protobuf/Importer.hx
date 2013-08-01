package com.dongxiguo.protobuf;
import com.dongxiguo.protobuf.binaryFormat.BinaryFileInput;
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
#if haxe3
import haxe.ds.IntMap;
import haxe.ds.StringMap;
#else
private typedef StringMap<Value> = Hash<Value>;
private typedef IntMap<Value> = IntHash<Value>;
#end
using com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet_Merger;
using com.dongxiguo.protobuf.compiler.BinaryFormat;

import com.dongxiguo.protobuf.binaryFormat.WriteUtils;

/**
  @author 杨博
**/
class Importer
{
  @:noUsing
  public static function readProtoData(fileName:String):ProtoData
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

  public static function defineAllEnums(self:ProtoData):Void
  {
    for (fullName in self.enums.keys())
    {
      Context.defineType(
        self.getFakeEnumDefinition(
          fullName,
          NameConverter.DEFAULT_ENUM_NAME_CONVERTER));
      Context.defineType(
        self.getFakeEnumClassDefinition(
          fullName,
          NameConverter.DEFAULT_ENUM_CLASS_NAME_CONVERTER,
          NameConverter.DEFAULT_ENUM_NAME_CONVERTER));
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
          NameConverter.DEFAULT_READONLY_MESSAGE_NAME_CONVERTER,
          NameConverter.DEFAULT_ENUM_NAME_CONVERTER);
      lazyTypes.set(td.pack.concat([ td.name ]).join("."), td);
    }
  }

  public static function defineAllBuilders(self:ProtoData):Void
  {
    for (fullName in self.messages.keys())
    {
      Context.defineType(
        self.getBuilderDefinition(
          fullName,
          NameConverter.DEFAULT_BUILDER_NAME_CONVERTER,
          NameConverter.DEFAULT_ENUM_NAME_CONVERTER));
    }
  }

  public static function defineAllBinaryMergers(self:ProtoData):Void
  {
    for (fullName in self.messages.keys())
    {
      Context.defineType(
        self.getMergerDefinition(
          fullName,
          NameConverter.DEFAULT_MERGER_NAME_CONVERTER,
          NameConverter.DEFAULT_BUILDER_NAME_CONVERTER,
          NameConverter.DEFAULT_ENUM_CLASS_NAME_CONVERTER));
    }
  }

  public static function defineAllBinaryWriters(self:ProtoData):Void
  {
    for (fullName in self.messages.keys())
    {
      Context.defineType(
        self.getWriterDefinition(
          fullName,
          NameConverter.DEFAULT_WRITER_NAME_CONVERTER,
          NameConverter.DEFAULT_READONLY_MESSAGE_NAME_CONVERTER,
          NameConverter.DEFAULT_ENUM_CLASS_NAME_CONVERTER));
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
  }
}