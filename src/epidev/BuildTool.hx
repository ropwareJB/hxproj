package epidev;

import sys.io.Process;
import epidev.cli.PrintHelper.*;

@:enum abstract CONST(String) to String{
	var DEFAULT_FILE = "haxeproj.json";
}
@:enum abstract COMMAND(String) from String{
	var BUILD = "build";
	var CMD = "cmd";
}

@:build(epidev.macro.BuildNum.build())
@:final class BuildTool{
	
	public static function main(){
		if(Sys.args().length == 0) 
			fatal("No arguments?");
		
		var cmds:Map<COMMAND,Void->Void> = [
			BUILD => build,
			CMD => buildCmd
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

	private static function build():Void{
		var ps:Properties = getProperties();
		var b = new Builder(ps);
		var cmd:Array<String> = b.buildCmd();
		printGood(cmd.join(" "));
		// execute cmd
		
		if(TargetDetails.targetRequiresDir(ps))
			FileSystem.rename(TargetDetails.getDefaultOutput(ps), ps.out_bin)
	}

	private static function buildCmd():Void{
		var b = new Builder(getProperties());
		var cmd:Array<String> = b.buildCmd();
		println_(cmd.join(" "));
	}

}
