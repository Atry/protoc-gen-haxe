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

import com.dongxiguo.protobuf.binaryFormat.IBinaryInput;
import com.dongxiguo.protobuf.WireType;
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
import haxe.PosInfos;

#if haxe3
import haxe.ds.IntMap;
import haxe.ds.StringMap;
#else
private typedef IntMap<Value> = IntHash<Value>;
private typedef StringMap<Value> = Hash<Value>;
#end
private typedef ProtobufType = com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type;
private typedef ProtobufError = com.dongxiguo.protobuf.Error;

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

  static function makeTagExpr(tag:Int):Expr
  {
    return
    {
      pos: makeMacroPosition(),
      expr: EConst(CInt(Std.string(tag))),
    };
  }

  public static function getMergerDefinition(
    self:ProtoData,
    fullName:String,
    mergerNameConverter:UtilityNameConverter,
    builderNameConverter:MessageNameConverter,
    enumClassNameConverter:UtilityNameConverter):TypeDefinition
  {
    var builderType = TPath(
    {
      params: [],
      name: builderNameConverter.getHaxeClassName(fullName),
      pack: builderNameConverter.getHaxePackage(fullName),
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
      pos: makeMacroPosition(),
      expr: ENew(fieldMapTypePath, []),
    }
    var insertions = [];
    for (field in self.messages.get(fullName).field)
    {
      if (field.extendee != null)
      {
        throw ProtobufError.BadDescriptor;
      }
      var fieldName = builderNameConverter.toHaxeFieldName(field.name);
      var readExpr = switch (field.type)
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
          var newFieldBuilderExpr =
          {
            expr: ENew(fieldBuilderTypePath, []),
            pos: makeMacroPosition(),
          };
          macro
          {
            var fieldBuilder = $newFieldBuilderExpr;
            $nestedMergerPackageExpr.$nestedMergerName.mergeDelimitedFrom(fieldBuilder, input);
            fieldBuilder;
          };
        }
        case ProtobufType.TYPE_ENUM:
        {
          var resolvedFieldTypeName = ProtoData.resolve(self.enums, fullName, field.typeName);
          var enumPackageExpr = ExprTools.toFieldExpr(enumClassNameConverter.getHaxePackage(resolvedFieldTypeName));
          var enumClassName = enumClassNameConverter.getHaxeClassName(resolvedFieldTypeName);
          macro $enumPackageExpr.$enumClassName.valueOf(
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
      switch (WireType.byType(field.type))
      {
        case WireType.LENGTH_DELIMITED:
        {
          // Types that does not support packed repeated fields.
          var tagExpr =
            makeTagExpr(WireType.byType(field.type) | (field.number << 3));
          var functionExpr =
          {
            pos: makeMacroPosition(),
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
          var nonPackedTagExpr =
            makeTagExpr(WireType.byType(field.type) | (field.number << 3));
          switch (field.label)
          {
            case LABEL_REQUIRED, LABEL_OPTIONAL:
            {
              var functionExpr =
              {
                pos: makeMacroPosition(),
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
                pos: makeMacroPosition(),
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
              var packedTagExpr =
                makeTagExpr(
                  WireType.LENGTH_DELIMITED | (field.number << 3));
              var packedFunctionExpr =
              {
                pos: makeMacroPosition(),
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
    return
    {
      pack: mergerNameConverter.getHaxePackage(fullName),
      name: mergerNameConverter.getHaxeClassName(fullName),
      pos: makeMacroPosition(),
      meta: [],
      params: [],
      isExtern: false,
      kind: TDClass(),
      fields:
      [
        {
          name: "FIELD_MAP",
          access: [ AStatic ],
          pos: makeMacroPosition(),
          kind: FProp(
            "default", "never", TPath(fieldMapTypePath),
            {
              pos: makeMacroPosition(),
              expr: EBlock(
                [
                  (macro var fieldMap = $newFieldMapExpr),
                  {
                    pos: makeMacroPosition(),
                    expr: EBlock(insertions),
                  },
                  macro fieldMap,
                ]),
            })
        },
        {
          name: "mergeFrom",
          access: [ APublic, AStatic, AInline ],
          pos: makeMacroPosition(),
          meta: [],
          kind: FFun(MERGE_FROM_FUNCTION)
        },
        {
          name: "mergeDelimitedFrom",
          access: [ APublic, AStatic, AInline ],
          pos: makeMacroPosition(),
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
      com.dongxiguo.protobuf.binaryFormat.WriteUtils.writeUnknownField(
        buffer,
        message.unknownFields);
      buffer.toNormal(output);
    })
    {
      case { expr: EFunction(_, f), } : f;
      default: throw "Assertion failed!";
    };

  static var WRITE_DELIMITED_TO_FUNCTION(null, never) =
    switch (macro function(message, output:haxe.io.Output):Void
    {
      var buffer = new com.dongxiguo.protobuf.binaryFormat.WritingBuffer();
      var i = buffer.beginBlock();
      writeFields(message, buffer);
      com.dongxiguo.protobuf.binaryFormat.WriteUtils.writeUnknownField(
        buffer,
        message.unknownFields);
      buffer.endBlock(i);
      buffer.toNormal(buffer);
    })
    {
      case { expr: EFunction(_, f), } : f;
      default: throw "Assertion failed!";
    };

  static var WRITING_BUFFER_COMPLEX_TYPE(default, never) = TPath(
    {
      pack: [ "com", "dongxiguo", "protobuf", "binaryFormat" ],
      name: "WritingBuffer",
      params: [],
    });

  public static function getWriterDefinition(
    self:ProtoData,
    fullName:String,
    writerNameConverter:UtilityNameConverter,
    messageNameConverter:MessageNameConverter,
    enumClassNameConverter:UtilityNameConverter):TypeDefinition
  {
    var messageType = TPath(
    {
      params: [],
      name: messageNameConverter.getHaxeClassName(fullName),
      pack: messageNameConverter.getHaxePackage(fullName),
    });

    return
    {
      pack: writerNameConverter.getHaxePackage(fullName),
      name: writerNameConverter.getHaxeClassName(fullName),
      pos: makeMacroPosition(),
      meta: [],
      params: [],
      isExtern: false,
      kind: TDClass(),
      fields:
      [
        {
          name: "writeFields",
          access: [ AStatic, APublic ],
          pos: makeMacroPosition(),
          meta: [],
          kind: FFun(
            {
              params: [],
              args:
              [
                {
                  name: "message",
                  opt: false,
                  type: messageType,
                  value: null,
                },
                {
                  name: "buffer",
                  opt: false,
                  type: WRITING_BUFFER_COMPLEX_TYPE,
                  value: null,
                },
              ],
              ret: null,
              expr:
              {
                pos: makeMacroPosition(),
                expr: EBlock(
                  [
                    for (field in self.messages.get(fullName).field)
                    {
                      if (field.extendee != null)
                      {
                        throw ProtobufError.BadDescriptor;
                      }
                      var fieldName = messageNameConverter.toHaxeFieldName(field.name);
                      var writeField = switch (field.type)
                      {
                        case ProtobufType.TYPE_GROUP:
                        {
                          Context.warning("TYPE_GROUP is unsupported!", makeMacroPosition());
                          {
                            pos: makeMacroPosition(),
                            expr: EBlock([]),
                          }
                        }
                        case ProtobufType.TYPE_ENUM:
                        {
                          var resolvedFieldTypeName = ProtoData.resolve(self.enums, fullName, field.typeName);
                          var enumPackageExpr = ExprTools.toFieldExpr(enumClassNameConverter.getHaxePackage(resolvedFieldTypeName));
                          var enumClassName = enumClassNameConverter.getHaxeClassName(resolvedFieldTypeName);
                          macro com.dongxiguo.protobuf.binaryFormat.WriteUtils.writeUint32(buffer, $enumPackageExpr.$enumClassName.getNumber(fieldValue));
                        }
                        case ProtobufType.TYPE_MESSAGE:
                        {
                          var resolvedFieldTypeName = ProtoData.resolve(self.messages, fullName, field.typeName);
                          var nestedWriterPackage =
                            writerNameConverter.getHaxePackage(resolvedFieldTypeName);
                          var nestedWriterPackageExpr =
                            ExprTools.toFieldExpr(nestedWriterPackage);
                          var nestedWriterName =
                            writerNameConverter.getHaxeClassName(resolvedFieldTypeName);
                          macro
                          {
                            var i = buffer.beginBlock();
                            $nestedWriterPackageExpr.$nestedWriterName.writeFields(fieldValue, buffer);
                            buffer.endBlock(i);
                          }
                        }
                        default:
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
                          macro com.dongxiguo.protobuf.binaryFormat.WriteUtils.$writeFunctionName(buffer, fieldValue);
                        }
                      }
                      switch (field.label)
                      {
                        case LABEL_OPTIONAL:
                        {
                          var tagExpr =
                            makeTagExpr(
                              WireType.byType(field.type) | (field.number << 3));
                          macro
                          {
                            var fieldValue = message.$fieldName;
                            if (fieldValue != null)
                            {
                              com.dongxiguo.protobuf.binaryFormat.WriteUtils.writeUint32(buffer, $tagExpr);
                              $writeField;
                            }
                          }
                        }
                        case LABEL_REQUIRED:
                        {
                          var tagExpr =
                            makeTagExpr(
                              WireType.byType(field.type) | (field.number << 3));
                          macro
                          {
                            var fieldValue = message.$fieldName;
                            com.dongxiguo.protobuf.binaryFormat.WriteUtils.writeUint32(buffer, $tagExpr);
                            $writeField;
                          }
                        }
                        case LABEL_REPEATED:
                        {
                          if (field.options != null && field.options.packed)
                          {
                            var tagExpr =
                              makeTagExpr(
                                WireType.LENGTH_DELIMITED | (field.number << 3));
                            macro
                            {
                              com.dongxiguo.protobuf.binaryFormat.WriteUtils.writeUint32(buffer, $tagExpr);
                              var i = buffer.beginBlock();
                              for (fieldValue in message.$fieldName)
                              {
                                $writeField;
                              }
                              buffer.endBlock(i);
                            }
                          }
                          else
                          {
                            var tagExpr =
                              makeTagExpr(
                                WireType.byType(field.type) | (field.number << 3));
                            macro
                            {
                              for (fieldValue in message.$fieldName)
                              {
                                com.dongxiguo.protobuf.binaryFormat.WriteUtils.writeUint32(buffer, $tagExpr);
                                $writeField;
                              }
                            }
                          }
                        }
                      }
                    }
                  ]),
              }
            })
        },
        {
          name: "writeTo",
          access: [ APublic, AStatic, AInline ],
          pos: makeMacroPosition(),
          meta: [],
          kind: FFun(WRITE_TO_FUNCTION)
        },
        {
          name: "writeDelimitedTo",
          access: [ APublic, AStatic, AInline ],
          pos: makeMacroPosition(),
          meta: [],
          kind: FFun(WRITE_DELIMITED_TO_FUNCTION)
        }
      ]
    };
  }

}

