package com.dongxiguo.protobuf.binaryFormat;
import com.dongxiguo.protobuf.Types;

interface IBinaryInput
{
  function readUTFBytes(length:TYPE_UINT32):TYPE_STRING;
  function readUnsignedByte():TYPE_UINT32;
  function readDouble():TYPE_DOUBLE;
  function readFloat():TYPE_FLOAT;
  function readInt():TYPE_INT32;
  function readBytes(length:TYPE_UINT32):TYPE_BYTES;

  var numBytesAvailable(get_numBytesAvailable, set_numBytesAvailable):TYPE_UINT32;
}
