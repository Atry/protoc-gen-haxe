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

import com.dongxiguo.protobuf.binaryFormat.ILimitableInput;
import com.dongxiguo.protobuf.WireType;
import com.dongxiguo.protobuf.compiler.NameConverter;
import com.dongxiguo.protobuf.compiler.ProtoData;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumDescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label;
import haxe.macro.Expr;
#if neko
import haxe.macro.Context;
#end
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
      name: "ILimitableInput",
      params: [],
    });

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

  static function makeTagExpr(tag:Int):Expr
  {
    return
    {
      pos: makeMacroPosition(),
      expr: EConst(CInt(Std.string(tag))),
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

  public static function getMergerDefinition(
    self:ProtoData,
    fullName:String,
    mergerNameConverter:UtilityNameConverter,
    builderNameConverter:MessageNameConverter,
    enumNameConverter:EnumNameConverter):TypeDefinition
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
                  case Label.LABEL_REQUIRED, Label.LABEL_OPTIONAL:
                  {
                    macro builder.$fieldName = $readExpr;
                  }
                  case Label.LABEL_REPEATED:
                  {
                    macro builder.$fieldName.push($readExpr);
                  }
                  default:
                  {
                    throw ProtobufError.BadDescriptor;
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
            case Label.LABEL_REQUIRED, Label.LABEL_OPTIONAL:
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
            case Label.LABEL_REPEATED:
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
                      var bytesAfterSlice = input.limit - limit;
                      input.limit = limit;
                      while (input.limit > 0)
                      {
                        builder.$fieldName.push($readExpr);
                      }
                      input.limit = bytesAfterSlice;
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

  static var WRITE_TO_FUNCTION_BODY(null, never) = macro
  {
    var buffer = new com.dongxiguo.protobuf.binaryFormat.WritingBuffer();
    writeFields(message, buffer);
    com.dongxiguo.protobuf.binaryFormat.WriteUtils.writeUnknownField(
      buffer,
      message.unknownFields);
    buffer.toNormal(output);
  };

  static var WRITE_DELIMITED_TO_FUNCTION_BODY(null, never) = macro
  {
    var buffer = new com.dongxiguo.protobuf.binaryFormat.WritingBuffer();
    var i = buffer.beginBlock();
    writeFields(message, buffer);
    com.dongxiguo.protobuf.binaryFormat.WriteUtils.writeUnknownField(
      buffer,
      message.unknownFields);
    buffer.endBlock(i);
    buffer.toNormal(buffer);
  };

  static var WRITING_BUFFER_COMPLEX_TYPE(default, never) = TPath(
    {
      pack: [ "com", "dongxiguo", "protobuf", "binaryFormat" ],
      name: "WritingBuffer",
      params: [],
    });

  static var OUTPUT_COMPLEX_TYPE(default, never) = TPath(
    {
      pack: [ "haxe", "io" ],
      name: "Output",
      params: [],
    });

  public static function getWriterDefinition(
    self:ProtoData,
    fullName:String,
    writerNameConverter:UtilityNameConverter,
    messageNameConverter:MessageNameConverter):TypeDefinition
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
          meta:
          [
            // This must be disabled before https://github.com/HaxeFoundation/haxe/issues/2070 being resolved
            /*
            {
              name: ":generic",
              params: [],
              pos: makeMacroPosition(),
            }
            */
          ],
          kind: FFun(
            {
              params:
              [
                {
                  name: "MessageTypeParameter",
                  constraints:
                  [
                    messageType,
                  ]
                }
              ],
              args:
              [
                {
                  name: "message",
                  opt: false,
                  type: TPath(
                    {
                      pack: [],
                      name: "MessageTypeParameter",
                      params: [],
                    }),
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
                        case ProtobufType.TYPE_ENUM:
                        {
                          macro com.dongxiguo.protobuf.binaryFormat.WriteUtils.writeUint32(buffer, fieldValue.number);
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
                          macro com.dongxiguo.protobuf.binaryFormat.WriteUtils.$writeFunctionName(buffer, fieldValue);
                        }
                      }
                      switch (field.label)
                      {
                        case Label.LABEL_OPTIONAL:
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
                        case Label.LABEL_REQUIRED:
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
                        case Label.LABEL_REPEATED:
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
                        default:
                        {
                          throw 'Unknown label: ${field.label}';
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
          meta:
          [
            // This must be disabled before https://github.com/HaxeFoundation/haxe/issues/2070 being resolved
            /*
            {
              name: ":generic",
              params: [],
              pos: makeMacroPosition(),
            }
            */
          ],
          kind: FFun(
            {
              params:
              [
                {
                  name: "MessageTypeParameter",
                  constraints:
                  [
                    messageType,
                  ]
                }
              ],
              args:
              [
                {
                  name: "message",
                  opt: false,
                  type: TPath(
                    {
                      pack: [],
                      name: "MessageTypeParameter",
                      params: [],
                    }),
                  value: null,
                },
                {
                  name: "output",
                  opt: false,
                  type: OUTPUT_COMPLEX_TYPE,
                  value: null,
                },
              ],
              ret: null,
              expr: WRITE_TO_FUNCTION_BODY
            })
        },
        {
          name: "writeDelimitedTo",
          access: [ APublic, AStatic, AInline ],
          pos: makeMacroPosition(),
          meta:
          [
            // This must be disabled before https://github.com/HaxeFoundation/haxe/issues/2070 being resolved
            /*
            {
              name: ":generic",
              params: [],
              pos: makeMacroPosition(),
            }
            */
          ],
          kind: FFun(
            {
              params:
              [
                {
                  name: "MessageTypeParameter",
                  constraints:
                  [
                    messageType,
                  ]
                }
              ],
              args:
              [
                {
                  name: "message",
                  opt: false,
                  type: TPath(
                    {
                      pack: [],
                      name: "MessageTypeParameter",
                      params: [],
                    }),
                  value: null,
                },
                {
                  name: "output",
                  opt: false,
                  type: OUTPUT_COMPLEX_TYPE,
                  value: null,
                },
              ],
              ret: null,
              expr: WRITE_DELIMITED_TO_FUNCTION_BODY
            })
        }
      ]
    };
  }

}

