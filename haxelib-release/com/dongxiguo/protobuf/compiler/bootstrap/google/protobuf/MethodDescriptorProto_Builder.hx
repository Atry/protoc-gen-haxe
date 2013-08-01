package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class MethodDescriptorProto_Builder {
	@:optional public var unknownFields(default,default):Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>;
	@:optional public var name(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var inputType(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var outputType(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var options(default,default):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodOptions_Builder>;
	public function new() {
	}
	public inline function sortUnknownFields() {
		return com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodDescriptorProto_ExtensionSet.sortUnknownFields(this.unknownFields);
	}
}