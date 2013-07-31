package com.dongxiguo.protobuf.binaryFormat;

import com.dongxiguo.protobuf.Types;

/**
 * @author 杨博
 */
@:final class ZigZag {
  public static function encode32(n:Types.TYPE_UINT32):Types.TYPE_UINT32 {
    return (n << 1) ^ (n >> 31);
  }
  public static function decode32(n:Types.TYPE_UINT32):Types.TYPE_UINT32 {
    return (n >>> 1) ^ -(n & 1);
  }
  public static function encode64low(low:Types.TYPE_UINT32, high:Types.TYPE_UINT32):Types.TYPE_UINT32 {
    return (low << 1) ^ (high >> 31);
  }
  public static function encode64high(low:Types.TYPE_UINT32, high:Types.TYPE_UINT32):Types.TYPE_UINT32 {
    return (low >>> 31) ^ (high << 1) ^ (high >> 31);
  }
  public static function decode64low(low:Types.TYPE_UINT32, high:Types.TYPE_UINT32):Types.TYPE_UINT32 {
    return (high << 31) ^ (low >>> 1) ^ -(low & 1);
  }
  public static function decode64high(low:Types.TYPE_UINT32, high:Types.TYPE_UINT32):Types.TYPE_UINT32 {
    return (high >>> 1) ^ -(low & 1);
  }
}