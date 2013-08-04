package com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.sourceCodeInfo;
class Location_Merger {
	static var FIELD_MAP(default,never):com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.sourceCodeInfo.Location_Builder>={
		var fieldMap=new com.dongxiguo.protobuf.binaryFormat.ReadUtils.FieldMap<com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.sourceCodeInfo.Location_Builder>();
		{
			fieldMap.set(8,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.sourceCodeInfo.Location_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.path.push(com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input)));
			fieldMap.set(10,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.sourceCodeInfo.Location_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) {
				var limit=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readUint32(input);
				var bytesAfterSlice=input.numBytesAvailable-limit;
				input.numBytesAvailable=limit;
				while(input.numBytesAvailable>0) {
					builder.path.push(com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input));
				};
				input.numBytesAvailable=bytesAfterSlice;
			});
			fieldMap.set(16,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.sourceCodeInfo.Location_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.span.push(com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input)));
			fieldMap.set(18,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.sourceCodeInfo.Location_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) {
				var limit=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readUint32(input);
				var bytesAfterSlice=input.numBytesAvailable-limit;
				input.numBytesAvailable=limit;
				while(input.numBytesAvailable>0) {
					builder.span.push(com.dongxiguo.protobuf.binaryFormat.ReadUtils.readInt32(input));
				};
				input.numBytesAvailable=bytesAfterSlice;
			});
			fieldMap.set(26,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.sourceCodeInfo.Location_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.leadingComments=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
			fieldMap.set(34,function (builder:com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.sourceCodeInfo.Location_Builder,input:com.dongxiguo.protobuf.binaryFormat.IBinaryInput) builder.trailingComments=com.dongxiguo.protobuf.binaryFormat.ReadUtils.readString(input));
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