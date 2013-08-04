package com.dongxiguo.protobuf.unknownField;

import com.dongxiguo.protobuf.binaryFormat.ZigZag;
import haxe.ds.IntMap;
import haxe.Int64;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;

/**
  @author 杨博
**/
abstract Fixed64BitUnknownField(Bytes) from Bytes to Bytes
{

  public static inline function fromDouble(value:Types.TYPE_DOUBLE):Fixed64BitUnknownField
  {
    var output = new BytesOutput();
    output.writeDouble(value);
    return output.getBytes();
  }

  public static inline function fromFixed64(value:Types.TYPE_FIXED64):Fixed64BitUnknownField
  {
    var output = new BytesOutput();
    output.writeInt32(Types.TYPE_FIXED64.getLow(value));
    output.writeInt32(Types.TYPE_FIXED64.getHigh(value));
    return output.getBytes();
  }

  public static inline function fromSfixed64(value:Types.TYPE_SFIXED64):Fixed64BitUnknownField
  {
    var output = new BytesOutput();
    output.writeInt32(Types.TYPE_SFIXED64.getLow(value));
    output.writeInt32(Types.TYPE_SFIXED64.getHigh(value));
    return output.getBytes();
  }

  public inline function toDouble():Types.TYPE_DOUBLE
  {
    return new BytesInput(this).readDouble();
  }

  public inline function toFixed64():Types.TYPE_FIXED64
  {
    var input = new BytesInput(this);
    var low = input.readInt32();
    var high = input.readInt32();
    return Types.TYPE_FIXED64.make(high, low);
  }

  public inline function toSfixed64():Types.TYPE_SFIXED64
  {
    var input = new BytesInput(this);
    var low = input.readInt32();
    var high = input.readInt32();
    return Types.TYPE_SFIXED64.make(high, low);
  }

}
