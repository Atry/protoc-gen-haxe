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

package com.dongxiguo.protobuf.compiler;
import com.dongxiguo.protobuf.binaryFormat.WritingBuffer;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label;
import com.dongxiguo.protobuf.WireType;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.PosInfos;
using Lambda;

private typedef ProtobufType = com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type;
private typedef ProtobufError = com.dongxiguo.protobuf.Error;

/**
  @author 杨博
**/
class Extension
{

  static function packageDotClass(packageExpr:Null<Expr>, className:String):Expr
  {
    if (packageExpr == null)
    {
      return
      {
        pos: makeMacroPosition(),
        expr: EConst(CIdent(className)),
      }
    }
    else
    {
      return macro $packageExpr.$className;
    }
  }

  macro static function makeMacroPosition():ExprOf<Position>
  {
    var positionExpr = Context.makeExpr(Context.getPosInfos(Context.currentPos()), Context.currentPos());
    if (haxe.macro.Context.defined("macro"))
    {
      return macro haxe.macro.Context.makePosition($positionExpr);
    }
    else
    {
      return positionExpr;
    }
  }

  static function getSetterDefinition(
    self:ProtoData,
    fullName:String,
    setterNameConverter:NameConverter.PackageExtensionNameConverter,
    builderNameConverter:NameConverter.MessageNameConverter,
    writerNameConverter:NameConverter.UtilityNameConverter,
    field:FieldDescriptorProto):Field
  {
    function unknownFieldFromValue(valueExpr:Expr):Expr
    {
      switch (field.type)
      {
        case ProtobufType.TYPE_MESSAGE:
        {
          var resolvedFieldTypeName = ProtoData.resolve(self.messages, fullName, field.typeName);
          var fieldBuilderTypePath =
          {
            params: [],
            name: builderNameConverter.getHaxeClassName(resolvedFieldTypeName),
            pack: builderNameConverter.getHaxePackage(resolvedFieldTypeName),
          };
          var nestedWriterPackage =
            writerNameConverter.getHaxePackage(resolvedFieldTypeName);
          var nestedWriterPackageExpr =
            ExprTools.toFieldExpr(nestedWriterPackage);
          var nestedWriterName =
            writerNameConverter.getHaxeClassName(resolvedFieldTypeName);
          var nestedWriterExpr = packageDotClass(nestedWriterPackageExpr, nestedWriterName);
          return macro
          {
            var output = new haxe.io.BytesOutput();
            $nestedWriterExpr.writeTo($valueExpr, output);
            output.getBytes();
          }
        }
        case ProtobufType.TYPE_ENUM:
        {
          return macro com.dongxiguo.protobuf.unknownField.VarintUnknownField.fromInt32($valueExpr.number);
        }
        default:
        {
          var abstractTypeName = switch (WireType.byType(field.type))
          {
            case WireType.LENGTH_DELIMITED:
            {
              "LengthDelimitedUnknownField";
            }
            case WireType.VARINT:
            {
              "VarintUnknownField";
            }
            case WireType.FIXED_64_BIT:
            {
              "Fixed64BitUnknownField";
            }
            case WireType.FIXED_32_BIT:
            {
              "Fixed32BitUnknownField";
            }
            default:
            {
              throw ProtobufError.InvalidWireType;
            }
          }
          var typeName:String = getTypeName(field.type);
          var fromFunctionName = switch (typeName.split("_"))
          {
            case [ "TYPE", upperCaseTypeName ]:
            {
              "from" + upperCaseTypeName.charAt(0) + upperCaseTypeName.substring(1).toLowerCase();
            }
            default:
            {
              throw ProtobufError.MalformedEnumConstructor;
            }
          }
          return macro com.dongxiguo.protobuf.unknownField.$abstractTypeName.$fromFunctionName($valueExpr);
        }
      }
    }
    var extendeeFullName = ProtoData.resolve(self.messages, fullName, field.extendee);
    return
    {
      name: setterNameConverter.toHaxeFieldName(field.name),
      pos: makeMacroPosition(),
      access: [ APublic, AStatic ],
      meta: [],
      kind: FFun(
        {
          args:
          [
            {
              name: "self",
              opt: false,
              type: TPath(
                {
                  pack: builderNameConverter.getHaxePackage(extendeeFullName),
                  name: builderNameConverter.getHaxeClassName(extendeeFullName),
                  params: [],
                }),
            },
            {
               name: "value",
               opt: false,
               type: null,
            },
          ],
          ret: null,
          params: [],
          expr:
          {
            switch (field.label)
            {
              case Label.LABEL_OPTIONAL, Label.LABEL_REQUIRED:
              {
                var nonPackedTagExpr =
                {
                  pos: makeMacroPosition(),
                  expr: EConst(CInt(Std.string(
                    WireType.byType(field.type) | (field.number << 3)))),
                }
                var unknownFieldValueExpr = unknownFieldFromValue(macro value);
                var requiredExpr = macro
                  {
                    var unknownFields = self.unknownFields;
                    if (unknownFields == null)
                    {
                      unknownFields = new com.dongxiguo.protobuf.unknownField.UnknownFieldMap();
                      self.unknownFields = unknownFields;
                    }
                    unknownFields.set($nonPackedTagExpr, com.dongxiguo.protobuf.unknownField.UnknownField.fromOptional($unknownFieldValueExpr));
                  }
                if (field.label == Label.LABEL_REQUIRED)
                {
                  requiredExpr;
                }
                else
                {
                  macro
                  {
                    inline function dummy<T>(n:Null<T>) { }
                    dummy(value);
                    if (value == null)
                    {
                      var unknownFields = self.unknownFields;
                      if (unknownFields != null)
                      {
                        unknownFields.remove($nonPackedTagExpr);
                      }
                    }
                    else
                    {
                      $requiredExpr;
                    }
                  }
                }
              }
              case Label.LABEL_REPEATED:
              {
                if (field.options != null && field.options.packed)
                {
                  var packedTagExpr =
                  {
                    pos: makeMacroPosition(),
                    expr: EConst(CInt(Std.string(
                      WireType.LENGTH_DELIMITED | (field.number << 3)))),
                  }
                  var elementExpr = switch (field.type)
                  {
                    case ProtobufType.TYPE_ENUM:
                    {
                      macro com.dongxiguo.protobuf.binaryFormat.WriteUtils.writeInt32(buffer, element.number);
                    }
                    default:
                    {
                      var typeName:String = getTypeName(field.type);
                      var writeFunctionName = switch (typeName.split("_"))
                      {
                        case [ "TYPE", upperCaseTypeName ]:
                        {
                          "write" + upperCaseTypeName.charAt(0) + upperCaseTypeName.substring(1).toLowerCase();
                        }
                        default:
                        {
                          throw ProtobufError.MalformedEnumConstructor;
                        }
                      }
                      macro com.dongxiguo.protobuf.binaryFormat.WriteUtils.$writeFunctionName(buffer, element);
                    }
                  }
                  macro
                  {
                    var buffer = new com.dongxiguo.protobuf.binaryFormat.WritingBuffer();
                    inline function dummy<T>(i:Iterable<T>) { }
                    dummy(value);
                    for (element in value)
                    {
                      $elementExpr;
                    }
                    var bytes = buffer.getBytes();
                    if (bytes.length > 0)
                    {
                      var unknownFields = self.unknownFields;
                      if (unknownFields == null)
                      {
                        unknownFields = new com.dongxiguo.protobuf.unknownField.UnknownFieldMap();
                        self.unknownFields = unknownFields;
                      }
                      unknownFields.set($packedTagExpr, com.dongxiguo.protobuf.unknownField.UnknownField.fromOptional(bytes));
                    }
                    else
                    {
                      var unknownFields = self.unknownFields;
                      if (unknownFields != null)
                      {
                        unknownFields.remove($packedTagExpr);
                      }
                    }
                  }
                }
                else
                {
                  var nonPackedTagExpr =
                  {
                    pos: makeMacroPosition(),
                    expr: EConst(CInt(Std.string(
                      WireType.byType(field.type) | (field.number << 3)))),
                  }
                  var unknownFieldValueExpr = unknownFieldFromValue(macro element);
                  macro
                  {
                    var unknownFields = self.unknownFields;
                    if (unknownFields == null)
                    {
                      unknownFields = new com.dongxiguo.protobuf.unknownField.UnknownFieldMap();
                      self.unknownFields = unknownFields;
                    }
                    inline function dummy<T>(i:Iterable<T>) { }
                    dummy(value);
                    var fieldValues:Array<com.dongxiguo.protobuf.unknownField.UnknownFieldElement> =
                    [
                      for (element in value)
                      {
                        $unknownFieldValueExpr;
                      }
                    ];
                    unknownFields.set($nonPackedTagExpr, com.dongxiguo.protobuf.unknownField.UnknownField.fromRepeated(fieldValues));
                  }
                }
              }
              default:
              {
                throw ProtobufError.BadDescriptor;
              }
            }
          },
        }),
    }
  }

