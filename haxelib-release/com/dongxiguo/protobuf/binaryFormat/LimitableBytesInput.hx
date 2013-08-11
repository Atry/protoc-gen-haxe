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

import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import com.dongxiguo.protobuf.Types;

/**
 * @author 杨博
 */
class LimitableBytesInput extends BytesInput implements ILimitableInput
{
  var maxPosition:TYPE_UINT32;

  public function new(bytes:Bytes, ?pos : Int, ?len : Int)
  {
    super(bytes, pos, len);
    #if flash9
    this.limit = this.b.length;
    #else
    this.limit = this.len;
    #end
  }

  public function checkedReadString(length:TYPE_UINT32):String
  {
    if (limit >= length)
    {
      return super.readString(length);
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  public function checkedReadByte():TYPE_UINT32
  {
    if (cast(this.position, TYPE_UINT32) <= maxPosition)
    {
      return super.readByte();
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  public function checkedReadByes(destination:Bytes, offset:Int, length:Int):Int
  {
    if (length <= 0)
    {
      length = limit;
    }
    if (limit >= cast(length, TYPE_UINT32))
    {
      return super.readBytes(destination, 0, length);
    }
    else
    {
      return throw Error.OutOfBounds;
    }
  }

  public function checkedReadDouble():TYPE_DOUBLE
  {
    if (limit >= 8)
    {
      return super.readDouble();
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  public function checkedReadFloat():TYPE_FLOAT
  {
    if (limit >= 4)
    {
      return super.readFloat();
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  public function checkedReadInt32():TYPE_INT32
  {
    if (limit >= 4)
    {
      #if haxe3
      return super.readInt32();
      #else
      return haxe.Int32.toNativeInt(super.checkedReadInt32());
      #end
    }
    else
    {
      throw Error.OutOfBounds;
    }
  }

  public inline function get_limit():TYPE_UINT32
  {
    return maxPosition - this.position;
  }

  public inline function set_limit(value:TYPE_UINT32):TYPE_UINT32
  {
    return maxPosition = this.position + value;
  }

  public var limit(get_limit, set_limit):TYPE_UINT32;

}