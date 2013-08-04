package com.dongxiguo.protobuf.unknownField;


/**
  @author 杨博
**/
abstract UnknownField(Dynamic) from Array<UnknownFieldElement> from Null<UnknownFieldElement>
{

  public static inline function fromOptional(value:Null<UnknownFieldElement>):UnknownField
  {
    return value;
  }

  public static inline function fromRepeated(value:Array<UnknownFieldElement>):UnknownField
  {
    return value;
  }

  public function toRepeated():Array<UnknownFieldElement>
  {
    if (this == null)
    {
      return [];
    }
    else if (Std.is(this, Array))
    {
      return this;
    }
    else
    {
      return [ this ];
    }
  }

  public function toOptional():Null<UnknownFieldElement>
  {
    if (this == null)
    {
      return null;
    }
    else if (Std.is(this, Array))
    {
      switch (cast(this, Array<Dynamic>))
      {
        case []: return null;
        case [ singleElement ]: return singleElement;
        default: throw Error.DuplicatedValueForNonRepeatedField;
      }
    }
    else
    {
      return this;
    }
  }

}
