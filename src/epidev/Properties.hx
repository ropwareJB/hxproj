package epidev;

import haxe.Json;
import sys.io.File;
import epidev.cli.PrintHelper.*;
import epidev.Target;
import epidev.BuildTool;

@:final class Properties{

	public var _path(default,null):String;
	public var _filename(default,null):String;

	public var name:String;
	public var target:Target;
	public var sources:Array<String>;
	public var flags:Array<String>;
	public var main:String;
	public var out_dir:String;
	public var out_bin:String;
	public var prepend:String;
	public var libraries_haxe:Map<String,String>;
	public var libraries_reg:Map<String,String>;

	public function new(path:String, fn:String){
		try {
			this._path = path;
			this._filename = fn;
			var proj = Json.parse(File.getContent(projFilePath()));
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
			flags = j.flags;
			main = j.main;
			out_dir = j.out_dir;
			out_bin = j.out_bin;
			prepend = j.prepend;
			libraries_haxe = [ for(lib in Reflect.fields(j.libraries_haxe)) lib => Reflect.field(j.libraries_haxe, lib) ];
			libraries_reg = [ for(lib in Reflect.fields(j.libraries_target)) lib => Reflect.field(j.libraries_target, lib) ];
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

	public function save():Void{
		File.saveContent(projFilePath(), Json.stringify(this));
	}

	private function projFilePath() return '$_path/$_filename';

}
