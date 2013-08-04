package com.dongxiguo.protobuf.unknownField;

/**
  @author 杨博
**/
abstract UnknownFieldElement(Dynamic)
from VarintUnknownField
from Fixed32BitUnknownField
from Fixed64BitUnknownField
from LengthDelimitedUnknownField
{

  public inline function toVarint():VarintUnknownField
  {
    return this;
  }

  public inline function toFixed32Bit():Fixed32BitUnknownField
  {
    return this;
  }

  public inline function toLengthDelimited():LengthDelimitedUnknownField
  {
    return this;
  }

  public inline function toFixed64Bit():Fixed64BitUnknownField
  {
    return this;
  }

}

