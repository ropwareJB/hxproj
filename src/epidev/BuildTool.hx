package epidev;

import sys.io.Process;
import epidev.cli.PrintHelper.*;

@:enum abstract CONST(String) to String{
	var DEFAULT_FILE = "haxeproj.json";
}
@:enum abstract COMMAND(String) from String{
	var BUILD = "build";
}

@:build(epidev.macro.BuildNum.build())
@:final class BuildTool{
	
	public static function main(){
		if(Sys.args().length == 0) 
			fatal("No arguments?");
		
		var cmds:Map<COMMAND,Void->Void> = [
			BUILD => build
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

	public static function build():Void{
		var b = new Builder(getProperties());
		var cmd:Array<String> = b.buildCmd();
		printGood(cmd.join(" "));
	}

}
