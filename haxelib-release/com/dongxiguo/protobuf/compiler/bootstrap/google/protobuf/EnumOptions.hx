package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
typedef EnumOptions = {
	@:optional public var unknownFields(default,null):com.dongxiguo.protobuf.UnknownField.ReadonlyUnknownFieldMap;
	@:isVar public var allowAlias(get_allowAlias,set_allowAlias):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	public var uninterpretedOption(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.UninterpretedOption>;
}