package epidev;

import haxe.Json;
import sys.io.File;
import epidev.cli.PrintHelper.*;
import epidev.Target;
import epidev.BuildTool;

@:final class Properties{

	public var _path:String;
	public var _filename:String;

	public var name:String;
	public var target:Target;
	public var sources:Array<String> = [];
	public var flags:Array<String> = [];
	public var main:String = "Main";
	public var out_dir:String = "bin";
	public var out_bin:String = "Main";
	public var prepend:String;
	public var prependFile:String;
	public var resources:Map<String,String> = new Map<String,String>();
	public var libraries_haxe:Map<String,String> = new Map<String,String>();
	public var libraries_reg:Map<String,String> = new Map<String,String>();

	public function new(){
	}

	public function loadFile(path:String, fn:String):Properties{
		try {
			this._path = path;
			this._filename = fn;
			var proj = Json.parse(File.getContent(projFilePath()));
			unpack(proj);
		}catch(e:Dynamic){
			fatal("Project not valid JSON.");
		}
		return this;
	}

	public static function create(name:String, target:Target):Properties{
		var p = new Properties();
		p.target = target;
		p.name = name;
		p.out_bin = name;
		p._path = ".";
		p._filename = DEFAULT_FILE;
		return p;
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
			prependFile = j.prependFile;
			resources = [ for(res in Reflect.fields(j.resources)) res => Reflect.field(j.resources, res) ];
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
			case NEKO: return;
			case PHP: return;
			case CPP: return;
			case CPPIA: fatal('Target $target not supported.');
			case CS: fatal('Target $target not supported.');
			case JAVA: return;
			case PYTHON: return;
			default: fatal('Target \'${target}\' invalid.');
		}
	}

	public function save():Void{
		File.saveContent(projFilePath(), Json.stringify(this));
	}

	public function binFullpath():String{
		return '$_path/$out_dir';
	}
	private function projFilePath() return '$_path/$_filename';

}