  public static function getPackageSetterDefinition(
    self:ProtoData,
    fullName:String,
    setterNameConverter:NameConverter.PackageExtensionNameConverter,
    builderNameConverter:NameConverter.MessageNameConverter,
    writerNameConverter:NameConverter.UtilityNameConverter):Null<TypeDefinition>
  {
    var fields:Array<Field> =
    [
      for (file in self.packages.get(fullName))
      {
        for (field in file.extension)
        {
          switch (field.type)
          {
            case ProtobufType.TYPE_GROUP:
            {
              #if neko
              Context.warning("TYPE_GROUP is unsupported!", makeMacroPosition());
              {
                pos: makeMacroPosition(),
                expr: EBlock([]),
              }
              #else
              trace("TYPE_GROUP is unsupported!");
              #end
              continue;
            }
            default:
          }
          getSetterDefinition(
            self,
            fullName,
            setterNameConverter,
            builderNameConverter,
            writerNameConverter,
            field);
        }
      }
    ];
    if (fields.length == 0)
    {
      return null;
    }
    return
    {
      pack: setterNameConverter.getHaxePackage(fullName),
      name: setterNameConverter.getHaxeClassName(fullName),
      pos: makeMacroPosition(),
      meta: [],
      params: [],
      isExtern: false,
      kind: TDClass(),
      fields: fields,
    };
  }

