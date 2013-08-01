package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.descriptorProto;
class ExtensionRange_Builder {
	@:optional public var unknownFields(default,default):Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>;
	@:optional public var start(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_INT32>;
	@:optional public var end(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_INT32>;
	public function new() {
	}
	public inline function sortUnknownFields() {
		return com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.descriptorProto.ExtensionRange_ExtensionSet.sortUnknownFields(this.unknownFields);
	}
}