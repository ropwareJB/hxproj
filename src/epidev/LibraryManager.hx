package epidev;

import sys.FileSystem;
import sys.io.Process;
import sys.io.File;
import epidev.cli.PrintHelper.*;
using Lambda;

@:enum private abstract COMMAND(String) from String{
	var ADD = "add";
	var REMOVE = "remove";
	var LIST = "list";
	var INSTALL = "install";
	var UPDATE = "update";
}

@:final class LibraryManager{

	private var props:Properties;

	public function new(p:Properties){
		this.props = p;
	}

	private function add(xs:Array<String>) xs.map(addLibrary);
	private function addLibrary(lib:String):Void{
		var lib_arr:Array<String> = lib.indexOf(":") == -1?[lib,"*"]:lib.split(":");
		props.common.libraries_haxe.set(lib_arr[0], lib_arr[1]);
		props.save();
	}

	public function handle(args:Array<String>){
		if(args.length == 0) 
			fatal("No arguments to lib command?");
		
		var cmds:Map<COMMAND,Array<String>->Void> = [
			ADD => add,
			REMOVE => remove,
			LIST => list,
			INSTALL => install,
			UPDATE => update,
		];
		if(!cmds.exists(args[0]))
			fatal("Command doesn't exist");

		cmds.get(args[0])(args.slice(1));
	}

	private function remove(xs:Array<String>):Void{
		for(x in xs){
			if(!props.common.libraries_haxe.remove(x))
				printWarn('Library $x not found in project configuration.');
		}
		props.save();
	}

	private function list(xs:Array<String>):Void{
		for(lib in props.common.libraries_haxe.keys())
			printNor('$lib => ${props.common.libraries_haxe.get(lib)}');
		var len = [for(k in props.common.libraries_haxe.keys()) k].length;
		
		printNor_('$len ${len==1?"Library":"Libraries"}');
	}

	private function install(xs:Array<String>):Void{
		for(lib in props.common.libraries_haxe.keys()){
			var libver = props.common.libraries_haxe.get(lib);
			var libid:String = lib + (libver=="*"?"":':$libver');
			var p = new Process("haxelib", ["install", libid]);
			if(p.exitCode() != 0){
				printErr('haxelib: Failed installing $lib');
				println_("\t"+p.stdout.readAll().toString());
				Sys.exit(1);
			}
		}
		printGood("Installed all dependency libraries.");
	}

	private function update(xs:Array<String>):Void{
		for(lib in props.common.libraries_haxe.keys()){
			var libver = props.common.libraries_haxe.get(lib);
			if(libver != "*") continue;
			var p = new Process("haxelib", ["update", lib]);
			if(p.exitCode() != 0){
				printErr('haxelib: Failed updating $lib');
				println_("\t"+p.stdout.readAll().toString());
				Sys.exit(1);
			}
		}
		printGood("Updated all dependency libraries.");
	}

}
