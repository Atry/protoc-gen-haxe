package com.dongxiguo.protobuf.binaryFormat;

import com.dongxiguo.protobuf.Error;
import com.dongxiguo.protobuf.unknownField.UnknownField;
import com.dongxiguo.protobuf.unknownField.UnknownFieldMap;
import com.dongxiguo.protobuf.compiler.NameConverter;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumDescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet;
import com.dongxiguo.protobuf.WireType;
import haxe.io.Bytes;
import haxe.io.BytesData;

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

  public static function mergerUnknownField(unknownFields:UnknownFieldMap, tag:Int, value:UnknownField)
  {
    var originalValue = unknownFields.get(tag);
    if (originalValue == null)
    {
      unknownFields.set(tag, value);
    }
    else if (Std.is(originalValue, Array))
    {
      cast (originalValue, Array<Dynamic>).push(value);
    }
    else
    {
      unknownFields.set(tag, [ originalValue, value ]);
    }
  }

  public static function mergeFrom<Builder:{ var unknownFields:UnknownFieldMap; }>(fieldMap:FieldMap<Builder>, builder:Builder, input:IBinaryInput):Void
  {
    while (input.numBytesAvailable > 0)
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
            input.readBytes(bytes.getData(), 0, 8);
            mergerUnknownField(unknownFields, tag, bytes);
          }
          case WireType.LENGTH_DELIMITED:
          {
            mergerUnknownField(unknownFields, tag, readBytes(input));
          }
          case WireType.FIXED_32_BIT:
          {
            var bytes = haxe.io.Bytes.alloc(4);
            input.readBytes(bytes.getData(), 0, 4);
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

  public static function mergeDelimitedFrom<Builder:{ var unknownFields:UnknownFieldMap; }>(fieldMap:FieldMap<Builder>, builder:Builder, input:IBinaryInput):Void
  {
    var length = readUint32(input);
    var bytesAfterMessage = input.numBytesAvailable - length;
    input.numBytesAvailable = length;
    mergeFrom(fieldMap, builder, input);
    input.numBytesAvailable = bytesAfterMessage;
  }

  public static function readString(input:IBinaryInput):Types.TYPE_STRING
  {
    var length = ReadUtils.readUint32(input);
    return input.readUTFBytes(length);
  }

  public static function readBytes(input:IBinaryInput):Types.TYPE_BYTES
  {
    var length = ReadUtils.readUint32(input);
    var bytes = Bytes.alloc(length);
    input.readBytes(bytes.getData(), 0, length);
    return bytes;
  }

  public static function readBool(input:IBinaryInput):Types.TYPE_BOOL
  {
    return readUint32(input) != 0;
  }

  public static function readInt32(input:IBinaryInput):Types.TYPE_INT32
  {
    return cast readUint32(input);
  }

  public static function readDouble(input:IBinaryInput):Types.TYPE_DOUBLE
  {
    return input.readDouble();
  }

  public static function readFloat(input:IBinaryInput):Types.TYPE_FLOAT
  {
    return input.readFloat();
  }

  public static function readFixed64(input:IBinaryInput):Types.TYPE_FIXED64
  {
    var low = input.readInt();
    var high = input.readInt();
    #if haxe3
    return Types.TYPE_FIXED64.make(high, low);
    #else
    return Types.TYPE_FIXED64.make(haxe.Int32.ofInt(high), haxe.Int32.ofInt(low));
    #end
  }

  public static function readFixed32(input:IBinaryInput):Types.TYPE_FIXED32
  {
    return input.readInt();
  }

  public static function readSfixed32(input:IBinaryInput):Types.TYPE_SFIXED32
  {
    return input.readInt();
  }

  public static function readSfixed64(input:IBinaryInput):Types.TYPE_SFIXED64
  {
    var low = input.readInt();
    var high = input.readInt();
    #if haxe3
    return Types.TYPE_FIXED64.make(low, high);
    #else
    return Types.TYPE_FIXED64.make(haxe.Int32.ofInt(low), haxe.Int32.ofInt(high));
    #end
  }

  public static function readSint32(input:IBinaryInput):Types.TYPE_SINT32
  {
    return ZigZag.decode32(readUint32(input));
  }

  public static function readSint64(input:IBinaryInput):Types.TYPE_SINT64
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
//
  //static function readRawVarint32<I:IBinaryInput>(firstByte:Int, input:I):Types.TYPE_UINT32
  //{
    //if ((firstByte & 0x80) == 0) {
      //return firstByte;
    //}
//
    //var result = firstByte & 0x7f;
    //var offset = 7;
    //while (offset < 32) {
      //var b = input.readUnsignedByte();
      //if (b == 255) {
        //throw Error.TruncatedMessage;
      //}
      //result |= (b & 0x7f) << offset;
      //if ((b & 0x80) == 0) {
        //return result;
      //}
      //offset += 7;
    //}
    // Keep reading up to 64 bits.
    //while (offset < 64) {
      //var b = input.readUnsignedByte();
      //if (b == 255) {
        //throw Error.TruncatedMessage;
      //}
      //if ((b & 0x80) == 0) {
        //return result;
      //}
      //offset += 7;
    //}
    //throw Error.MalformedVarint;
  //}

  public static function readUint32(input:IBinaryInput):Types.TYPE_UINT32
  {
    var result:Types.TYPE_UINT32 = 0;
    var i = 0;
    while (true)
    {
      var b = input.readUnsignedByte();
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
        while (input.readUnsignedByte() >= 0x80) {}
        break;
      }
      i += 7;
    }
    return result;
  }

  public static function readInt64(input:IBinaryInput):Types.TYPE_INT64
  {
    return readUint64(input);
  }

  public static function readUint64(input:IBinaryInput):Types.TYPE_UINT64
  {
    var shift = 0;
    var result = Types.TYPE_UINT64.ofInt(0);
    while (shift < 64) {
      var b = input.readUnsignedByte();
      result = Types.TYPE_UINT64.or(result, Types.TYPE_UINT64.ofInt((b & 0x7F) << shift));
      if ((b & 0x80) == 0) {
        return result;
      }
      shift += 7;
    }
    throw Error.MalformedVarint;
  }
}

typedef FieldMap<Builder> = IntMap<Builder->IBinaryInput->Void>;

typedef EnumValueMap<E:EnumValue> = IntMap<E>;

