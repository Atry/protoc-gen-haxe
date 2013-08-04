package com.dongxiguo.protobuf.unknownField;

/**
  @author 杨博
**/
typedef ReadonlyUnknownFieldMap =
{

  function iterator():Iterator<UnknownField>;

  function exists(key:Int):Bool;

  function get(key:Int):Null<UnknownField>;

  function keys():Iterator<Int>;

}
