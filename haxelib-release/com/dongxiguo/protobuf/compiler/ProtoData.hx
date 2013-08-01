package com.dongxiguo.protobuf.compiler;
using Type;
import com.dongxiguo.protobuf.Error;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumDescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumValueDescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.ServiceDescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto;
import haxe.io.BytesData;
import haxe.io.BytesOutput;
import haxe.macro.Expr;
import haxe.Int64;
import haxe.macro.Context;
using StringTools;
#if haxe3
import haxe.ds.StringMap;
#else
private typedef StringMap<Value> = Hash<Value>;
#end

/**
 * @author 杨博
 */
@:final class ProtoData
{
  public var fileDescriptorSet(default, null):FileDescriptorSet;
  public var messages(default, null):ReadonlyStringMap<DescriptorProto>;
  public var enums(default, null):ReadonlyStringMap<EnumDescriptorProto>;

  public function new(fileDescriptorSet:FileDescriptorSet)
  {
    var messageMap:StringMap<DescriptorProto> = new StringMap<DescriptorProto>();
    var enumMap:StringMap<EnumDescriptorProto> = new StringMap<EnumDescriptorProto>();
    messages = messageMap;
    enums = enumMap;
    this.fileDescriptorSet = fileDescriptorSet;
    function addNestedMessagesAndEnums(prefix:String, messages:Iterable<DescriptorProto>):Void
    {
      for (message in messages)
      {
        var fullName = prefix + message.name;
        messageMap.set(fullName, message);
        var nestedPrefix = fullName + ".";
        for (p in message.enumType)
        {
          enumMap.set(nestedPrefix + p.name, p);
        }
        addNestedMessagesAndEnums(nestedPrefix, message.nestedType);
      }
    }

    for (file in fileDescriptorSet.file)
    {
      var prefix = file.package_ == null ? "." : '.${file.package_}.';
      for (p in file.enumType)
      {
        enumMap.set(prefix + p.name, p);
      }
      addNestedMessagesAndEnums(prefix, file.messageType);
    }

    // TODO: Extension

    //function addNestedExtensions(prefix:String, messages:Iterable<DescriptorProto>):Void
    //{
      //for (message in messages)
      //{
        //var fullName = prefix + message.name;
        //var nestedPrefix = fullName + ".";
        //for (p in message.extension)
        //{
          //var extendee = resolve(messageMap, fullName, p.extendee);
          //var a = extensionMap.get(extendee);
          //if (a == null)
          //{
            //a = [];
            //extensionMap.set(extendee, a);
          //}
          //a.push(NESTED_EXTENSION(fullName, p));
        //}
        //addNestedExtensions(nestedPrefix, message.nestedType);
      //}
    //}
    //for (file in fileDescriptorSet.file)
    //{
      //var prefix = '.${file.package_}.';
      //for (p in file.extension)
      //{
        //var extendee = resolve(messageMap, file.package_, p.extendee);
        //var a = extensionMap.get(extendee);
        //if (a == null)
        //{
          //a = [];
          //extensionMap.set(extendee, a);
        //}
        //a.push(GLOBAL_EXTENSION(file.package_, p));
      //}
      //addNestedExtensions(prefix, file.messageType);
    //}
  }

  public static function resolve<ProtoData>(map:ReadonlyStringMap<ProtoData>, from:String, path:String):String
  {
    if (path.startsWith("."))
    {
      if (map.exists(path))
      {
        return path;
      }
      else
      {
        return throw 'Cannot find out $path from $from.';
      }
    }
    else
    {
      var result = '$from.$path';
      if (map.exists(result))
      {
        return result;
      }
      else
      {
        if (from == "")
        {
          return throw 'Cannot find out $path from $from.';
        }
        else
        {
          return resolve(map, from.substring(0, from.lastIndexOf(".")), path);
        }
      }
    }
  }

  static function parseDefaultValue(field:FieldDescriptorProto):Dynamic
  {
    switch (field.type)
    {
      case Type.TYPE_BYTES:
      {
        return Parser.parseBytes(field.defaultValue);
      }
      case Type.TYPE_STRING:
      {
        return field.defaultValue;
      }
      case Type.TYPE_INT32, Type.TYPE_UINT32, Type.TYPE_FIXED32, Type.TYPE_SFIXED32, Type.TYPE_SINT32:
      {
        return Std.parseInt(field.defaultValue);
      }
      case Type.TYPE_BOOL:
      {
        switch (field.defaultValue)
        {
          case "true": return true;
          case "false": return false;
          default: throw 'TYPE_BOOL must not be "true" or "false"';
        }
      }
      case Type.TYPE_DOUBLE, Type.TYPE_FLOAT:
      {
        return Std.parseFloat(field.defaultValue);
      }
      case Type.TYPE_INT64, Type.TYPE_UINT64, Type.TYPE_FIXED64, Type.TYPE_SFIXED64, Type.TYPE_SINT64:
      {
        return Parser.parseInt64(field.defaultValue);
      }
      default:
      {
        throw '${field.type} must not have default value';
      }
    }
  }

  static function makeDefaultValueExpr(
    enclosingMessage:String,
    field:FieldDescriptorProto,
    enumMap:ReadonlyStringMap<EnumDescriptorProto>,
    nameConverter:NameConverter.EnumNameConverter):Expr
  {
    switch (field.type)
    {
      case Type.TYPE_BYTES:
      {
        var defaultValueStringExpr =
        {
          pos: Context.currentPos(),
          expr: EConst(CString(field.defaultValue)),
        };
        return macro com.dongxiguo.protobuf.EscapedBytesParser.parseBytes($defaultValueStringExpr);
      }
      case Type.TYPE_ENUM:
      {
        var typeName = resolve(enumMap, enclosingMessage, field.typeName);
        var haxeNameParts = nameConverter.getHaxePackage(field.typeName);
        haxeNameParts.push(nameConverter.getHaxeEnumName(field.typeName));
        haxeNameParts.push(nameConverter.toHaxeEnumConstructorName(field.defaultValue));
        return Context.parse(haxeNameParts.join("."), Context.currentPos());
      }
      case Type.TYPE_INT64, TYPE_UINT64, TYPE_FIXED64, TYPE_SFIXED64, TYPE_SINT64:
      {
        var defaultValueStringExpr =
        {
          pos: Context.currentPos(),
          expr: EConst(CString(field.defaultValue)),
        };
        return macro com.dongxiguo.protobuf.Int64Parser.parseInt64($defaultValueStringExpr);
      }
      default:
      {
        var defaultValue = parseDefaultValue(field);
        return Context.makeExpr(defaultValue, Context.currentPos());
      }
    }
  }

  public function getRealEnumClassDefinition(
    fullName:String,
    enumParserNameConverter:NameConverter.UtilityNameConverter,
    enumNameConverter:NameConverter.EnumNameConverter):TypeDefinition
  {
    var haxeEnumName = enumNameConverter.getHaxeEnumName(fullName);
    var haxeEnumPackage = enumNameConverter.getHaxePackage(fullName);
    var enumPackageExpr = Context.parse(haxeEnumPackage.join("."), Context.currentPos());
    var enumExpr = macro $enumPackageExpr.$haxeEnumName;

    var valueOfCases =
    [
      for (value in this.enums.get(fullName).value)
      {
        var constructorName = enumNameConverter.toHaxeEnumConstructorName(value.name);
        {
          guard: null,
          values: [ Context.makeExpr(value.number, Context.currentPos()), ],
          expr: macro { $enumExpr.$constructorName; },
        }
      }
    ];

    var getNumberCases =
    [
      for (value in this.enums.get(fullName).value)
      {
        var constructorName = enumNameConverter.toHaxeEnumConstructorName(value.name);
        {
          guard: null,
          values: [ macro $enumExpr.$constructorName, ],
          expr: Context.makeExpr(value.number, Context.currentPos()),
        }
      }
    ];

    return
    {
      pack: enumParserNameConverter.getHaxePackage(fullName),
      name: enumParserNameConverter.getHaxeClassName(fullName),
      pos: Context.currentPos(),
      meta: [],
      params: [],
      isExtern: false,
      kind: TDClass(),
      fields:
      [
        {
          name: "getNumber",
          access: [ AStatic, APublic ],
          meta: [],
          pos: Context.currentPos(),
          kind: FFun(
            {
              args:
              [
                {
                  name: "enumValue",
                  opt: false,
                  type: TPath(
                    {
                      pack: haxeEnumPackage,
                      name: haxeEnumName,
                      params: [],
                    }),
                }
              ],
              ret: TPath(
                {
                  pack: [],
                  name: "StdTypes",
                  sub: "Int",
                  params: [],
                }),
              expr:
              {
                pos: Context.currentPos(),
                expr: EReturn(
                  {
                    pos: Context.currentPos(),
                    expr: ESwitch(macro enumValue, getNumberCases, null),
                  }),
              },
              params: [],
            }),
        },
        {
          name: "valueOf",
          access: [ AStatic, APublic ],
          meta: [],
          pos: Context.currentPos(),
          kind: FFun(
            {
              args:
              [
                {
                  name: "number",
                  opt: false,
                  type: TPath(
                    {
                      pack: [],
                      name: "StdTypes",
                      sub: "Int",
                      params: [],
                    }),
                }
              ],
              ret: TPath(
                {
                  pack: haxeEnumPackage,
                  name: haxeEnumName,
                  params: [],
                }),
              expr:
              {
                pos: Context.currentPos(),
                expr: EReturn(
                  {
                    pos: Context.currentPos(),
                    expr: ESwitch(
                      macro number,
                      valueOfCases,
                      macro { throw "Unknown enum value: " + number; } ),
                  }),
              },
              params: [],
            }),
        }
      ],
    };

  }


  public function getFakeEnumClassDefinition(
    fullName:String,
    enumClassNameConverter:NameConverter.UtilityNameConverter,
    enumNameConverter:NameConverter.EnumNameConverter):TypeDefinition
  {
    var enumProto = enums.get(fullName);
    var fields:Array<Field> = [];
    for (value in enumProto.value)
    {
      fields.push(
        {
          access: [ AStatic, APublic, ],
          pos: Context.currentPos(),
          name: enumNameConverter.toHaxeEnumConstructorName(value.name),
          kind: FProp("default", "never", null, Context.makeExpr(value.number, Context.currentPos())),
        });
    }

    var enumPackage = enumNameConverter.getHaxePackage(fullName);
    var enumName = enumNameConverter.getHaxeEnumName(fullName);
    var nativeName = enumPackage.concat([enumName]).join(".");
    fields.push(
      {
        name: "valueOf",
        access: [ AStatic, APublic ],
        meta: [],
        pos: Context.currentPos(),
        kind: FFun(
          {
            args:
            [
              {
                name: "number",
                opt: false,
                type: TPath(
                  {
                    pack: [],
                    name: "StdTypes",
                    sub: "Int",
                    params: [],
                  }),
              }
            ],
            ret: TPath(
              {
                pack: enumPackage,
                name: enumName,
                params: [],
              }),
            expr: macro return cast number,
            params: [],
          }),
      });
    fields.push(
      {
        name: "getNumber",
        access: [ AStatic, APublic ],
        meta: [],
        pos: Context.currentPos(),
        kind: FFun(
          {
            args:
            [
              {
                name: "enumValue",
                opt: false,
                type: TPath(
                  {
                    pack: enumPackage,
                    name: enumName,
                    params: [],
                  }),
              }
            ],
            ret: TPath(
              {
                pack: [],
                name: "StdTypes",
                sub: "Int",
                params: [],
              }),
            expr: macro return cast enumValue,
            params: [],
          }),
      });
    return
    {
      pack: enumClassNameConverter.getHaxePackage(fullName),
      name: enumClassNameConverter.getHaxeClassName(fullName),
      pos: Context.currentPos(),
      meta: [{
          name: ":native",
          pos: Context.currentPos(),
          params: [ Context.makeExpr(nativeName, Context.currentPos()) ],
        }],
      params: [],
      isExtern: false,
      kind: TDClass(),
      fields: fields,
    };
  }

  function getEnumDefinition(
    fullName:String,
    enumNameConverter:NameConverter.EnumNameConverter,
    fakeEnumBehavior:FakeEnumBehavior):TypeDefinition
  {
    var fields:Array<Field> = [];
    var enumProto = enums.get(fullName);
    for (value in enumProto.value)
    {
      fields.push(
        {
          access: [],
          pos: Context.currentPos(),
          name: enumNameConverter.toHaxeEnumConstructorName(value.name),
          kind: FVar(null),
        });
    }
    var isFakeEnum = switch (fakeEnumBehavior)
    {
      case FakeEnumBehavior.ALWAYS: true;
      case FakeEnumBehavior.NEVER: false;
      case FakeEnumBehavior.ALLOW_ALIAS_ONLY:
      {
        enumProto.options == null || enumProto.options.allowAlias;
      }
    }
    return
    {
      pack: enumNameConverter.getHaxePackage(fullName),
      name: enumNameConverter.getHaxeEnumName(fullName),
      pos: Context.currentPos(),
      meta: isFakeEnum ?
      [
        {
          name: ":fakeEnum",
          pos: Context.currentPos(),
          params: [ macro StdTypes.Int ],
        }
      ] : [],
      params: [],
      isExtern: isFakeEnum,
      kind: TDEnum,
      fields: fields,
    };
  }

  public function getFakeEnumDefinition(
    fullName:String,
    enumNameConverter:NameConverter.EnumNameConverter):TypeDefinition
  {
    return getEnumDefinition(fullName, enumNameConverter, FakeEnumBehavior.ALWAYS);
  }

  public function getRealEnumDefinition(
    fullName:String,
    enumNameConverter:NameConverter.EnumNameConverter):TypeDefinition
  {
    return getEnumDefinition(fullName, enumNameConverter, FakeEnumBehavior.NEVER);
  }

  function getMessageDefinition(
    fullName:String,
    messageNameConverter:NameConverter.MessageNameConverter,
    enumNameConverter:NameConverter.EnumNameConverter,
    readonly:Bool):TypeDefinition
  {
    function toHaxeType(
      protoType:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type,
      protoTypeName:Null<String>):ComplexType
    {
      switch (protoType)
      {
        case Type.TYPE_ENUM:
        {
          var fullyQualifiedName = resolve(enums, fullName, protoTypeName);
          return TPath(
          {
            params: [],
            name: enumNameConverter.getHaxeEnumName(fullyQualifiedName),
            pack: enumNameConverter.getHaxePackage(fullyQualifiedName),
          });
        }
        case Type.TYPE_MESSAGE:
        {
          var fullyQualifiedName = resolve(messages, fullName, protoTypeName);
          return TPath(
          {
            params: [],
            name: messageNameConverter.getHaxeClassName(fullyQualifiedName),
            pack: messageNameConverter.getHaxePackage(fullyQualifiedName),
          });
        }
        default:
        {
          return TPath(
          {
            params: [],
            sub: protoType.enumConstructor(),
            name: "Types",
            pack: ["com", "dongxiguo", "protobuf"],
          });
        }
      }
    }

    var fields:Array<Field> = [];
    var messageProto = messages.get(fullName);
    var constructorBlock = [];
    for (field in messageProto.field)
    {
      var haxeFieldName = messageNameConverter.toHaxeFieldName(field.name);
      switch (field)
      {
        case { label: LABEL_REQUIRED, defaultValue: defaultValueString, } :
        {
          fields.push(
          {
            name: haxeFieldName,
            pos: Context.currentPos(),
            access: [APublic],
            kind: FProp("default", readonly ? "null" : "default", toHaxeType(field.type, field.typeName)),
          });
          if (defaultValueString != null && !readonly)
          {
            var defaultValueExpr = makeDefaultValueExpr(fullName, field, enums, enumNameConverter);
            constructorBlock.push(macro this.$haxeFieldName = $defaultValueExpr);
          }
        }
        case { label: LABEL_OPTIONAL, defaultValue: defaultValueString, } :
        {
          if (defaultValueString == null)
          {
            fields.push(
            {
              meta: [ { params: [], pos: Context.currentPos(), name: ":optional", }, ],
              name: haxeFieldName,
              pos: Context.currentPos(),
              access: [ APublic ],
              kind: FProp("default", readonly ? "null" : "default", TPath(
                {
                  pack: [],
                  name: "StdTypes",
                  sub: "Null",
                  params: [TPType(toHaxeType(field.type, field.typeName))],
                })),
            });
          }
          else
          {
            var getterName = "get_" + haxeFieldName;
            var setterName = "set_" + haxeFieldName;
            if (!readonly)
            {
              var defaultFieldName = "__default_" + haxeFieldName;
              var haxeFieldExpr =
              {
                pos: Context.currentPos(),
                expr: EConst(CIdent(haxeFieldName)),
              }
              fields.push(
              {
                name: defaultFieldName,
                pos: Context.currentPos(),
                access: [ AStatic ],
                kind: FProp("null", "never",
                  TPath(
                  {
                    pack: [],
                    name: "StdTypes",
                    sub: "Null",
                    params: [TPType(toHaxeType(field.type, field.typeName))],
                  }),
                  makeDefaultValueExpr(fullName, field, enums, enumNameConverter)),
              });
              var defaultFieldExpr =
              {
                pos: Context.currentPos(),
                expr: EConst(CIdent(defaultFieldName)),
              }

              fields.push(
              {
                name: setterName,
                pos: Context.currentPos(),
                kind: FFun(
                {
                  ret: null,
                  params: [],
                  args: [ { name: "value", opt: false, type: null }, ],
                  expr: macro { return $haxeFieldExpr = value; },
                }),
              });
              fields.push(
              {
                name: getterName,
                pos: Context.currentPos(),
                kind: FFun(
                {
                  ret: null,
                  params: [],
                  args: [],
                  expr: macro
                  if ($haxeFieldExpr != null)
                  {
                    return $haxeFieldExpr;
                  }
                  else
                  {
                    return $defaultFieldExpr;
                  }
                }),
              });
            }
            fields.push(
            {
              name: haxeFieldName,
              pos: Context.currentPos(),
              access: [ APublic ],
              meta: [ { name: ":isVar", params: [], pos: Context.currentPos(), }, ],
              kind: FProp(
                getterName,
                setterName,
                TPath(
                  {
                    pack: [],
                    name: "StdTypes",
                    sub: "Null",
                    params: [TPType(toHaxeType(field.type, field.typeName))],
                  })),
            });
          }
        }
        case { label: LABEL_REPEATED } :
        {
          fields.push(
          {
            name: haxeFieldName,
            pos: Context.currentPos(),
            access: [APublic],
            kind: FProp("default", readonly ? "null" : "default", TPath(
              {
                pack: [],
                name: readonly ? "Iterable" : "Array",
                params: [TPType(toHaxeType(field.type, field.typeName))],
              })),
          });
          if (!readonly)
          {
            constructorBlock.push(macro this.$haxeFieldName = []);
          }
        }
      }
    }
    if (!readonly)
    {
      fields.push(
        {
          name: "new",
          pos: Context.currentPos(),
          access: [APublic],
          kind: FFun(
          {
            ret: null,
            params: [],
            args: [],
            expr:
            {
              expr: EBlock(constructorBlock),
              pos: Context.currentPos(),
            }
          })
        });
    }
    return
    {
      pack: messageNameConverter.getHaxePackage(fullName),
      name: messageNameConverter.getHaxeClassName(fullName),
      pos: Context.currentPos(),
      meta: [],
      params: [],
      isExtern: false,
      kind: readonly ? TDStructure : TDClass(),
      fields: fields,
    };
  }

  public function getReadonlyMessageDefinition(
    fullName:String,
    readonlyNameConverter:NameConverter.MessageNameConverter,
    enumNameConverter:NameConverter.EnumNameConverter):TypeDefinition
  {
    return getMessageDefinition(fullName, readonlyNameConverter, enumNameConverter, true);
  }

  public function getBuilderDefinition(
    fullName:String,
    builderNameConverter:NameConverter.MessageNameConverter,
    enumNameConverter:NameConverter.EnumNameConverter):TypeDefinition
  {
    return getMessageDefinition(fullName, builderNameConverter, enumNameConverter, false);
  }

}

typedef ReadonlyStringMap<Element> =
{
  function iterator():Iterator<Element>;
  function exists(key:String):Bool;
  function get(key:String):Null<Element>;
  function keys():Iterator<String>;
}

/** Determine whether a enum from a proto file should be [@:fakeEnum]. */
private enum FakeEnumBehavior
{

  /** Every enums in proto files must be [@:fakeEnum] */
  ALWAYS;

  /** Every enums in proto files must not be [@:fakeEnum] */
  NEVER;

  /**
    If a enum's allowAlias option is set to true,
    then enum must be [@:fakeEnum].
    Otherwise, the enum must not be [@:fakeEnum].
  **/
  ALLOW_ALIAS_ONLY;

}