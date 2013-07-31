package com.dongxiguo.protobuf.compiler;

import com.dongxiguo.protobuf.Error;
import com.dongxiguo.protobuf.binaryFormat.IBinaryInput;
import com.dongxiguo.protobuf.binaryFormat.WireType;
import com.dongxiguo.protobuf.compiler.NameConverter;
import com.dongxiguo.protobuf.compiler.ProtoData;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumDescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.ExprTools;

#if haxe3
import haxe.ds.IntMap;
import haxe.ds.StringMap;
#else
private typedef IntMap<Value> = IntHash<Value>;
private typedef StringMap<Value> = Hash<Value>;
#end
private typedef ProtobufType = com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type;

/**
 * @author 杨博
 */
@:final
class BinaryFormat
{

  static var MERGE_FROM_FUNCTION(null, never) =
    switch (macro function(builder, input):Void
    {
      com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeFrom(FIELD_MAP, builder, input);
    })
    {
      case { expr: EFunction(_, f), } : f;
      default: throw "Assertion failed!";
    };

  static var MERGE_DELIMITED_FROM_FUNCTION(null, never) =
    switch (macro function(builder, input):Void
    {
      com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeDelimitedFrom(FIELD_MAP, builder, input);
    })
    {
      case { expr: EFunction(_, f), } : f;
      default: throw "Assertion failed!";
    };

  static var BINARY_INPUT_COMPLEX_TYPE(default, never) = TPath(
    {
      pack: [ "com", "dongxiguo", "protobuf", "binaryFormat" ],
      name: "IBinaryInput",
      params: [],
    });

  public static function getMergerDefinition(
    self:ProtoData,
    fullyName:String,
    mergerNameConverter:UtilityNameConverter,
    builderNameConverter:MessageNameConverter,
    enumClassNameConverter:UtilityNameConverter):TypeDefinition
  {
    var builderType = TPath(
    {
      params: [],
      name: builderNameConverter.getHaxeClassName(fullyName),
      pack: builderNameConverter.getHaxePackage(fullyName),
    });
    var fieldMapTypePath =
    {
      pack: [ "com", "dongxiguo", "protobuf", "binaryFormat" ],
      name: "ReadUtils",
      sub: "FieldMap",
      params: [ TPType(builderType) ],
    };
    var newFieldMapExpr =
    {
      pos: Context.currentPos(),
      expr: ENew(fieldMapTypePath, []),
    }
    var insertions = [];
    for (field in self.messages.get(fullyName).field)
    {
      if (field.extendee != null)
      {
        throw Error.BadDescriptor;
      }
      var fieldName = builderNameConverter.toHaxeFieldName(field.name);
      var readFunctionName = switch (Type.enumConstructor(field.type).split("_"))
      {
        case [ "TYPE", upperCaseTypeName ]:
        {
          "read" + upperCaseTypeName.charAt(0) + upperCaseTypeName.substring(1).toLowerCase();
        }
        default:
        {
          throw Error.MalformedEnumConstructor;
        }
      }
      var readExpr = switch (field.type)
      {
        case ProtobufType.TYPE_MESSAGE:
        {
          var resolvedFieldTypeName = ProtoData.resolve(self.messages, fullyName, field.typeName);
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
          var nestedFieldMapExpr = macro $nestedMergerPackageExpr.$nestedMergerName.FIELD_MAP;
          var newFieldBuilderExpr =
          {
            expr: ENew(fieldBuilderTypePath, []),
            pos: Context.currentPos(),
          };
          macro
          {
            var fieldBuilder = $newFieldBuilderExpr;
            com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeDelimitedFrom($nestedFieldMapExpr, fieldBuilder, input);
            fieldBuilder;
          };
        }
        case ProtobufType.TYPE_ENUM:
        {
          var resolvedFieldTypeName = ProtoData.resolve(self.enums, fullyName, field.typeName);
          var enumPackageExpr = ExprTools.toFieldExpr(enumClassNameConverter.getHaxePackage(resolvedFieldTypeName));
          var enumClassName = enumClassNameConverter.getHaxeClassName(resolvedFieldTypeName);
          macro $enumPackageExpr.$enumClassName.valueOf(
            com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input));
        }
        default:
        {
          macro com.dongxiguo.protobuf.binaryFormat.ReadUtils.$readFunctionName(input);
        }
      };
      switch (WireType.byType(field.type))
      {
        case WireType.LENGTH_DELIMITED:
        {
          // Types that does not support packed repeated fields.
          var tagExpr = Context.makeExpr(
            WireType.byType(field.type) | (field.number << 3),
            Context.currentPos());
          var functionExpr =
          {
            pos: Context.currentPos(),
            expr: EFunction(
              null,
              {
                params: [],
                args:
                [
                  {
                    opt: false,
                    name: "builder",
                    type: builderType,
                  },
                  {
                    opt: false,
                    name: "input",
                    type: BINARY_INPUT_COMPLEX_TYPE,
                  },
                ],
                ret: null,
                expr: switch (field.label)
                {
                  case LABEL_REQUIRED, LABEL_OPTIONAL:
                  {
                    macro builder.$fieldName = $readExpr;
                  }
                  case LABEL_REPEATED:
                  {
                    macro builder.$fieldName.push($readExpr);
                  }
                },
              }),
          }
          insertions.push(macro fieldMap.set($tagExpr, $functionExpr));
        }
        default:
        {
          // Types that supports packed repeated fields.
          var nonPackedTagExpr = Context.makeExpr(
            WireType.byType(field.type) | (field.number << 3),
            Context.currentPos());
          switch (field.label)
          {
            case LABEL_REQUIRED, LABEL_OPTIONAL:
            {
              var functionExpr =
              {
                pos: Context.currentPos(),
                expr: EFunction(
                  null,
                  {
                    params: [],
                    args:
                    [
                      {
                        opt: false,
                        name: "builder",
                        type: builderType,
                      },
                      {
                        opt: false,
                        name: "input",
                        type: BINARY_INPUT_COMPLEX_TYPE,
                      },
                    ],
                    ret: null,
                    expr: macro builder.$fieldName = $readExpr,
                  }),
              }
              insertions.push(macro fieldMap.set($nonPackedTagExpr, $functionExpr));
            }
            case LABEL_REPEATED:
            {
              var nonPackedFunctionExpr =
              {
                pos: Context.currentPos(),
                expr: EFunction(
                  null,
                  {
                    params: [],
                    args:
                    [
                      {
                        opt: false,
                        name: "builder",
                        type: builderType,
                      },
                      {
                        opt: false,
                        name: "input",
                        type: BINARY_INPUT_COMPLEX_TYPE,
                      },
                    ],
                    ret: null,
                    expr: macro builder.$fieldName.push($readExpr),
                  }),
              }
              insertions.push(macro fieldMap.set($nonPackedTagExpr, $nonPackedFunctionExpr));
              var packedTagExpr = Context.makeExpr(
                WireType.LENGTH_DELIMITED | (field.number << 3),
                Context.currentPos());
              var packedFunctionExpr =
              {
                pos: Context.currentPos(),
                expr: EFunction(
                  null,
                  {
                    params: [],
                    args:
                    [
                      {
                        opt: false,
                        name: "builder",
                        type: builderType,
                      },
                      {
                        opt: false,
                        name: "input",
                        type: BINARY_INPUT_COMPLEX_TYPE,
                      },
                    ],
                    ret: null,
                    expr: macro
                    {
                      var limit = com.dongxiguo.protobuf.binaryFormat.ReadUtils.readUint32(input);
                      var bytesAfterSlice = input.numBytesAvailable - limit;
                      input.numBytesAvailable = limit;
                      while (input.numBytesAvailable > 0)
                      {
                        builder.$fieldName.push($readExpr);
                      }
                      input.numBytesAvailable = bytesAfterSlice;
                    },
                  }),
              }
              insertions.push(macro fieldMap.set($packedTagExpr, $packedFunctionExpr));
            }
          }
        }
      }
    }

