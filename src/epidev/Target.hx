package epidev;


@:enum abstract Target(String) to String{
  var JS = "js";// <file> : compile code to JavaScript file
  var LUA = "lua";// <file> : compile code to Lua file
  var SWF = "swf";// <file> : compile code to Flash SWF file
  var AS3 = "as3";// <directory> : generate AS3 code into target directory
  var NEKO = "neko";// <file> : compile code to Neko Binary
  var PHP = "php";// <directory> : generate PHP code into target directory
  var CPP = "cpp";// <directory> : generate C++ code into target directory
  var CPPIA = "cppia";// <file> : generate Cppia code into target file
  var CS = "cs";// <directory> : generate C# code into target directory
  var JAVA = "java";// <directory> : generate Java code into target directory
  var PYTHON = "python";// <file> : generate Python code as target file
}
