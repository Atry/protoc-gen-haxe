package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class FieldDescriptorProto_Builder {
	@:optional public var unknownFields(default,default):Array<com.dongxiguo.protobuf.UnknownField<Dynamic>>;
	@:optional public var name(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var number(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_INT32>;
	@:optional public var label(default,default):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label>;
	@:optional public var type(default,default):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type>;
	@:optional public var typeName(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var extendee(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var defaultValue(default,default):StdTypes.Null<com.dongxiguo.protobuf.Types.TYPE_STRING>;
	@:optional public var options(default,default):StdTypes.Null<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldOptions_Builder>;
	public function new() {
	}
	public inline function sortUnknownFields() {
		return com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_ExtensionSet.sortUnknownFields(this.unknownFields);
	}
}