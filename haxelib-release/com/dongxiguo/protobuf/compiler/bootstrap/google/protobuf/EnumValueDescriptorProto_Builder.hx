package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class EnumValueDescriptorProto_Builder {
	@:optional public var unknownFields(default,default):Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>;
	@:optional public var name(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var number(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_INT32>;
	@:optional public var options(default,default):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumValueOptions_Builder>;
	public function new() {
	}
	public inline function sortUnknownFields() {
		return com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumValueDescriptorProto_ExtensionSet.sortUnknownFields(this.unknownFields);
	}
}