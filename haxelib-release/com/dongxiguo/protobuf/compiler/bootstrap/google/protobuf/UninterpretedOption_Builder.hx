package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class UninterpretedOption_Builder {
	@:optional public var unknownFields(default,default):com.dongxiguo.protobuf.unknownField.UnknownFieldMap;
	public var name(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.uninterpretedOption.NamePart_Builder>;
	@:optional public var identifierValue(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var positiveIntValue(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_UINT64>;
	@:optional public var negativeIntValue(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_INT64>;
	@:optional public var doubleValue(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_DOUBLE>;
	@:optional public var stringValue(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BYTES>;
	@:optional public var aggregateValue(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	public inline function new() {
		this.name=[];
	}
}