  public static function getMessageSetterDefinition(
    self:ProtoData,
    fullName:String,
    setterNameConverter:NameConverter.MessageNameConverter,
    builderNameConverter:NameConverter.MessageNameConverter,
    writerNameConverter:NameConverter.UtilityNameConverter):Null<TypeDefinition>
  {
    var messageProto = self.messages.get(fullName);
    if (messageProto.extension.empty())
    {
      return null;
    }
    var fields:Array<Field> =
    [
      for (field in messageProto.extension)
      {
        switch (field.type)
        {
          case ProtobufType.TYPE_GROUP:
          {
            #if neko
            Context.warning("TYPE_GROUP is unsupported!", makeMacroPosition());
            {
              pos: makeMacroPosition(),
              expr: EBlock([]),
            }
            #else
            trace("TYPE_GROUP is unsupported!");
            #end
            continue;
          }
          default:
        }
        getSetterDefinition(
          self,
          fullName,
          setterNameConverter,
          builderNameConverter,
          writerNameConverter,
          field);
      }
    ];
    return
    {
      pack: setterNameConverter.getHaxePackage(fullName),
      name: setterNameConverter.getHaxeClassName(fullName),
      pos: makeMacroPosition(),
      meta: [],
      params: [],
      isExtern: false,
      kind: TDClass(),
      fields: fields,
    };
  }

