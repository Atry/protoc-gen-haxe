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

package com.dongxiguo.protobuf.unknownField;


/**
  @author 杨博
**/
abstract UnknownField(Dynamic)
{

  @:extern inline function new(underlying:Dynamic)
  {
    this = underlying;
  }

  public static inline function fromOptional(value:Null<UnknownFieldElement>):UnknownField
  {
    return new UnknownField(value);
  }

  public static inline function fromRepeated(value:Array<UnknownFieldElement>):UnknownField
  {
    return new UnknownField(value);
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
