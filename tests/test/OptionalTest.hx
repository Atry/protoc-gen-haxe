package ;

import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import massive.munit.Assert;

import com.dongxiguo.protobuf.binaryFormat.LimitableBytesInput;
import samplePackage.Optional_Builder;
using samplePackage.Optional_Merger;
using samplePackage.Optional_Writer;

class OptionalTest 
{
	@Test
	public function testOptionalString():Void {
		
		var b = new Optional_Builder();
		b.tString = 'hello';
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		Assert.areEqual(rb.tString, 'hello');
	}
	
	@Test
	public function testOptionalEmpty():Void {
		
		var b = new Optional_Builder();
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		Assert.isNull(rb.tString);
		Assert.isNull(rb.tInt);
		Assert.isNull(rb.tBool);
		Assert.isNull(rb.tFloat);
	}
	
	@Test
	public function testOptionalInt():Void {
		
		var b = new Optional_Builder();
		b.tInt = 3;
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		Assert.areEqual(rb.tInt, 3);
	}
	
	
	@Test
	public function testOptionalInt0():Void {
		
		var b = new Optional_Builder();
		b.tInt = 0;
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		Assert.areEqual(rb.tInt, 0);
	}
	
	@Test
	public function testOptionalFloat():Void {
		
		
		var b = new Optional_Builder();
		b.tFloat = 3.654;
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		Assert.areEqual(Math.floor(rb.tFloat*100), 365);
	}
	
	@Test
	public function testOptionalFloat0():Void {
		
		var b = new Optional_Builder();
		b.tFloat = 0;
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		Assert.areEqual(rb.tFloat, 0);
	}
	
	@Test
	public function testOptionalBool():Void {
		
		var b = new Optional_Builder();
		b.tBool = true;
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		Assert.isTrue(rb.tBool);
	}
	
	@Test
	public function testOptionalFalse():Void {
		
		var b = new Optional_Builder();
		b.tBool = false;
		var out = new BytesOutput();
		b.writeTo(out);
		
		var inp = new BytesInput(out.getBytes());
		var rb = new Optional_Builder();
		rb.mergeFrom(new LimitableBytesInput(inp.readAll()));
		
		Assert.isFalse(rb.tBool);
	}
}