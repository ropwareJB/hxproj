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
			case PHP:  return '${ps.target}/index.php';
			case CPP:  return '${ps.target}/Main';
			case CS:	 throw "Not yet supported";
			case JAVA: return "Main.jar";
			default: throw "No default binary name";
		}
	}

	public static function onCreate(ps:Properties):Void{
		var maps:Map<Target, Properties->Void> = [
			PHP => onCreatePHP,
			NEKO => onCreateNeko,
			PYTHON => onCreatePython
		];
		if(maps.exists(ps.target)) maps.get(ps.target)(ps);
	}

	private static function onCreatePHP(ps:Properties):Void{
		ps.out_bin = '${ps.target}/index.php';
	}

	private static function onCreateNeko(ps:Properties):Void{
		ps.out_bin = '${ps.out_bin}.n';
	}

	private static function onCreatePython(ps:Properties):Void{
		ps.prepend = "#!/bin/python3\n";
	}
	
}
