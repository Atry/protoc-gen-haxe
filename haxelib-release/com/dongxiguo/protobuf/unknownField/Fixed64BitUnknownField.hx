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
