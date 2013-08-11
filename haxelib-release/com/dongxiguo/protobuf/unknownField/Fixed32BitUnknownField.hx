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
