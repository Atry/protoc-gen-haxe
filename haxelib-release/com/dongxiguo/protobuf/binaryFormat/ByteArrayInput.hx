package com.dongxiguo.protobuf.binaryFormat;
import com.dongxiguo.protobuf.Error;
import flash.utils.ByteArray;
import flash.utils.Endian;
import com.dongxiguo.protobuf.Types;
import haxe.io.BytesData;

/**
  @author 杨博
**/
class ByteArrayInput extends ByteArray implements IBinaryInput
{

  public function new()
  {
    super();
    this.endian = Endian.LITTLE_ENDIAN;
  }

  var numBytesAfterSlice:TYPE_UINT32;

  inline function get_numBytesAvailable():TYPE_UINT32
  {
    return this.bytesAvailable - this.numBytesAfterSlice;
  }

  inline function set_numBytesAvailable(value:TYPE_UINT32):TYPE_UINT32
  {
    return this.numBytesAfterSlice = this.bytesAvailable - value;
  }

  public var numBytesAvailable(get_numBytesAvailable, set_numBytesAvailable):TYPE_UINT32;

  override public function readUTFBytes(length:TYPE_UINT32):TYPE_STRING
  {
    if (numBytesAvailable >= length)
    {
      return super.readUTFBytes(length);
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  override public function readUnsignedByte():TYPE_UINT32
  {
    if (numBytesAvailable > 0)
    {
      return super.readUnsignedByte();
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  override public function readDouble():TYPE_DOUBLE
  {
    if (numBytesAvailable >= 8)
    {
      return super.readDouble();
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  override public function readFloat():TYPE_FLOAT
  {
    if (numBytesAvailable >= 4)
    {
      return super.readFloat();
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  override public function readInt():TYPE_INT32
  {
    if (numBytesAvailable >= 4)
    {
      #if haxe3
      return super.readInt();
      #else
      return haxe.Int32.toNativeInt(super.readInt());
      #end
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  override public function readBytes(bytesData:BytesData, offset:TYPE_UINT32 = 0, length:TYPE_UINT32 = 0):Void
  {
    if (length == 0)
    {
      length = numBytesAvailable;
    }
    if (numBytesAvailable >= length)
    {
      super.readBytes(bytesData, 0, length);
    }
    else
    {
      return throw Error.OutOfBounds;
    }
  }

}