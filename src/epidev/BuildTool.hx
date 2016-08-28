package epidev;

import haxe.Json;
import sys.io.File;
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
		trace(epidev.macro.BuildNum.get());

		if(Sys.args().length == 0) 
			fatal("No arguments?");
		
		var cmds:Map<COMMAND,Void->Void> = [
			BUILD => build
		];
		if(!cmds.exists(Sys.args()[0]))
			fatal("Command doesn't exist");

		cmds.get(Sys.args()[0])();
	}

	public static function build():Void{
		var path:String = '${Sys.getCwd()}/$DEFAULT_FILE';
		if(!sys.FileSystem.exists(path))
			fatal('$DEFAULT_FILE doesn\'t exist.');

		var json:String = File.getContent(path);
		trace(json);
	}

}
