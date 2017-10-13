package epidev;

import sys.FileSystem;
import sys.io.File;
import epidev.cli.PrintHelper.*;
import epidev.cli.CliParams;

@:enum abstract STRCONST(String) to String{
	var DEFAULT_FILE = ".hxproj";
}

@:build(epidev.macro.BuildNum.build())
@:final class BuildTool{

	private static var cli_create = new CliCommand({long:"create"});
	private static var cli_init = new CliCommand({long:"init"});
	private static var cli_make = new CliCommand({long:"make"});
	private static var cli_cmd = new CliCommand({long:"cmd"});
	private static var cli_lib = new CliCommand({long:"lib"});
	
	public static function main(){
		var cli = new CliParams([cli_create, cli_init, cli_make, cli_cmd, cli_lib]);
		cli.process([
			new CliEntryPoint([cli_create]) => create,
			new CliEntryPoint([cli_init]) => init,
			new CliEntryPoint([cli_make]) => build,
			new CliEntryPoint([cli_cmd]) => buildCmd,
			new CliEntryPoint([cli_lib]) => library,
		]);
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
		var ps = new Properties();
		return ps.loadFile(cwd, DEFAULT_FILE);
	}

	private static function create():Void{
		var args = Sys.args();
		if(args.length < 3) fatal("Usage: hb create <name> <target>");
		var name:String = args[1];
		FileSystem.createDirectory(name);
		var ps = Properties.create(name, args[2]);
		ps.save();
		FileSystem.createDirectory('$name/bin');
		FileSystem.createDirectory('$name/src');
		deployTemplates(name);
	}

	private static function init():Void{
		var args = Sys.args();
		if(args.length < 3) fatal("Usage: hb init <name> <target>");
		var ps = Properties.create(args[1], args[2]);
		ps.save();
	}

	private static function deployTemplates(name:String):Void{
    var readme_t = haxe.Resource.getString("Readme_t");
		var template = new haxe.Template(readme_t);
    var output = template.execute({name:name});
		File.saveContent('$name/README.md', output);

    readme_t = haxe.Resource.getString("Main_t");
		template = new haxe.Template(readme_t);
    output = template.execute({classname:"Main"});
		File.saveContent('$name/src/Main.hx', output);
	}

	private static function build(){
		var props:Properties = locateProps();
		(new Builder(props)).build(Sys.args().slice(1));
	}
	private static function buildCmd(){
		var props:Properties = locateProps();
		(new Builder(props)).echoBuildCmd(Sys.args().slice(1));
	}
	private static function library(){
		var props:Properties = locateProps();
		(new LibraryManager(props)).handle(Sys.args().slice(1));
	}

}