    // TODO: Extension

    return
    {
      pack: mergerNameConverter.getHaxePackage(fullyName),
      name: mergerNameConverter.getHaxeClassName(fullyName),
      pos: Context.currentPos(),
      meta: [],
      params: [],
      isExtern: false,
      kind: TDClass(),
      fields:
      [
        {
          name: "FIELD_MAP",
          access: [ APublic, AStatic ],
          pos: Context.currentPos(),
          kind: FProp(
            "default", "never", TPath(fieldMapTypePath),
            {
              pos: Context.currentPos(),
              expr: EBlock(
                [
                  (macro var fieldMap = $newFieldMapExpr),
                  {
                    pos: Context.currentPos(),
                    expr: EBlock(insertions),
                  },
                  macro fieldMap,
                ]),
            })
        },
        {
          name: "mergeFrom",
          access: [ APublic, AStatic, AInline ],
          pos: Context.currentPos(),
          meta: [],
          kind: FFun(MERGE_FROM_FUNCTION)
        },
        {
          name: "mergeDelimitedFrom",
          access: [ APublic, AStatic, AInline ],
          pos: Context.currentPos(),
          meta: [],
          kind: FFun(MERGE_DELIMITED_FROM_FUNCTION)
        }
      ]
    };
  }

  static var WRITE_TO_FUNCTION(null, never) =
    switch (macro function(message, output:haxe.io.Output):Void
    {
      var buffer = new com.dongxiguo.protobuf.binaryFormat.WritingBuffer();
      writeFields(message, buffer);
      buffer.toNormal(output);
    })
    {
      case { expr: EFunction(_, f), } : f;
      default: throw "Assertion failed!";
    };

}

