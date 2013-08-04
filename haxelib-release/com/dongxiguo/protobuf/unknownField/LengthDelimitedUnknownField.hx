package com.dongxiguo.protobuf.unknownField;

import com.dongxiguo.protobuf.binaryFormat.ZigZag;
import haxe.io.Bytes;

/**
  @author 杨博
**/
abstract LengthDelimitedUnknownField(Bytes) from Bytes to Bytes
{

  public static inline function fromString(value:Types.TYPE_STRING):LengthDelimitedUnknownField
  {
    return Bytes.ofString(value);
  }

  public static inline function fromBytes(value:Types.TYPE_BYTES):LengthDelimitedUnknownField
  {
    return value;
  }

  public inline function toString():Types.TYPE_STRING
  {
    return this.toString();
  }

  public inline function toBytes():Types.TYPE_BYTES
  {
    return this;
  }

}
