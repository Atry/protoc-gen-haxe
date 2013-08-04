package com.dongxiguo.protobuf.compiler;
import com.dongxiguo.protobuf.binaryFormat.WritingBuffer;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto;
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

  static function makeMacroPosition(?posInfos:PosInfos):Position
  {
    #if macro
    return Context.currentPos();
    #else
    return
    {
      min: 0,
      max: 0,
      file: posInfos.fileName,
    };
    #end
  }

  static var UNKNOWN_FIELD_COMPLEX_TYPE(default, never) = TPath(
    {
      pack: [ "com", "dongxiguo", "protobuf" ],
      name: "UnknownField",
      params:
      [
        TPType(TPath(
          {
            pack: [],
            name: "Dynamic",
            params: [],
          })),
      ],
    });

  static var ARRAY_UNKNOWN_FIELD_COMPLEX_TYPE = ComplexType.TPath(
  {
    pack: [],
    name: "Array",
    params: [ TPType(UNKNOWN_FIELD_COMPLEX_TYPE) ],
  });

  static var SORTED_UNKNOWN_FIELDS_READER(default, never) = TypeDefKind.TDAbstract(
    ARRAY_UNKNOWN_FIELD_COMPLEX_TYPE,
    null,
    [ ARRAY_UNKNOWN_FIELD_COMPLEX_TYPE ]);

  static var EXTENSION_READER_NEW_FIELD(default, never):Field =
  {
    name: "new",
    pos: makeMacroPosition(),
    access: [ AInline ],
    kind: FFun(
      {
        args:
        [
          {
            name: "sortedArray",
            opt: false,
            type: ARRAY_UNKNOWN_FIELD_COMPLEX_TYPE,
          }
        ],
        ret: null,
        params: [],
        expr: macro { this = sortedArray; },
      }),
  };

  static function getSetterDefinition(
    self:ProtoData,
    fullName:String,
    setterNameConverter:NameConverter.PackageExtensionNameConverter,
    builderNameConverter:NameConverter.MessageNameConverter,
    enumClassNameConverter:NameConverter.UtilityNameConverter,
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
            $nestedWriterExpr.writeTo(value, output);
            output.getBytes();
          }
        }
        case ProtobufType.TYPE_ENUM:
        {
          var resolvedFieldTypeName = ProtoData.resolve(self.enums, fullName, field.typeName);
          var enumPackageExpr = ExprTools.toFieldExpr(enumClassNameConverter.getHaxePackage(resolvedFieldTypeName));
          var enumClassName = enumClassNameConverter.getHaxeClassName(resolvedFieldTypeName);
          var nestedEnumClassExpr = packageDotClass(enumPackageExpr, enumClassName);
          return macro com.dongxiguo.protobuf.UnknownField.fromOptional(com.dongxiguo.protobuf.UnknownField.VarintUnknownField.fromInt32($nestedEnumClassExpr.getNumber(value)));
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
          var fromFunctionName = switch (Type.enumConstructor(field.type).split("_"))
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
          return macro com.dongxiguo.protobuf.UnknownField.fromOptional(com.dongxiguo.protobuf.UnknownField.$abstractTypeName.$fromFunctionName($valueExpr));
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
              case LABEL_OPTIONAL, LABEL_REQUIRED:
              {
                var nonPackedTagExpr =
                {
                  pos: makeMacroPosition(),
                  expr: EConst(CInt(Std.string(
                    WireType.byType(field.type) | (field.number << 3)))),
                }
                var unknownFieldValueExpr = unknownFieldFromValue(macro value);
                var requiredExpr =
                macro
                {
                  var unknownFields = self.unknownFields;
                  if (unknownFields == null)
                  {
                    unknownFields = new com.dongxiguo.protobuf.UnknownField.UnknownFieldMap();
                    self.unknownFields = unknownFields;
                  }
                  unknownFields.set($nonPackedTagExpr, $unknownFieldValueExpr);
                }
                if (field.label == LABEL_REQUIRED)
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
              case LABEL_REPEATED:
              {
                if (field.options != null && field.options.packed)
                {
                  var writeFunctionName = switch (Type.enumConstructor(field.type).split("_"))
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
                  var packedTagExpr =
                  {
                    pos: makeMacroPosition(),
                    expr: EConst(CInt(Std.string(
                      WireType.LENGTH_DELIMITED | (field.number << 3)))),
                  }
                  macro
                  {
                    var buffer = new com.dongxiguo.protobuf.binaryFormat.WritingBuffer();
                    for (element in value)
                    {
                      com.dongxiguo.protobuf.binaryFormat.WriteUtils.$writeFunctionName(buffervalue);
                    }
                    var bytes = buffer.getBytes();
                    if (bytes.length > 0)
                    {
                      var unknownFields = self.unknownFields;
                      if (unknownFields == null)
                      {
                        unknownFields = new com.dongxiguo.protobuf.UnknownField.UnknownFieldMap();
                        self.unknownFields = unknownFields;
                      }
                      unknownFields.set($packedTagExpr, bytes);
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
                      unknownFields = new com.dongxiguo.protobuf.UnknownField.UnknownFieldMap();
                      self.unknownFields = unknownFields;
                    }
                    inline function dummy<T>(i:Iterable<T>) { }
                    dummy(value);
                    var fieldValues =
                    [
                      for (element in value)
                      {
                        $unknownFieldValueExpr;
                      }
                    ];
                    unknownFields.set($nonPackedTagExpr, fieldValues);
                  }
                }
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
    enumClassNameConverter:NameConverter.UtilityNameConverter,
    writerNameConverter:NameConverter.UtilityNameConverter):Null<TypeDefinition>
  {
    var fields:Array<Field> =
    [
      for (file in self.packages.get(fullName))
      {
        for (field in file.extension)
        {
          getSetterDefinition(
            self,
            fullName,
            setterNameConverter,
            builderNameConverter,
            enumClassNameConverter,
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
    enumClassNameConverter:NameConverter.UtilityNameConverter,
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
        getSetterDefinition(
          self,
          fullName,
          setterNameConverter,
          builderNameConverter,
          enumClassNameConverter,
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

  static function getGetterDefinition(
    self:ProtoData,
    fullName:String,
    getterNameConverter:NameConverter.MessageNameConverter,
    messageNameConverter:NameConverter.MessageNameConverter,
    builderNameConverter:NameConverter.MessageNameConverter,
    enumNameConverter:NameConverter.EnumNameConverter,
    enumClassNameConverter:NameConverter.UtilityNameConverter,
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
                macro if (unknownField.wireType == com.dongxiguo.protobuf.WireType.LENGTH_DELIMITED)
                {
                  var bytesValue:haxe.io.Bytes = unknownField.value;
                  var underlyingInput = new haxe.io.BytesInput(bytesValue);
                  var input = new com.dongxiguo.protobuf.binaryFormat.BinaryBytesInput(underlyingInput, bytesValue.length);
                  var fieldBuilder = $newFieldBuilderExpr;
                  $nestedMergerClassExpr.mergeFrom(fieldBuilder, input);
                  fieldBuilder;
                }
                else
                {
                  throw com.dongxiguo.protobuf.Error.InvalidWireType;
                };
              }
              case ProtobufType.TYPE_ENUM:
              {
                var resolvedFieldTypeName = ProtoData.resolve(self.enums, fullName, field.typeName);
                var enumPackageExpr = ExprTools.toFieldExpr(enumClassNameConverter.getHaxePackage(resolvedFieldTypeName));
                var enumClassName = enumClassNameConverter.getHaxeClassName(resolvedFieldTypeName);
                var enumClassExpr = packageDotClass(enumPackageExpr, enumClassName);
                macro $enumClassExpr.valueOf(unknownField.toVarint().toInt32());
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
                var toFunctionName = switch (Type.enumConstructor(field.type).split("_"))
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
              case LABEL_REQUIRED, LABEL_OPTIONAL:
              {
                var tagExpr =
                {
                  pos: makeMacroPosition(),
                  expr: EConst(CInt(Std.string(
                    WireType.byType(field.type) | (field.number << 3)))),
                }
                var defaultExpr = switch (field.label)
                {
                  case LABEL_REQUIRED:
                    macro throw com.dongxiguo.protobuf.Error.MissingRequiredFields;
                  case LABEL_OPTIONAL:
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
              case LABEL_REPEATED:
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
                      var enumPackageExpr = ExprTools.toFieldExpr(enumClassNameConverter.getHaxePackage(resolvedFieldTypeName));
                      var enumClassName = enumClassNameConverter.getHaxeClassName(resolvedFieldTypeName);
                      var enumClassExpr = packageDotClass(enumPackageExpr, enumClassName);
                      macro $enumClassExpr.valueOf(
                        com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input));
                    }
                    default:
                    {
                      var readFunctionName = switch (Type.enumConstructor(field.type).split("_"))
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
                      var underlyingInput = new haxe.io.BytesInput(bytesValue);
                      var input = new com.dongxiguo.protobuf.binaryFormat.BinaryBytesInput(underlyingInput, bytesValue.length);
                      while (input.numBytesAvailable > 0)
                      {
                        result.push($readExpr);
                      }
                    }
                    return result;
                  }
                }
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
    enumClassNameConverter:NameConverter.UtilityNameConverter,
    mergerNameConverter:NameConverter.UtilityNameConverter):Null<TypeDefinition>
  {
    var fields:Array<Field> =
    [
      for (file in self.packages.get(fullName))
      {
        for (field in file.extension)
        {
          getGetterDefinition(
            self,
            fullName,
            getterNameConverter,
            messageNameConverter,
            builderNameConverter,
            enumNameConverter,
            enumClassNameConverter,
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
    enumClassNameConverter:NameConverter.UtilityNameConverter,
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
        getGetterDefinition(
          self,
          fullName,
          getterNameConverter,
          messageNameConverter,
          builderNameConverter,
          enumNameConverter,
          enumClassNameConverter,
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