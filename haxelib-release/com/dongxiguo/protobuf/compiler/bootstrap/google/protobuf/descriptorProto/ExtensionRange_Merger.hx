package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.descriptorProto;
class ExtensionRange_Merger {
	public static var FIELD_MAP(default,never):com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.descriptorProto.ExtensionRange_Builder>={
		var fieldMap=new com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.descriptorProto.ExtensionRange_Builder>();
		{
			fieldMap.set(8,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.descriptorProto.ExtensionRange_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.start=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input));
			fieldMap.set(16,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.descriptorProto.ExtensionRange_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.end=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input));
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