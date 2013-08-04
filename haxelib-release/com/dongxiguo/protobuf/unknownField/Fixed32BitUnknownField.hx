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
abstract Fixed32BitUnknownField(Bytes) from Bytes to Bytes
{


  public static inline function fromFloat(value:Types.TYPE_FLOAT):Fixed32BitUnknownField
  {
    var output = new BytesOutput();
    output.writeFloat(value);
    return output.getBytes();
  }

  public static inline function fromFixed32(value:Types.TYPE_FIXED32):Fixed32BitUnknownField
  {
    var output = new BytesOutput();
    output.writeInt32(value);
    return output.getBytes();
  }

  public static inline function fromSfixed32(value:Types.TYPE_SFIXED32):Fixed32BitUnknownField
  {
    var output = new BytesOutput();
    output.writeInt32(value);
    return output.getBytes();
  }

  public inline function toFloat():Types.TYPE_FLOAT
  {
    return new BytesInput(this).readFloat();
  }

  public inline function toFixed32():Types.TYPE_FIXED32
  {
    var input = new BytesInput(this);
    return input.readInt32();
  }

  public inline function toSfixed32():Types.TYPE_SFIXED32
  {
    var input = new BytesInput(this);
    return input.readInt32();
  }

}
