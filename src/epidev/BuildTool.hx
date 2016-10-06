package epidev;

import epidev.cli.PrintHelper.*;

@:enum abstract STRCONST(String) to String{
	var DEFAULT_FILE = ".hxproj";
}
@:enum private abstract COMMAND(String) from String{
	var INIT = "init";
	var BUILD = "make";
	var CMD = "cmd";
	var LIBRARY = "lib";
}

@:build(epidev.macro.BuildNum.build())
@:final class BuildTool{
	
	public static function main(){
		if(Sys.args().length == 0) 
			fatal("No arguments?");

		checkInit();

		var ps:Properties = locateProps();

		var cmds:Map<COMMAND, Properties->Void> = [
			BUILD => build,
			CMD => buildCmd,
			LIBRARY => library
		];
		if(!cmds.exists(Sys.args()[0]))
			fatal("Command doesn't exist");

		cmds.get(Sys.args()[0])(ps);
	}

	private static function checkInit():Void{
		var cmds:Map<COMMAND, Void->Void> = [
			INIT => init,
		];
		var arg:String = Sys.args()[0];
		if(!cmds.exists(arg)) return;
		cmds.get(arg)();
		Sys.exit(0);
	}

	private static function locateProps():Properties{
		var cwd:String = Sys.getCwd();
		var ps:Null<Properties> = null;
		var dirs:Array<String> = [];
		while(true){
			ps = getProperties(cwd);
			if(ps != null) break;
			dirs.push(cwd);
			var li = cwd.lastIndexOf("/");
			if(li == -1){
				printNor_("Looking in the following directories...");
				for(d in dirs) printNor_('\t$d');
				fatal('Failed to find a $DEFAULT_FILE file.');
			}
			cwd = cwd.substr(0, li);
		}
		return ps;
	}

	private static function getProperties(cwd:String):Null<Properties>{
		var path:String = '$cwd/$DEFAULT_FILE';
		if(!sys.FileSystem.exists(path)) return null;
		return new Properties(cwd, DEFAULT_FILE);
	}

	private static function init():Void{
	}

	private static function build(props:Properties)			(new Builder(props)).build();
	private static function buildCmd(props:Properties)	(new Builder(props)).echoBuildCmd();
	private static function library(props:Properties)   (new LibraryManager(props)).handle(Sys.args().slice(1));

}
