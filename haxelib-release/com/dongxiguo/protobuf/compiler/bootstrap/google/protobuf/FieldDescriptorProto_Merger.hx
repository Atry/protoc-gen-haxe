package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class FieldDescriptorProto_Merger {
	static var FIELD_MAP(default,never):com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder>={
		var fieldMap=new com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder>();
		{
			fieldMap.set(10,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.name=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(24,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.number=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input));
			fieldMap.set(32,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.label=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Label(com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input)));
			fieldMap.set(40,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.type=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type(com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input)));
			fieldMap.set(50,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.typeName=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(18,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.extendee=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(58,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.defaultValue=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(66,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.ILimitableInput) builder.options={
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldOptions_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldOptions_Merger.mergeDelimitedFrom(fieldBuilder,input);
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