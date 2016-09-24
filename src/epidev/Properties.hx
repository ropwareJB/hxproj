package epidev;

import haxe.Json;
import sys.io.File;
import epidev.cli.PrintHelper.*;
import epidev.Target;

@:final class Properties{

	public var name:String;
	public var target:Target;
	public var sources:Array<String>;
	public var main:String;
	public var out_dir:String;
	public var out_bin:String;
	public var libraries_haxe:Map<String,String>;
	public var libraries_reg:Map<String,String>;

	public function new(path:String){
		try {
			var proj = Json.parse(File.getContent(path));
			unpack(proj);
		}catch(e:Dynamic){
			fatal("Project not valid JSON.");
		}
	}
	
	private function unpack(j:Dynamic):Void{
		try{
			name = j.name;
			target = j.target;
			sources = j.sources;
			main = j.main;
			out_dir = j.out_dir;
			out_bin = j.out_bin;
			libraries_haxe = j.libraries.haxe;
			libraries_reg = j.libraries.target;
		}catch(e:Dynamic){
			fatal("Malformed source json");
		}
		validateTarget();
	}

	private function validateTarget():Void{
		switch(target){
			case JS: fatal('Target $target not supported.');
			case LUA: fatal('Target $target not supported.');
			case SWF: fatal('Target $target not supported.');
			case AS3: fatal('Target $target not supported.');
			case NEKO: fatal('Target $target not supported.');
			case PHP: fatal('Target $target not supported.');
			case CPP: fatal('Target $target not supported.');
			case CPPIA: fatal('Target $target not supported.');
			case CS: fatal('Target $target not supported.');
			case JAVA: fatal('Target $target not supported.');
			case PYTHON: return;
			default: fatal('Target \'${target}\' invalid.');
		}
	}

}
