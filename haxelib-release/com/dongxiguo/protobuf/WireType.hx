package com.dongxiguo.protobuf;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type;

/**
 * @author 杨博
 */
class WireType
{
  @:extern public static inline var VARINT = 0;
  @:extern public static inline var FIXED_64_BIT = 1;
  @:extern public static inline var LENGTH_DELIMITED = 2;
  @:extern public static inline var FIXED_32_BIT = 5;

  @:noUsing
  public static function byType(type:Type):Int
  {
    return switch (type)
    {
      case TYPE_DOUBLE, TYPE_FIXED64, TYPE_SFIXED64:
        FIXED_64_BIT;
      case TYPE_FLOAT, TYPE_FIXED32, TYPE_SFIXED32:
        FIXED_32_BIT;
      case TYPE_INT32, TYPE_INT64, TYPE_UINT32, TYPE_UINT64, TYPE_SINT32, TYPE_SINT64, TYPE_BOOL, TYPE_ENUM:
        VARINT;
      case TYPE_STRING, TYPE_MESSAGE, TYPE_BYTES:
        LENGTH_DELIMITED;
      case TYPE_GROUP:
        throw Error.NotImplemented;
    }
  }

}