package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
typedef UninterpretedOption = {
	@:optional public var unknownFields(default,null):com.dongxiguo.protobuf.unknownField.ReadonlyUnknownFieldMap;
	public var name(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.uninterpretedOption.NamePart>;
	@:optional public var identifierValue(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var positiveIntValue(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_UINT64>;
	@:optional public var negativeIntValue(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_INT64>;
	@:optional public var doubleValue(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_DOUBLE>;
	@:optional public var stringValue(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BYTES>;
	@:optional public var aggregateValue(default,null):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
}