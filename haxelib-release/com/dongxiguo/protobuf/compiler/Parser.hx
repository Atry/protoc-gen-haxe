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

package com.dongxiguo.protobuf.compiler;
import haxe.Int64;
import haxe.io.Bytes;
import haxe.io.BytesOutput;

/**
 * @author 杨博
 */
@:final class Parser
{

  macro public static function reformatFloatLiteral(value:Float):haxe.macro.Expr.ExprOf<Float>
  {
    return haxe.macro.Context.makeExpr(value, haxe.macro.Context.currentPos());
  }

  static function parseUInt64(decimalString:String):Int64
  {
    if (decimalString.length <= 9)
    {
      return Int64.ofInt(Std.parseInt(decimalString));
    }
    else if (decimalString.length <= 18)
    {
      return Int64.add(
        Int64.mul(
          Int64.ofInt(1000000000),
          Int64.ofInt(Std.parseInt(decimalString.substring(0, decimalString.length - 9)))),
        Int64.ofInt(Std.parseInt(decimalString.substring(decimalString.length - 9))));
    }
    else
    {
      return Int64.add(
        Int64.mul(
          Int64.ofInt(1000000000),
          Int64.add(
            Int64.mul(
              Int64.ofInt(1000000000),
              Int64.ofInt(Std.parseInt(decimalString.substring(0, decimalString.length - 18)))),
            Int64.ofInt(Std.parseInt(
              decimalString.substring(decimalString.length - 18, decimalString.length - 9))))),
        Int64.ofInt(Std.parseInt(decimalString.substring(decimalString.length - 9))));
    }
  }

  @:extern public static inline function parseInt64(decimalString:String):Int64
  {
    if (StringTools.startsWith(decimalString, "-"))
    {
      return Int64.neg(parseUInt64(decimalString.substring(1)));
    }
    else
    {
      return parseUInt64(decimalString);
    }
  }

  static function parseOctalDigit(b:Int):Int {
    if (b >= 0x30 && b <= 0x37)
    {
      return b - 0x30;
    }
    else
    {
      throw Error.MalformedDefaultValue("Expect digit, got " + String.fromCharCode(b));
    }
  }
  static function parseHexDigit(b:Int):Int
  {
    if (b >= 0x30 && b <= 0x39)
    {
      return b - 0x30;
    }
    else if (b >= 0x61 && b <= 0x66)
    {
      return b - 0x57;
    }
    else if (b >= 0x41 && b <= 0x46)
    {
      return b - 0x37;
    }
    else
    {
      throw Error.MalformedDefaultValue("Expect hex, got " + String.fromCharCode(b));
    }
  }

  public static function parseBytes(escapedString:String):Bytes
  {
    var buffer = new BytesOutput();
    var i = 0;
    while (i < escapedString.length)
    {
      var b = StringTools.fastCodeAt(escapedString, i++);
      switch (b)
      {
        case 0x5c/* \ */:
        {
          var b0 = StringTools.fastCodeAt(escapedString, i++);
          switch (b0)
          {
            case "a".code /* \a */:
            {
              buffer.writeByte(7); continue;
            }
            case "b".code /* \b */:
            {
              buffer.writeByte(8); continue;
            }
            case "f".code /* \f */: buffer.writeByte(12); continue;
            case "n".code /* \n */: buffer.writeByte(10); continue;
            case "r".code /* \r */: buffer.writeByte(13); continue;
            case "t".code /* \t */: buffer.writeByte(9); continue;
            case "v".code /* \v */: buffer.writeByte(11); continue;
            case "x".code /* \xXX */:
            {
              var x0 = StringTools.fastCodeAt(escapedString, i++);
              var x1 = StringTools.fastCodeAt(escapedString, i++);
                buffer.writeByte(
                    parseHexDigit(x0) * 0x10 +
                    parseHexDigit(x1));
              continue;
            }
            default:
            {
              if (b0 >= "0".code && b0 <= "9".code) {
                var b1 = StringTools.fastCodeAt(escapedString, i++);
                var b2 = StringTools.fastCodeAt(escapedString, i++);
                buffer.writeByte(
                    parseOctalDigit(b0) * 64 +
                    parseOctalDigit(b1) * 8 +
                    parseOctalDigit(b2));
              } else {
                buffer.writeByte(b0);
              }
              continue;
            }
          }
        }
        default:
        {
          buffer.writeByte(b);
        }
      }
    }

    return buffer.getBytes();
  }



}