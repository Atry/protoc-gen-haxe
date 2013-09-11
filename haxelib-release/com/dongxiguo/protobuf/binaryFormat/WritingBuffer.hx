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
import haxe.io.BytesOutput;
import haxe.io.Output;

/** Internal buffer for serialization. Don't use it in user code. */
class WritingBuffer extends BytesOutput
{
  #if (haxe_ver < 3.1)
  public var length(get_length, never):Int;

	function get_length() : Int
	{
		#if flash9
		return b.length;
		#elseif neko
		var b: { private var b(default, never):StringBuf; } = this.b;
		return untyped __dollar__ssize(StringBuf.__to_string(b.b));
		#elseif php
		var b: { private var b(default, never):String; } = this.b;
		return b.b.length;
		#elseif cs
		var b: { private var b(default, never):cs.system.io.MemoryStream; } = this.b;
		return haxe.Int64.toInt(b.b.Length);
		#elseif java
		var b: { private var b(default, never):java.io.ByteArrayOutputStream; } = this.b;
		return b.b.size();
		#elseif cpp
		var b: { private var b(default, never):haxe.io.BytesData; } = this.b;
		return b.b.length;
		#else
		var b: { private var b(default, never):Array<Int>; } = this.b;
		return b.b.length;
		#end
	}
  #end

  #if (flash10)
    var slices:flash.Vector<Int>;
  #else
    var slices:Array<Int>;
  #end

  public function new()
  {
    super();
    #if (flash10)
      this.slices = new flash.Vector<Int>();
    #else
      this.slices = [];
    #end
  }

  public function beginBlock():Int
  {
    this.slices.push(this.length);
    var beginSliceIndex = this.slices.length;
    this.slices.push(-1);
    this.slices.push(-1);
    this.slices.push(this.length);
    return beginSliceIndex;
  }

  public function endBlock(beginSliceIndex:Int):Void
  {
    this.slices.push(this.length);
    var beginPosition = this.slices[beginSliceIndex + 2];
    this.slices[beginSliceIndex] = this.length;
    WriteUtils.writeUint32(this, this.length - beginPosition);
    this.slices[beginSliceIndex + 1] = this.length;
    this.slices.push(this.length);
  }

  public function toNormal(output:Output):Void
  {
    #if flash9
    var bytes = haxe.io.Bytes.ofData(this.b);
    #else
    var bytes = this.getBytes();
    #end
    var i:Int = 0;
    var begin:Int = 0;
    while (i < this.slices.length)
    {
      var end = this.slices[i];
      ++i;
      if (end > begin)
      {
        output.writeBytes(bytes, begin, end - begin);
      }
      else if (end < begin)
      {
        throw "Bad WritingBuffer!";
      }
      begin = this.slices[i];
      ++i;
    }
    output.writeBytes(bytes, begin, bytes.length - begin);
  }
}