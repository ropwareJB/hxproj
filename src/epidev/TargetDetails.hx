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
	
}
