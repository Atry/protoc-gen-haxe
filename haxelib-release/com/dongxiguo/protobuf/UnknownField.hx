package com.dongxiguo.protobuf;

/**
  @author 杨博
**/
class UnknownField<RawValue>
{

  public var tag(default, null):Int;

  public var value(default, null):RawValue;

  public function new(tag:Int, value:RawValue)
  {
    this.tag = tag;
    this.value = value;
  }

  function get_wireType():Int
  {
    return this.tag | 7;
  }

  function get_number():Int
  {
    return this.tag >>> 3;
  }

  public var wireType(get, never):Int;

  public var number(get, never):Int;

  public static function compare(left:UnknownField<Dynamic>, right:UnknownField<Dynamic>):Int
  {
    var leftTag = left.tag;
    var rightTag = right.tag;
    return leftTag < rightTag ? -1 : leftTag > rightTag ? 1 : 0;
  }
}