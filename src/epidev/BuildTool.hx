package epidev;

import haxe.Json;
import sys.io.File;
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

	public static function build():Void{
		var path:String = '${Sys.getCwd()}/$DEFAULT_FILE';
		if(!sys.FileSystem.exists(path))
			fatal('$DEFAULT_FILE doesn\'t exist.');

		var proj:Dynamic = null;
		try proj = Json.parse(File.getContent(path))
		catch(e:Dynamic){
			fatal("Project not valid JSON.");
		}

		var p = new Properties();
		p.unpack(proj);

		trace(p.name);
		


	}

}
