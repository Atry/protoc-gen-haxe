package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class FileDescriptorSet_Merger {
	public static var FIELD_MAP(default,never):com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet_Builder>={
		var fieldMap=new com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet_Builder>();
		{
			fieldMap.set(10,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorSet_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.file.push({
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder();
				com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeDelimitedFrom(com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Merger.FIELD_MAP,fieldBuilder,input);
				fieldBuilder;
			}));
		};
		fieldMap;
	};
	public static inline function mergeFrom(builder,input):Void {
		com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeFrom(FIELD_MAP,builder,input);
	}
	public static inline function mergeDelimitedFrom(builder,input):Void {
		com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeDelimitedFrom(FIELD_MAP,builder,input);
	}
}