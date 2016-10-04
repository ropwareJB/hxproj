package epidev;

import epidev.cli.PrintHelper.*;

@:enum abstract CONST(String) to String{
	var DEFAULT_FILE = ".hxproj";
}
@:enum abstract COMMAND(String) from String{
	var BUILD = "make";
	var CMD = "cmd";
	var DEPENDS = "depends";
}

@:build(epidev.macro.BuildNum.build())
@:final class BuildTool{
	
	public static function main(){
		if(Sys.args().length == 0) 
			fatal("No arguments?");
		
		var cmds:Map<COMMAND,Void->Void> = [
			BUILD => build,
			CMD => buildCmd,
			DEPENDS => addLibrary
		];
		if(!cmds.exists(Sys.args()[0]))
			fatal("Command doesn't exist");

		cmds.get(Sys.args()[0])();
	}

	private static function getProperties():Properties{
		var path:String = '${Sys.getCwd()}/$DEFAULT_FILE';
		if(!sys.FileSystem.exists(path))
			fatal('$DEFAULT_FILE doesn\'t exist.');
		return new Properties(path);
	}

	private static function build()			(new Builder(getProperties())).build();
	private static function buildCmd()	(new Builder(getProperties())).echoBuildCmd();
	private static function addLibrary()	{
		var libs = new LibraryManager(getProperties());
		libs.addLibraries(Sys.args().slice(1));
	}

}
