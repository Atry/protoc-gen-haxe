all release.zip: \
haxelib-release/haxelib.json \
haxelib-release/run.n \
$(wildcard haxelib-release/com/dongxiguo/protobuf/compiler/bootstrap/google/protobuf/*.hx haxelib-release/com/dongxiguo/protobuf/compiler/bootstrap/google/protobuf/*/*.hx haxelib-release/com/dongxiguo/protobuf/*/*.hx haxelib-release/com/dongxiguo/protobuf/*.hx)

install: release.zip
	haxelib local release.zip

haxelib-release/run.n: \
$(wildcard haxelib-release/com/dongxiguo/protobuf/compiler/bootstrap/google/protobuf/*.hx haxelib-release/com/dongxiguo/protobuf/compiler/bootstrap/google/protobuf/*/*.hx haxelib-release/com/dongxiguo/protobuf/*/*.hx haxelib-release/com/dongxiguo/protobuf/*.hx)
	haxe run.hxml

release.zip:
	cd haxelib-release && zip --filesync ../$@ $(subst haxelib-release/,,$^)

clean:
	$(RM) haxelib-release/run.n

.PHONY: all clean install
