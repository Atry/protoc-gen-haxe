package com.dongxiguo.protobuf.binaryFormat;
import haxe.io.BytesOutput;
import haxe.io.Output;

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
		var b: { private var b(default, never):system.io.MemoryStream; } = this.b;
		return b.b.Length;
		#elseif java
		var b: { private var b(default, never):java.io.ByteArrayOutputStream; } = this.b;
		return b.b.size();
		#else
		var b: { private var b(default, never):Array<Int>; } = this.b;
		return b.b.length;
		#end
	}
  #end

  #if (!flash10)
    var slices:Array<Int>;
  #else
    var slices:flash.Vector<Int>;
  #end

  public function new()
  {
    super();
    this.bigEndian = false;
    #if (!flash10)
      this.slices = [];
    #else
      this.slices = new flash.Vector<Int>();
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
    #if flash
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