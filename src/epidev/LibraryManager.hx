package epidev;

import sys.FileSystem;
import sys.io.Process;
import sys.io.File;
import epidev.cli.PrintHelper.*;
using Lambda;

@:final class LibraryManager{

	private var props:Properties;

	public function new(p:Properties){
		this.props = p;
	}

	public function addLibraries(xs:Array<String>) xs.map(addLibrary);
	public function addLibrary(lib:String):Void{
		var lib_arr:Array<String> = lib.indexOf(":") == -1?[lib,"*"]:lib.split(":");
		props.libraries_haxe.set(lib_arr[0], lib_arr[1]);
		props.save();
	}

}
