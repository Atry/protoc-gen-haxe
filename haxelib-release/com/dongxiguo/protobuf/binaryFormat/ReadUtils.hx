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

import com.dongxiguo.protobuf.Error;
import com.dongxiguo.protobuf.unknownField.UnknownField;
import com.dongxiguo.protobuf.unknownField.UnknownFieldElement;
import com.dongxiguo.protobuf.unknownField.UnknownFieldMap;
import com.dongxiguo.protobuf.WireType;
import haxe.io.Bytes;

using Type;

#if haxe3
import haxe.ds.IntMap;
import haxe.ds.StringMap;
#else
import haxe.Int32;
private typedef IntMap<Value> = IntHash<Value>;
private typedef StringMap<Value> = Hash<Value>;
#end

/**
  @author 杨博
**/
@:final class ReadUtils
{

  public static inline function mergerUnknownField(unknownFields:UnknownFieldMap, tag:Int, value:UnknownFieldElement)
  {
    var originalValue = unknownFields.get(tag);
    if (originalValue == null)
    {
      unknownFields.set(tag, UnknownField.fromOptional(value));
    }
    else if (Std.is(originalValue, Array))
    {
      cast (originalValue, Array<Dynamic>).push(value);
    }
    else
    {
      unknownFields.set(tag, UnknownField.fromRepeated([ originalValue.toOptional(), value ]));
    }
  }

  public static function mergeFrom<Builder:{ var unknownFields:UnknownFieldMap; }>(fieldMap:FieldMap<Builder>, builder:Builder, input:ILimitableInput):Void
  {
    while (input.limit > 0)
    {
      var tag = ReadUtils.readUint32(input);
      var fieldMerger = fieldMap.get(tag);
      if (fieldMerger == null)
      {
        var unknownFields = builder.unknownFields;
        if (unknownFields == null)
        {
          unknownFields = new UnknownFieldMap();
          builder.unknownFields = unknownFields;
        }
        switch (tag | 7)
        {
          case WireType.VARINT:
          {
            mergerUnknownField(unknownFields, tag, readInt64(input));
          }
          case WireType.FIXED_64_BIT:
          {
            var bytes = haxe.io.Bytes.alloc(8);
            input.checkedReadByes(bytes, 0, 8);
            mergerUnknownField(unknownFields, tag, bytes);
          }
          case WireType.LENGTH_DELIMITED:
          {
            mergerUnknownField(unknownFields, tag, readBytes(input));
          }
          case WireType.FIXED_32_BIT:
          {
            var bytes = haxe.io.Bytes.alloc(4);
            input.checkedReadByes(bytes, 0, 4);
            mergerUnknownField(unknownFields, tag, bytes);
          }
          default: throw Error.InvalidWireType;
        }
      }
      else
      {
        fieldMerger(builder, input);
      }
    }
  }

  public static inline function mergeDelimitedFrom<Builder:{ var unknownFields:UnknownFieldMap; }>(fieldMap:FieldMap<Builder>, builder:Builder, input:ILimitableInput):Void
  {
    var length = readUint32(input);
    var bytesAfterMessage = input.limit - length;
    input.limit = length;
    mergeFrom(fieldMap, builder, input);
    input.limit = bytesAfterMessage;
  }

  public static inline function readString(input:ILimitableInput):Types.TYPE_STRING
  {
    var length = ReadUtils.readUint32(input);
    return input.checkedReadString(length);
  }

  public static inline function readBytes(input:ILimitableInput):Types.TYPE_BYTES
  {
    var length = ReadUtils.readUint32(input);
    var bytes = Bytes.alloc(length);
    input.checkedReadByes(bytes, 0, length);
    return bytes;
  }

  public static inline function readBool(input:ILimitableInput):Types.TYPE_BOOL
  {
    return readUint32(input) != 0;
  }

  public static inline function readInt32(input:ILimitableInput):Types.TYPE_INT32
  {
    return cast readUint32(input);
  }

  public static inline function readDouble(input:ILimitableInput):Types.TYPE_DOUBLE
  {
    return input.checkedReadDouble();
  }

  public static inline function readFloat(input:ILimitableInput):Types.TYPE_FLOAT
  {
    return input.checkedReadFloat();
  }

  public static inline function readFixed64(input:ILimitableInput):Types.TYPE_FIXED64
  {
    var low = input.checkedReadInt32();
    var high = input.checkedReadInt32();
    #if haxe3
    return Types.TYPE_FIXED64.make(high, low);
    #else
    return Types.TYPE_FIXED64.make(haxe.Int32.ofInt(high), haxe.Int32.ofInt(low));
    #end
  }

  public static inline function readFixed32(input:ILimitableInput):Types.TYPE_FIXED32
  {
    return input.checkedReadInt32();
  }

  public static inline function readSfixed32(input:ILimitableInput):Types.TYPE_SFIXED32
  {
    return input.checkedReadInt32();
  }

  public static inline function readSfixed64(input:ILimitableInput):Types.TYPE_SFIXED64
  {
    var low = input.checkedReadInt32();
    var high = input.checkedReadInt32();
    #if haxe3
    return Types.TYPE_FIXED64.make(low, high);
    #else
    return Types.TYPE_FIXED64.make(haxe.Int32.ofInt(low), haxe.Int32.ofInt(high));
    #end
  }

  public static inline function readSint32(input:ILimitableInput):Types.TYPE_SINT32
  {
    return ZigZag.decode32(readUint32(input));
  }

  public static inline function readSint64(input:ILimitableInput):Types.TYPE_SINT64
  {
    var beforeTransform = readInt64(input);
    #if haxe3
    var low = Types.TYPE_INT64.getLow(beforeTransform);
    var high = Types.TYPE_INT64.getLow(beforeTransform);
    #else
    var low = Int32.toNativeInt(Types.TYPE_INT64.getLow(beforeTransform));
    var high = Int32.toNativeInt(Types.TYPE_INT64.getLow(beforeTransform));
    #end
    var transformedLow = ZigZag.decode64low(low, high);
    var transformedHigh = ZigZag.decode64high(low, high);
    #if haxe3
    return Types.TYPE_FIXED64.make(transformedLow, transformedHigh);
    #else
    return Types.TYPE_FIXED64.make(Int32.ofInt(transformedLow), Int32.ofInt(transformedHigh));
    #end
  }

  public static function readUint32(input:ILimitableInput):Types.TYPE_UINT32
  {
    var result:Types.TYPE_UINT32 = 0;
    var i = 0;
    while (true)
    {
      var b = input.checkedReadByte();
      if (i < 32)
      {
        if (b >= 0x80)
        {
          result |= ((b & 0x7f) << i);
        }
        else
        {
          result |= (b << i);
          break;
        }
      }
      else
      {
        while (input.checkedReadByte() >= 0x80) {}
        break;
      }
      i += 7;
    }
    return result;
  }

  public static inline function readInt64(input:ILimitableInput):Types.TYPE_INT64
  {
    return readUint64(input);
  }

  public static function readUint64(input:ILimitableInput):Types.TYPE_UINT64
  {
    var shift = 0;
    var result = Types.TYPE_UINT64.ofInt(0);
    while (shift < 64) {
      var b = input.checkedReadByte();
      result = Types.TYPE_UINT64.or(result, Types.TYPE_UINT64.ofInt((b & 0x7F) << shift));
      if ((b & 0x80) == 0) {
        return result;
      }
      shift += 7;
    }
    throw Error.MalformedVarint;
  }
}

typedef FieldMap<Builder> = IntMap<Builder->ILimitableInput->Void>;

typedef EnumValueMap<E:EnumValue> = IntMap<E>;

