package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
typedef FieldOptions = {
	@:optional public var unknownFields(default,null):com.dongxiguo.protobuf.UnknownField.ReadonlyUnknownFieldMap;
	@:isVar public var ctype(get_ctype,set_ctype):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldOptions.CType>;
	@:optional public var packed(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	@:isVar public var lazy(get_lazy,set_lazy):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	@:isVar public var deprecated(get_deprecated,set_deprecated):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	@:optional public var experimentalMapKey(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:isVar public var weak(get_weak,set_weak):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	public var uninterpretedOption(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.UninterpretedOption>;
}