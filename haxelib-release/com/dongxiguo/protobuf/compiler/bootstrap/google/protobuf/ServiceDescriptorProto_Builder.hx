package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class ServiceDescriptorProto_Builder {
	@:optional public var unknownFields(default,default):Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>;
	@:optional public var name(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	public var method(default,default):Array<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodDescriptorProto_Builder>;
	@:optional public var options(default,default):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.ServiceOptions_Builder>;
	public function new() {
		this.method=[];
	}
	public inline function sortUnknownFields() {
		return com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.ServiceDescriptorProto_ExtensionSet.sortUnknownFields(this.unknownFields);
	}
}