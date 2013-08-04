package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf;
class FileDescriptorProto_Merger {
	static var FIELD_MAP(default,never):com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder>={
		var fieldMap=new com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder>();
		{
			fieldMap.set(10,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.name=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(18,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.package_=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(26,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.dependency.push(com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input)));
			fieldMap.set(80,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.publicDependency.push(com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input)));
			fieldMap.set(82,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) {
				var limit=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readUint32(input);
				var bytesAfterSlice=input.numBytesAvailable-limit;
				input.numBytesAvailable=limit;
				while(input.numBytesAvailable>0) {
					builder.publicDependency.push(com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input));
				};
				input.numBytesAvailable=bytesAfterSlice;
			});
			fieldMap.set(88,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.weakDependency.push(com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input)));
			fieldMap.set(90,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) {
				var limit=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readUint32(input);
				var bytesAfterSlice=input.numBytesAvailable-limit;
				input.numBytesAvailable=limit;
				while(input.numBytesAvailable>0) {
					builder.weakDependency.push(com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input));
				};
				input.numBytesAvailable=bytesAfterSlice;
			});
			fieldMap.set(34,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.messageType.push({
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.DescriptorProto_Merger.mergeDelimitedFrom(fieldBuilder,input);
				fieldBuilder;
			}));
			fieldMap.set(42,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.enumType.push({
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumDescriptorProto_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.EnumDescriptorProto_Merger.mergeDelimitedFrom(fieldBuilder,input);
				fieldBuilder;
			}));
			fieldMap.set(50,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.service.push({
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.ServiceDescriptorProto_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.ServiceDescriptorProto_Merger.mergeDelimitedFrom(fieldBuilder,input);
				fieldBuilder;
			}));
			fieldMap.set(58,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.extension.push({
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto_Merger.mergeDelimitedFrom(fieldBuilder,input);
				fieldBuilder;
			}));
			fieldMap.set(66,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.options={
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileOptions_Merger.mergeDelimitedFrom(fieldBuilder,input);
				fieldBuilder;
			});
			fieldMap.set(74,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FileDescriptorProto_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.sourceCodeInfo={
				var fieldBuilder=new com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.SourceCodeInfo_Builder();
				com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.SourceCodeInfo_Merger.mergeDelimitedFrom(fieldBuilder,input);
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