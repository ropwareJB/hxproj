package epidev;

@:final class Builder{


  -js <file> : compile code to JavaScript file
  -lua <file> : compile code to Lua file
  -swf <file> : compile code to Flash SWF file
  -neko <file> : compile code to Neko Binary
  -cppia <file> : generate Cppia code into target file
  -python <file> : generate Python code as target file

  -as3 <directory> : generate AS3 code into target directory
  -php <directory> : generate PHP code into target directory
  -cpp <directory> : generate C++ code into target directory
  -cs <directory> : generate C# code into target directory
  -java <directory> : generate Java code into target directory


	public function buildOut():Array<String>{
		
	}
	
}
