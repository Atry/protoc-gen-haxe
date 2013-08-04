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

/**
 * @author 杨博
 */
@:final class NameConverter
{
  public static function lowerCaseUnderlineToUpperCamelCase(lowerCaseUnderlineName:String):String
  {
    var buffer = new StringBuf();
    for (word in lowerCaseUnderlineName.split("_"))
    {
      if (word != "")
      {
        buffer.add(word.charAt(0).toUpperCase());
        buffer.addSub(word, 1);
      }
    }
    return buffer.toString();
  }

  public static function lowerCaseUnderlineToLowerCamelCase(lowerCaseUnderlineName:String):String
  {
    if (lowerCaseUnderlineName == "")
    {
      return "";
    }
    var words = lowerCaseUnderlineName.split("_");
    var buffer = new StringBuf();
    buffer.add(words[0]);
    for (i in 1...words.length)
    {
      var word = words[i];
      if (word != "")
      {
        buffer.add(word.charAt(0).toUpperCase());
        buffer.addSub(word, 1);
      }
    }
    return buffer.toString();
  }

  public static function asLowerCamelCasePackage(fullyQualifiedName:String):Array<String>
  {
    var nameParts = fullyQualifiedName.split(".");
    return
    [
      for (namePart in nameParts) if (namePart != "")
      {
        namePart.charAt(0).toLowerCase() + lowerCaseUnderlineToLowerCamelCase(namePart.substring(1));
      }
    ];
  }

  public static function getLowerCamelCasePackage(fullyQualifiedName:String):Array<String>
  {
    var nameParts = fullyQualifiedName.split(".");
    return
    [
      for (i in 1...nameParts.length - 1)
      {
        var namePart = nameParts[i];
        namePart.charAt(0).toLowerCase() + lowerCaseUnderlineToLowerCamelCase(namePart.substring(1));
      }
    ];
  }

  public static function getClassName(fullyQualifiedName:String):String
  {
    var lastDot = fullyQualifiedName.lastIndexOf(".");
    return
      fullyQualifiedName.charAt(lastDot + 1).toUpperCase() +
      fullyQualifiedName.substring(lastDot + 2);
  }

  public static function identity(name:String):String
  {
    return name;
  }

  public static var KEYWORD_EREG(default, never) = ~/^(break|callback|case|cast|catch|class|continue|default|do|dynamic|else|enum|extends|extern|false|for|function|here|if|implements|import|in|inline|interface|never|new|null|override|package|private|public|return|static|super|switch|this|throw|trace|true|try|typedef|untyped|using|var|while)$/;

  public static function replaceKeyword(keyword:String):String
  {
    return KEYWORD_EREG.replace(keyword, "$1_");
  }

  public static function replaceKeywords(keywords:Array<String>):Array<String>
  {
    return [ for (keyword in keywords) KEYWORD_EREG.replace(keyword, "$1_") ];
  }

}

typedef MessageNameConverter =
{
  function toHaxeFieldName(protoFieldName:String):String;
  function getHaxeClassName(protoMessageFullyQualifiedName:String):String;
  function getHaxePackage(protoMessageFullyQualifiedName:String):Array<String>;
}

typedef EnumNameConverter =
{
  function toHaxeEnumConstructorName(protoEnumValueName:String):String;
  function getHaxeEnumName(protoEnumFullyQualifiedName:String):String;
  function getHaxePackage(protoEnumFullyQualifiedName:String):Array<String>;
}

typedef UtilityNameConverter =
{
  function getHaxeClassName(protoFullyQualifiedName:String):String;
  function getHaxePackage(protoFullyQualifiedName:String):Array<String>;
}

typedef PackageExtensionNameConverter =
{
  function toHaxeFieldName(protoFieldName:String):String;
  function getHaxeClassName(protoPackageName:String):String;
  function getHaxePackage(protoPackageName:String):Array<String>;
}