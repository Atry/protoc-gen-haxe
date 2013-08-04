package com.dongxiguo.protobuf.binaryFormat;

import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import com.dongxiguo.protobuf.Types;

/**
 * @author 杨博
 */
class BinaryBytesInput implements IBinaryInput
{
  var maxPosition:TYPE_UINT32;
  var underlyingInput:BytesInput;

  public function new(underlyingInput:BytesInput, limit:TYPE_UINT32)
  {
    underlyingInput.bigEndian = false;
    this.underlyingInput = underlyingInput;
    this.numBytesAvailable = numBytesAvailable;
  }

  public function readUTFBytes(length:TYPE_UINT32):String
  {
    if (numBytesAvailable >= length)
    {
      return underlyingInput.readString(length);
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  public function readUnsignedByte():TYPE_UINT32
  {
    if (cast(underlyingInput.position, TYPE_UINT32) <= maxPosition)
    {
      return underlyingInput.readByte();
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  public function readBytes(bytesData:BytesData, offset:TYPE_UINT32 = 0, length:TYPE_UINT32 = 0):Void
  {
    if (length == 0)
    {
      length = numBytesAvailable;
    }
    if (numBytesAvailable >= length)
    {
      underlyingInput.readBytes(Bytes.ofData(bytesData), 0, length);
    }
    else
    {
      return throw Error.OutOfBounds;
    }
  }

  public function readDouble():TYPE_DOUBLE
  {
    if (numBytesAvailable >= 8)
    {
      return underlyingInput.readDouble();
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  public function readFloat():TYPE_FLOAT
  {
    if (numBytesAvailable >= 4)
    {
      return underlyingInput.readFloat();
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  public function readInt():TYPE_INT32
  {
    if (numBytesAvailable >= 4)
    {
      #if haxe3
      return underlyingInput.readInt32();
      #else
      return haxe.Int32.toNativeInt(underlyingInput.readInt32());
      #end
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  public inline function get_numBytesAvailable():TYPE_UINT32
  {
    return maxPosition - underlyingInput.position;
  }

  public inline function set_numBytesAvailable(value:TYPE_UINT32):TYPE_UINT32
  {
    return maxPosition = underlyingInput.position + value;
  }

  public var numBytesAvailable(get_numBytesAvailable, set_numBytesAvailable):TYPE_UINT32;

}