package com.dongxiguo.protobuf.binaryFormat;
import haxe.Int64;

/**
  @author 杨博
**/
@:final class WriteUtils
{

  public static function writeUint32(buffer:WritingBuffer, value:Types.TYPE_UINT32):Void
  {
    while (true)
    {
      if (value < 0x80) {
        buffer.writeByte(value);
        return;
      }
      else
      {
        buffer.writeByte((value & 0x7F) | 0x80);
        value >>>= 7;
      }
    }
  }

  static function writeVarint64(buffer:WritingBuffer, low:Int, high:Int):Void
  {
    if (high == 0)
    {
      writeUint32(buffer, low);
    }
    else
    {
      for (i in 0...4) {
        buffer.writeByte((low & 0x7F) | 0x80);
        low >>> = 7;
      }
      if ((high & (0xFFFFFFF << 3)) == 0)
      {
        buffer.writeByte((high << 4) | low);
      }
      else
      {
        buffer.writeByte((((high << 4) | low) & 0x7F) | 0x80);
        writeUint32(buffer, high >>> 3);
      }
    }
  }

  public static function writeDouble(buffer:WritingBuffer, value:Types.TYPE_DOUBLE):Void
  {
    buffer.writeDouble(value);
  }

  public static function writeFloat(buffer:WritingBuffer, value:Types.TYPE_FLOAT):Void
  {
    buffer.writeFloat(value);
  }

  public static function writeInt64(buffer:WritingBuffer, value:Types.TYPE_INT64):Void
  {
    writeVarint64(buffer, Int64.getLow(value), Int64.getHigh(value));
  }

  public static function writeUint64(buffer:WritingBuffer, value:Types.TYPE_UINT64):Void
  {
    writeVarint64(buffer, Int64.getLow(value), Int64.getHigh(value));
  }

  public static function writeInt32(buffer:WritingBuffer, value:Types.TYPE_INT32):Void
  {
    if (value < 0)
    {
      writeVarint64(buffer, value, 0xFFFFFFFF);
    }
    else
    {
      writeUint32(buffer, value);
    }
  }

  public static function writeFixed64(buffer:WritingBuffer, value:Types.TYPE_FIXED64):Void
  {
    buffer.writeInt32(Int64.getLow(value));
    buffer.writeInt32(Int64.getHigh(value));
  }

  public static function writeFixed32(buffer:WritingBuffer, value:Types.TYPE_FIXED32):Void
  {
    buffer.writeInt32(value);
  }

  public static function writeBool(buffer:WritingBuffer, value:Types.TYPE_BOOL):Void
  {
    buffer.writeByte(value ? 1 : 0);
  }

  public static function writeString(buffer:WritingBuffer, value:Types.TYPE_STRING):Void
  {
    var i = buffer.beginBlock();
    buffer.writeString(value);
    buffer.endBlock(i);
  }

  public static function writeBytes(buffer:WritingBuffer, value:Types.TYPE_BYTES):Void
  {
    writeUint32(buffer, value.length);
    buffer.writeFullBytes(value, 0, value.length);
  }

  public static function writeSfixed32(buffer:WritingBuffer, value:Types.TYPE_SFIXED32):Void
  {
    buffer.writeInt32(value);
  }

  public static function writeSfixed64(buffer:WritingBuffer, value:Types.TYPE_SFIXED64):Void
  {
    buffer.writeInt32(Int64.getLow(value));
    buffer.writeInt32(Int64.getHigh(value));
  }

  public static function writeSint32(buffer:WritingBuffer, value:Types.TYPE_SINT32):Void
  {
    writeUint32(buffer, ZigZag.encode32(value));
  }

  public static function writeSint64(buffer:WritingBuffer, value:Types.TYPE_SINT64):Void
  {
    writeVarint64(buffer,
        ZigZag.encode64low(Int64.getLow(value), Int64.getHigh(value)),
        ZigZag.encode64high(Int64.getLow(value), Int64.getHigh(value)));
  }

}
