package com.dongxiguo.protobuf;

/**
 * @author 杨博
 */
enum Error
{
  OutOfBounds;
  MalformedDefaultValue(reason:String);
  BadDescriptor;
  NotImplemented;
  MalformedVarint;
  MalformedEnumConstructor;
  TruncatedMessage;
}