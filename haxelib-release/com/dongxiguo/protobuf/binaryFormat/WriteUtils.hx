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

package com.dongxiguo.protobuf.binaryFormat;
import com.dongxiguo.protobuf.unknownField.ReadonlyUnknownFieldMap;
import com.dongxiguo.protobuf.WireType;
import com.dongxiguo.protobuf.Error;
import haxe.Int64;

/**
  @author 杨博
**/
@:final class WriteUtils
{

  public static function writeUnknownField(
    buffer:WritingBuffer,
    unknownFields:ReadonlyUnknownFieldMap):Void
  {
    if (unknownFields != null)
    {
      for (tag in unknownFields.keys())
      {
        var unknownField = unknownFields.get(tag);
        writeUint32(buffer, tag);
        switch (tag | 7)
        {
          case WireType.VARINT: writeUint64(buffer, cast unknownField);
          case WireType.FIXED_64_BIT: buffer.writeBytes(cast unknownField, 0, 8);
          case WireType.LENGTH_DELIMITED: writeBytes(buffer, cast unknownField);
          case WireType.FIXED_32_BIT: buffer.writeBytes(cast unknownField, 0, 4);
          default: throw Error.InvalidWireType;
        }
      }
    }
  }

  public static function writeUint32(
    buffer:WritingBuffer,
    value:Types.TYPE_UINT32):Void
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
        low >>>= 7;
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

  public static inline function writeDouble(buffer:WritingBuffer, value:Types.TYPE_DOUBLE):Void
  {
    buffer.writeDouble(value);
  }

  public static inline function writeFloat(buffer:WritingBuffer, value:Types.TYPE_FLOAT):Void
  {
    buffer.writeFloat(value);
  }

  public static inline function writeInt64(buffer:WritingBuffer, value:Types.TYPE_INT64):Void
  {
    writeVarint64(buffer, Int64.getLow(value), Int64.getHigh(value));
  }

  public static inline function writeUint64(buffer:WritingBuffer, value:Types.TYPE_UINT64):Void
  {
    writeVarint64(buffer, Int64.getLow(value), Int64.getHigh(value));
  }

  public static inline function writeInt32(buffer:WritingBuffer, value:Types.TYPE_INT32):Void
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

  public static inline function writeFixed64(buffer:WritingBuffer, value:Types.TYPE_FIXED64):Void
  {
    buffer.writeInt32(Int64.getLow(value));
    buffer.writeInt32(Int64.getHigh(value));
  }

  public static inline function writeFixed32(buffer:WritingBuffer, value:Types.TYPE_FIXED32):Void
  {
    buffer.writeInt32(value);
  }

  public static inline function writeBool(buffer:WritingBuffer, value:Types.TYPE_BOOL):Void
  {
    buffer.writeByte(value ? 1 : 0);
  }

  public static inline function writeString(buffer:WritingBuffer, value:Types.TYPE_STRING):Void
  {
    var i = buffer.beginBlock();
    buffer.writeString(value);
    buffer.endBlock(i);
  }

  public static inline function writeBytes(buffer:WritingBuffer, value:Types.TYPE_BYTES):Void
  {
    writeUint32(buffer, value.length);
    buffer.writeFullBytes(value, 0, value.length);
  }

  public static inline function writeSfixed32(buffer:WritingBuffer, value:Types.TYPE_SFIXED32):Void
  {
    buffer.writeInt32(value);
  }

  public static inline function writeSfixed64(buffer:WritingBuffer, value:Types.TYPE_SFIXED64):Void
  {
    buffer.writeInt32(Int64.getLow(value));
    buffer.writeInt32(Int64.getHigh(value));
  }

  public static inline function writeSint32(buffer:WritingBuffer, value:Types.TYPE_SINT32):Void
  {
    writeUint32(buffer, ZigZag.encode32(value));
  }

  public static inline function writeSint64(buffer:WritingBuffer, value:Types.TYPE_SINT64):Void
  {
    writeVarint64(buffer,
        ZigZag.encode64low(Int64.getLow(value), Int64.getHigh(value)),
        ZigZag.encode64high(Int64.getLow(value), Int64.getHigh(value)));
  }

}
