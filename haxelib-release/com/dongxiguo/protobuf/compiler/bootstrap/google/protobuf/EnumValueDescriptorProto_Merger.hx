package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class EnumValueDescriptorProto_Merger {
	public static var FIELD_MAP(default,never):com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumValueDescriptorProto_Builder>={
		var fieldMap=new com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumValueDescriptorProto_Builder>();
		{
			fieldMap.set(10,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumValueDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.name=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(16,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumValueDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.number=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input));
			fieldMap.set(26,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumValueDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.options={
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumValueOptions_Builder();
				com.dongxiguo.protobuf.binaryFormat.ReadUtils.mergeDelimitedFrom(com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumValueOptions_Merger.FIELD_MAP,fieldBuilder,input);
				fieldBuilder;
			});
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