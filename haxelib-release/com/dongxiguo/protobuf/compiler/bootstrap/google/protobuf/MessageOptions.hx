package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
typedef MessageOptions = {
	@:optional public var unknownFields(default,null):com.dongxiguo.protobuf.UnknownField.ReadonlyUnknownFieldMap;
	@:isVar public var messageSetWireFormat(get_messageSetWireFormat,set_messageSetWireFormat):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	@:isVar public var noStandardDescriptorAccessor(get_noStandardDescriptorAccessor,set_noStandardDescriptorAccessor):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_BOOL>;
	public var uninterpretedOption(default,null):Iterable<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.UninterpretedOption>;
}