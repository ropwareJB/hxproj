package epidev;

@:final class TargetDetails{

	public static function targetRequiresDir(ps:Properties):Bool{
		switch(ps.target){
			case JS:   return false;
			case LUA:  return false;
			case SWF:  return false;
			case AS3:  return true;
			case NEKO: return false;
			case PHP:  return true;
			case CPP:  return true;
			case CPPIA:return false;
			case CS:	 return true;
			case JAVA: return true;
			case PYTHON: return false;
		}
	}

	public static function getDefaultOutput(ps:Properties):String{
		switch(ps.target){
			case AS3:  throw "Not yet supported";
			case PHP:  throw "Not yet supported";
			case CPP:  throw "Not yet supported";
			case CS:	 throw "Not yet supported";
			case JAVA: return "Main.jar";
			default: throw "No default binary name";
		}
	}
	
}
