package com.dongxiguo.protobuf.binaryFormat;
import flash.utils.ByteArray;
import flash.utils.Endian;

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

  var numBytesAfterSlice:UInt;

  function get_numBytesAvailable():UInt
  {
    return this.bytesAvailable - this.numBytesAfterSlice;
  }

  function set_numBytesAvailable(value:UInt):UInt
  {
    return this.numBytesAfterSlice = this.bytesAvailable - value;
  }

  public var numBytesAvailable(get_numBytesAvailable, set_numBytesAvailable):UInt;

}