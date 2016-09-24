package epidev;

@:enum abstract Target(String) from String to String{
  var JS = "js";
  var LUA = "lua";
  var SWF = "swf";
  var AS3 = "as3";
  var NEKO = "neko";
  var PHP = "php";
  var CPP = "cpp";
  var CPPIA = "cppia";
  var CS = "cs";
  var JAVA = "java";
  var PYTHON = "python";
}
