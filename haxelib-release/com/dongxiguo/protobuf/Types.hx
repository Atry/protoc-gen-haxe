package com.dongxiguo.protobuf;

typedef TYPE_DOUBLE = StdTypes.Float;
typedef TYPE_FLOAT = StdTypes.Float;
typedef TYPE_INT64 = haxe.Int64;
typedef TYPE_UINT64 = haxe.Int64;
typedef TYPE_INT32 = StdTypes.Int;
typedef TYPE_FIXED64 = haxe.Int64;
typedef TYPE_BOOL = StdTypes.Bool;
typedef TYPE_STRING = String.String;
//TYPE_GROUP;
//TYPE_ENUM;
//TYPE_MESSAGE;
typedef TYPE_BYTES = haxe.io.Bytes;
#if (flash9 || flash9doc || cs)
  typedef TYPE_UINT32 = StdTypes.UInt;
  typedef TYPE_FIXED32 = StdTypes.UInt;
#else
  typedef TYPE_UINT32 = StdTypes.Int;
  typedef TYPE_FIXED32 = StdTypes.Int;
#end
typedef TYPE_SFIXED32 = StdTypes.Int;
typedef TYPE_SFIXED64 = haxe.Int64;
typedef TYPE_SINT32 = StdTypes.Int;
typedef TYPE_SINT64 = haxe.Int64;