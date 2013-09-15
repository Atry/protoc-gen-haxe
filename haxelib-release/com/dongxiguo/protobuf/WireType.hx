// Copyright (c) 2013, 杨博 (Yang Bo)
// All rights reserved.
//
// Author: 杨博 (Yang Bo) <pop.atry@gmail.com>
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// * Neither the name of the <ORGANIZATION> nor the names of its contributors
//   may be used to endorse or promote products derived from this software
//   without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

package com.dongxiguo.protobuf;
import com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.FieldDescriptorProto;
private typedef ProtobufType = com.dongxiguo.protobuf.compiler.bootstrap.google.protobuf.fieldDescriptorProto.Type;

/**
 * @author 杨博
 */
class WireType
{
  @:extern public static inline var VARINT = 0;
  @:extern public static inline var FIXED_64_BIT = 1;
  @:extern public static inline var LENGTH_DELIMITED = 2;
  @:extern public static inline var FIXED_32_BIT = 5;

  @:noUsing
  public static function byType(type:ProtobufType):Int
  {
    return switch (type)
    {
      case ProtobufType.TYPE_DOUBLE, ProtobufType.TYPE_FIXED64, ProtobufType.TYPE_SFIXED64:
        FIXED_64_BIT;
      case ProtobufType.TYPE_FLOAT, ProtobufType.TYPE_FIXED32, ProtobufType.TYPE_SFIXED32:
        FIXED_32_BIT;
      case ProtobufType.TYPE_INT32, ProtobufType.TYPE_INT64, ProtobufType.TYPE_UINT32, ProtobufType.TYPE_UINT64, ProtobufType.TYPE_SINT32, ProtobufType.TYPE_SINT64, ProtobufType.TYPE_BOOL, ProtobufType.TYPE_ENUM:
        VARINT;
      case ProtobufType.TYPE_STRING, ProtobufType.TYPE_MESSAGE, ProtobufType.TYPE_BYTES:
        LENGTH_DELIMITED;
      case ProtobufType.TYPE_GROUP:
        throw Error.NotImplemented;
      default:
        throw Error.NotImplemented;
    }
  }

}