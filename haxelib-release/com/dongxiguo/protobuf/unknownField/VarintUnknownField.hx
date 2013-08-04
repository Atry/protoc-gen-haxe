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
abstract VarintUnknownField(Int64) from Int64 to Int64
{
  public static inline function fromBool(value:Types.TYPE_BOOL):VarintUnknownField
  {
    return value ? Int64.make(0, 1) : Int64.make(0, 0);
  }

  public inline function toBool():Types.TYPE_BOOL
  {
    switch ([ Int64.getHigh(this), Int64.getLow(this) ])
    {
      case [ 0, 1 ]: return true;
      case [ 0, 0 ]: return false;
      default: throw Error.MalformedBoolean;
    }
  }

  public static inline function fromInt32(value:Types.TYPE_INT32):VarintUnknownField
  {
    return Int64.make(0, value);
  }

  public inline function toInt32():Types.TYPE_INT32
  {
    return Int64.getLow(this);
  }

  public static inline function fromSint32(value:Types.TYPE_INT32):VarintUnknownField
  {
    return Int64.make(0, ZigZag.encode32(value));
  }

  public inline function toSint32():Types.TYPE_SINT32
  {
    return ZigZag.decode32(Int64.getLow(this));
  }

  public static inline function fromSint64(value:Types.TYPE_SINT64):VarintUnknownField
  {
    #if haxe3
    var low = Types.TYPE_INT64.getLow(value);
    var high = Types.TYPE_INT64.getLow(value);
    #else
    var low = Int32.toNativeInt(Types.TYPE_INT64.getLow(value));
    var high = Int32.toNativeInt(Types.TYPE_INT64.getLow(value));
    #end
    var transformedLow = ZigZag.encode64low(low, high);
    var transformedHigh = ZigZag.encode64high(low, high);
    #if haxe3
    return Types.TYPE_FIXED64.make(transformedLow, transformedHigh);
    #else
    return Types.TYPE_FIXED64.make(Int32.ofInt(transformedLow), Int32.ofInt(transformedHigh));
    #end
  }

  public inline function toSint64():Types.TYPE_SINT64
  {
    var beforeTransform = this;
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

  public static inline function fromUint32(value:Types.TYPE_UINT32):VarintUnknownField
  {
    return Int64.make(0, value);
  }

  public inline function toUint32():Types.TYPE_UINT32
  {
    return Int64.getLow(this);
  }

  public static inline function fromInt64(value:Types.TYPE_INT64):VarintUnknownField
  {
    return value;
  }

  public inline function toInt64():Types.TYPE_INT64
  {
    return this;
  }

  public static inline function fromUint64(value:Types.TYPE_UINT64):VarintUnknownField
  {
    return value;
  }

  public inline function toUint64():Types.TYPE_UINT64
  {
    return this;
  }
}
