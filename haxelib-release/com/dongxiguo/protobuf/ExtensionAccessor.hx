package com.dongxiguo.protobuf;
import haxe.macro.Expr;

/**
 * @author 杨博
 */
@:final
#if haxe3 macro #else @:macro #end
class ExtensionAccessor
{
  public static function getExtendsion(self:Expr, extension:ExprOf<Class<Dynamic>>):Expr
  {
    return macro $extension.get($self);
  }

  public static function setExtendsion(self:Expr, extension:ExprOf<Class<Dynamic>>, value:Expr):ExprOf<Void>
  {
    return macro $extension.set($self, $value);
  }

  public static function clearExtendsion(self:Expr, extension:ExprOf<Class<Dynamic>>):ExprOf<Void>
  {
    return macro $extension.clear($self);
  }

  public static function hasExtendsion(self:Expr, extension:ExprOf<Class<Dynamic>>):ExprOf<Bool>
  {
    return macro $extension.has($self);
  }

}