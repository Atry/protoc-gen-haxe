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