package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class MethodDescriptorProto_Merger {
	public static var FIELD_MAP(default,never):com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodDescriptorProto_Builder>={
		var fieldMap=new com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodDescriptorProto_Builder>();
		{
			fieldMap.set(10,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.name=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(18,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.inputType=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(26,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.outputType=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(34,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.options={
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodOptions_Builder();
				com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeDelimitedFrom(com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.MethodOptions_Merger.FIELD_MAP,fieldBuilder,input);
				fieldBuilder;
			});
		};
		fieldMap;
	}
	@:extern public static inline function mergeFrom(builder,input):Void {
		com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeFrom(FIELD_MAP,builder,input);
	}
	@:extern public static inline function mergeDelimitedFrom(builder,input):Void {
		com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeDelimitedFrom(FIELD_MAP,builder,input);
	}
}