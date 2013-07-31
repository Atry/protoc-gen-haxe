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
    return fullyQualifiedName.substring(fullyQualifiedName.lastIndexOf(".") + 1);
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
  
  public static var DEFAULT_READONLY_MESSAGE_NAME_CONVERTER(default, never):MessageNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return getClassName(protoFullyQualifiedName);
    },
    getHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return replaceKeywords(getLowerCamelCasePackage(fullyQualifiedName));
    },
    toHaxeFieldName: function(fieldName:String):String
    {
      return replaceKeyword(lowerCaseUnderlineToLowerCamelCase(fieldName));
    },
  };

  public static var DEFAULT_BUILDER_NAME_CONVERTER(default, never):MessageNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return getClassName(protoFullyQualifiedName) + "_Builder";
    },
    getHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return replaceKeywords(getLowerCamelCasePackage(fullyQualifiedName));
    },
    toHaxeFieldName: function(fieldName:String):String
    {
      return replaceKeyword(lowerCaseUnderlineToLowerCamelCase(fieldName));
    },
  };

  public static var DEFAULT_ENUM_NAME_CONVERTER(default, never):EnumNameConverter =
  {
    toHaxeEnumConstructorName: replaceKeyword,
    getHaxeEnumName: getClassName,
    getHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return replaceKeywords(getLowerCamelCasePackage(fullyQualifiedName));
    },
  };

  public static var DEFAULT_EXTENSION_NAME_CONVERTER(default, never):ExtensionNameConverter =
  {
    nestedMessageToHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return replaceKeywords(asLowerCamelCasePackage(fullyQualifiedName));
    },
    toHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return replaceKeywords(asLowerCamelCasePackage(fullyQualifiedName));
    },
    toHaxeClassName: lowerCaseUnderlineToUpperCamelCase,
  };
  
  public static var DEFAULT_MERGER_NAME_CONVERTER(default, never):UtilityNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return getClassName(protoFullyQualifiedName) + "_Merger";
    },
    getHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return replaceKeywords(getLowerCamelCasePackage(fullyQualifiedName));
    },
  };
  
  public static var DEFAULT_ENUM_CLASS_NAME_CONVERTER(default, never):UtilityNameConverter =
  {
    getHaxeClassName: function(protoFullyQualifiedName:String):String
    {
      return getClassName(protoFullyQualifiedName) + "_EnumClass";
    },
    getHaxePackage: function(fullyQualifiedName:String):Array<String>
    {
      return replaceKeywords(getLowerCamelCasePackage(fullyQualifiedName));
    },
  };
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

typedef ExtensionNameConverter =
{
  function nestedMessageToHaxePackage(protoMessageFullyQualifiedName:String):Array<String>;
  function toHaxePackage(protoPackageName:String):Array<String>;
  /** 每个Extension都是一个类，本函数返回类名 */
  function toHaxeClassName(protoExtendsionName:String):String;
}