  static function getTypeName(type:ProtobufType):String
  {
    return switch (type)
    {
      case ProtobufType.TYPE_DOUBLE: "TYPE_DOUBLE";
      case ProtobufType.TYPE_FLOAT: "TYPE_FLOAT";
      case ProtobufType.TYPE_INT64: "TYPE_INT64";
      case ProtobufType.TYPE_UINT64: "TYPE_UINT64";
      case ProtobufType.TYPE_INT32: "TYPE_INT32";
      case ProtobufType.TYPE_FIXED64: "TYPE_FIXED64";
      case ProtobufType.TYPE_BOOL: "TYPE_BOOL";
      case ProtobufType.TYPE_STRING: "TYPE_STRING";
      case ProtobufType.TYPE_BYTES: "TYPE_BYTES";
      case ProtobufType.TYPE_UINT32: "TYPE_UINT32";
      case ProtobufType.TYPE_FIXED32: "TYPE_FIXED32";
      case ProtobufType.TYPE_SFIXED32: "TYPE_SFIXED32";
      case ProtobufType.TYPE_SFIXED64: "TYPE_SFIXED64";
      case ProtobufType.TYPE_SINT32: "TYPE_SINT32";
      case ProtobufType.TYPE_SINT64: "TYPE_SINT64";
      default: throw ProtobufError.BadDescriptor;
    }
  }

