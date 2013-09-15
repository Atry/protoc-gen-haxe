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

typedef TYPE_DOUBLE = StdTypes.Float;
#if cs
typedef TYPE_FLOAT = StdTypes.Single;
#else
typedef TYPE_FLOAT = StdTypes.Float;
#end
typedef TYPE_INT64 = haxe.Int64;
typedef TYPE_UINT64 = haxe.Int64;
typedef TYPE_INT32 = StdTypes.Int;
typedef TYPE_FIXED64 = haxe.Int64;
typedef TYPE_BOOL = StdTypes.Bool;
typedef TYPE_STRING = String.String;
//TYPE_GROUP;
//TYPE_ENUM;
//TYPE_MESSAGE;
typedef TYPE_BYTES = haxe.io.Bytes;
#if (flash9 || flash9doc || cs)
  typedef TYPE_UINT32 = StdTypes.UInt;
  typedef TYPE_FIXED32 = StdTypes.UInt;
#else
  typedef TYPE_UINT32 = StdTypes.Int;
  typedef TYPE_FIXED32 = StdTypes.Int;
#end
typedef TYPE_SFIXED32 = StdTypes.Int;
typedef TYPE_SFIXED64 = haxe.Int64;
typedef TYPE_SINT32 = StdTypes.Int;
typedef TYPE_SINT64 = haxe.Int64;