  static function getGetterDefinition(
    self:ProtoData,
    fullName:String,
    getterNameConverter:NameConverter.MessageNameConverter,
    messageNameConverter:NameConverter.MessageNameConverter,
    builderNameConverter:NameConverter.MessageNameConverter,
    enumNameConverter:NameConverter.EnumNameConverter,
    mergerNameConverter:NameConverter.UtilityNameConverter,
    field:FieldDescriptorProto):Field
  {
    var extendeeFullName = ProtoData.resolve(self.messages, fullName, field.extendee);
    return
    {
      name: getterNameConverter.toHaxeFieldName(field.name),
      pos: makeMacroPosition(),
      access: [ APublic, AStatic ],
      meta: [],
      kind: FFun(
        {
          args:
          [
            {
              name: "self",
              opt: false,
              type: TPath(
                {
                  pack: messageNameConverter.getHaxePackage(extendeeFullName),
                  name: messageNameConverter.getHaxeClassName(extendeeFullName),
                  params: [],
                }),
            }
          ],
          ret: null,
          params: [],
          expr:
          {
            var fieldNumberExpr =
            {
              pos: makeMacroPosition(),
              expr: EConst(CInt(Std.string(WireType.byType(field.type) | (field.number << 3)))),
            }
            var toExpr = switch (field.type)
            {
              case ProtobufType.TYPE_MESSAGE:
              {
                var resolvedFieldTypeName = ProtoData.resolve(self.messages, fullName, field.typeName);
                var fieldBuilderTypePath =
                {
                  params: [],
                  name: builderNameConverter.getHaxeClassName(resolvedFieldTypeName),
                  pack: builderNameConverter.getHaxePackage(resolvedFieldTypeName),
                };
                var nestedMergerPackage =
                  mergerNameConverter.getHaxePackage(resolvedFieldTypeName);
                var nestedMergerPackageExpr =
                  ExprTools.toFieldExpr(nestedMergerPackage);
                var nestedMergerName =
                  mergerNameConverter.getHaxeClassName(resolvedFieldTypeName);
                var nestedMergerClassExpr = packageDotClass(nestedMergerPackageExpr, nestedMergerName);
                var newFieldBuilderExpr =
                {
                  expr: ENew(fieldBuilderTypePath, []),
                  pos: makeMacroPosition(),
                };
                macro
                {
                  var bytesValue:haxe.io.Bytes = unknownField.toLengthDelimited();
                  var input = new com.dongxiguo.protobuf.binaryFormat.LimitableBytesInput(bytesValue, bytesValue.length);
                  var fieldBuilder = $newFieldBuilderExpr;
                  $nestedMergerClassExpr.mergeFrom(fieldBuilder, input);
                  fieldBuilder;
                }
              }
              case ProtobufType.TYPE_ENUM:
              {
                var resolvedFieldTypeName = ProtoData.resolve(self.enums, fullName, field.typeName);
                {
                  pos: makeMacroPosition(),
                  expr: ENew(
                    {
                      params: [],
                      pack: enumNameConverter.getHaxePackage(resolvedFieldTypeName),
                      name: enumNameConverter.getHaxeEnumName(resolvedFieldTypeName),
                    },
                    [ macro unknownField.toVarint().toInt32(), ]),
                }
              }
              default:
              {
                var rawValue = switch (WireType.byType(field.type))
                {
                  case WireType.LENGTH_DELIMITED:
                  {
                    macro unknownField.toLengthDelimited();
                  }
                  case WireType.VARINT:
                  {
                    macro unknownField.toVarint();
                  }
                  case WireType.FIXED_64_BIT:
                  {
                    macro unknownField.toFixed64Bit();
                  }
                  case WireType.FIXED_32_BIT:
                  {
                    macro unknownField.toFixed32Bit();
                  }
                  default:
                  {
                    throw ProtobufError.InvalidWireType;
                  }
                }
                var typeName:String = getTypeName(field.type);
                var toFunctionName = switch (typeName.split("_"))
                {
                  case [ "TYPE", upperCaseTypeName ]:
                  {
                    "to" + upperCaseTypeName.charAt(0) + upperCaseTypeName.substring(1).toLowerCase();
                  }
                  default:
                  {
                    throw ProtobufError.MalformedEnumConstructor;
                  }
                }
                macro $rawValue.$toFunctionName();
              }
            };
            switch (field.label)
            {
              case Label.LABEL_REQUIRED, Label.LABEL_OPTIONAL:
              {
                var tagExpr =
                {
                  pos: makeMacroPosition(),
                  expr: EConst(CInt(Std.string(
                    WireType.byType(field.type) | (field.number << 3)))),
                }
                var defaultExpr = switch (field.label)
                {
                  case Label.LABEL_REQUIRED:
                    macro throw com.dongxiguo.protobuf.Error.MissingRequiredFields;
                  case Label.LABEL_OPTIONAL:
                    if (field.defaultValue == null)
                    {
                      macro null;
                    }
                    else
                    {
                      ProtoData.makeDefaultValueExpr(fullName, field, self.enums, enumNameConverter);
                    }
                  default: throw "Unreachable code!";
                }
                macro
                {
                  var unknownField = self.unknownFields.get($fieldNumberExpr).toOptional();
                  return unknownField == null ? $defaultExpr : $toExpr;
                }
              }
              case Label.LABEL_REPEATED:
              {
                if (WireType.byType(field.type) == WireType.LENGTH_DELIMITED)
                {
                  macro
                  {
                    return
                    [
                      for (unknownField in self.unknownFields.get($fieldNumberExpr).toRepeated())
                      {
                        $toExpr;
                      }
                    ];
                  }
                }
                else
                {
                  var readExpr = switch (field.type)
                  {
                    case ProtobufType.TYPE_ENUM:
                    {
                      var resolvedFieldTypeName = ProtoData.resolve(self.enums, fullName, field.typeName);
                      {
                        pos: makeMacroPosition(),
                        expr: ENew(
                          {
                            params: [],
                            pack: enumNameConverter.getHaxePackage(resolvedFieldTypeName),
                            name: enumNameConverter.getHaxeEnumName(resolvedFieldTypeName),
                          },
                          [ macro com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input), ]),
                      }
                    }
                    default:
                    {
                      var typeName:String = getTypeName(field.type);
                      var readFunctionName = switch (typeName.split("_"))
                      {
                        case [ "TYPE", upperCaseTypeName ]:
                        {
                          "read" + upperCaseTypeName.charAt(0) + upperCaseTypeName.substring(1).toLowerCase();
                        }
                        default:
                        {
                          throw ProtobufError.MalformedEnumConstructor;
                        }
                      }
                      macro com.dongxiguo.protobuf.binaryFormat.ReadUtils.$readFunctionName(input);
                    }
                  };
                  var packedTagExpr =
                  {
                    pos: makeMacroPosition(),
                    expr: EConst(CInt(Std.string((field.number << 3 | WireType.LENGTH_DELIMITED)))),
                  }

                  macro
                  {
                    var result = [];
                    for (unknownField in self.unknownFields.get($fieldNumberExpr).toRepeated())
                    {
                      result.push($toExpr);
                    }
                    for (unknownField in self.unknownFields.get($packedTagExpr).toRepeated())
                    {
                      var bytesValue:haxe.io.Bytes = unknownField.toLengthDelimited();
                      var input = new com.dongxiguo.protobuf.binaryFormat.LimitableBytesInput(bytesValue);
                      while (input.limit > 0)
                      {
                        result.push($readExpr);
                      }
                    }
                    return result;
                  }
                }
              }
              default:
              {
                throw ProtobufError.BadDescriptor;
              }
            }
          }
        })
    }
  }

  public static function getPackageGetterDefinition(
    self:ProtoData,
    fullName:String,
    getterNameConverter:NameConverter.PackageExtensionNameConverter,
    messageNameConverter:NameConverter.MessageNameConverter,
    builderNameConverter:NameConverter.MessageNameConverter,
    enumNameConverter:NameConverter.EnumNameConverter,
    mergerNameConverter:NameConverter.UtilityNameConverter):Null<TypeDefinition>
  {
    var fields:Array<Field> =
    [
      for (file in self.packages.get(fullName))
      {
        for (field in file.extension)
        {
          switch (field.type)
          {
            case ProtobufType.TYPE_GROUP:
            {
              #if neko
              Context.warning("TYPE_GROUP is unsupported!", makeMacroPosition());
              {
                pos: makeMacroPosition(),
                expr: EBlock([]),
              }
              #else
              trace("TYPE_GROUP is unsupported!");
              #end
              continue;
            }
            default:
          }
          getGetterDefinition(
            self,
            fullName,
            getterNameConverter,
            messageNameConverter,
            builderNameConverter,
            enumNameConverter,
            mergerNameConverter,
            field);
        }
      }
    ];
    if (fields.length == 0)
    {
      return null;
    }
    return
    {
      pack: getterNameConverter.getHaxePackage(fullName),
      name: getterNameConverter.getHaxeClassName(fullName),
      pos: makeMacroPosition(),
      meta: [],
      params: [],
      isExtern: false,
      kind: TDClass(),
      fields: fields,
    };
  }

  public static function getMessageGetterDefinition(
    self:ProtoData,
    fullName:String,
    getterNameConverter:NameConverter.MessageNameConverter,
    messageNameConverter:NameConverter.MessageNameConverter,
    builderNameConverter:NameConverter.MessageNameConverter,
    enumNameConverter:NameConverter.EnumNameConverter,
    mergerNameConverter:NameConverter.UtilityNameConverter):Null<TypeDefinition>
  {
    var messageProto = self.messages.get(fullName);
    if (messageProto.extension.empty())
    {
      return null;
    }
    var fields:Array<Field> =
    [
      for (field in messageProto.extension)
      {
        switch (field.type)
        {
          case ProtobufType.TYPE_GROUP:
          {
            #if neko
            Context.warning("TYPE_GROUP is unsupported!", makeMacroPosition());
            {
              pos: makeMacroPosition(),
              expr: EBlock([]),
            }
            #else
            trace("TYPE_GROUP is unsupported!");
            #end
            continue;
          }
          default:
        }
        getGetterDefinition(
          self,
          fullName,
          getterNameConverter,
          messageNameConverter,
          builderNameConverter,
          enumNameConverter,
          mergerNameConverter,
          field);
      }
    ];
    return
    {
      pack: getterNameConverter.getHaxePackage(fullName),
      name: getterNameConverter.getHaxeClassName(fullName),
      pos: makeMacroPosition(),
      meta: [],
      params: [],
      isExtern: false,
      kind: TDClass(),
      fields: fields,
    };
  }
}
