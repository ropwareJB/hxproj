package epidev;

import haxe.Json;
import sys.io.File;
import epidev.cli.PrintHelper.*;
import epidev.Target;
import epidev.BuildTool;

class SolutionProps extends CommonProps{
	public var target:Target;
	public var out_dir:String = "bin";
	public var out_bin:String = "Main";
	public var main:String = "Main";
	public function new(){super();}
	override public function unpack(j:Dynamic){
		super.unpack(j);
		target = j.target;
		out_dir = j.out_dir;
		out_bin = j.out_bin;
		main = j.main;
	}

	public function merge(ps:CommonProps){
		this.name = mergeValue(this.name, ps.name);
		this.sources = this.sources.concat(ps.sources);
		this.flags = this.flags.concat(ps.flags);
		this.prepend = mergeValue(this.prepend, ps.prepend);
		this.prependFile = mergeValue(this.prependFile, ps.prependFile);
		this.resources = mergeMap(this.resources, ps.resources);
		this.libraries_haxe = mergeMap(this.libraries_haxe, ps.libraries_haxe);
		this.libraries_reg = mergeMap(this.libraries_reg, ps.libraries_reg);
	}
	private function mergeValue(a:Dynamic, b:Dynamic){
		if(a == null || a == "") return b;
		return a;
	}
	private function mergeMap(a:Map<String,String>, b:Map<String,String>){
		for(f in b.keys()) a.set(f, b.get(f));
		return a;
	}
}

class CommonProps{
	public var name:String;
	public var sources:Array<String> = [];
	public var flags:Array<String> = [];
	public var prepend:String;
	public var prependFile:String;
	public var resources:Map<String,String> = new Map<String,String>();
	public var libraries_haxe:Map<String,String> = new Map<String,String>();
	public var libraries_reg:Map<String,String> = new Map<String,String>();

	public function new(){}
	public function unpack(j:Dynamic){
		name = j.name;
		sources = j.sources;
		flags = j.flags;
		prepend = j.prepend;
		prependFile = j.prependFile;
		resources = [ for(res in Reflect.fields(j.resources)) res => Reflect.field(j.resources, res) ];
		libraries_haxe = [ for(lib in Reflect.fields(j.libraries_haxe)) lib => Reflect.field(j.libraries_haxe, lib) ];
		libraries_reg = [ for(lib in Reflect.fields(j.libraries_target)) lib => Reflect.field(j.libraries_target, lib) ];
	}
}

@:final class Properties{

	public var _path:String;
	public var _filename:String;
	public var common:CommonProps = new CommonProps();
	public var solutions:Map<String,SolutionProps> = new Map<String,SolutionProps>();// TODO

	public function new(){
	}

	public function merge(name:String){
		var sol = solutions.get(name);
		if(sol == null) fatal('Solution \'$name\' doesn\'t exist.');

		sol.merge(common);
		return sol;
	}

	public function loadFile(path:String, fn:String):Properties{
		try {
			this._path = path;
			this._filename = fn;
			unpack(Json.parse(File.getContent(projFilePath())));
		}catch(e:Dynamic){
			fatal("Project not valid JSON.");
		}
		return this;
	}

	public static function create(name:String, target:Target):Properties{
		var p = new Properties();
		p._path = ".";
		p._filename = DEFAULT_FILE;
		p.common.name = name;
		var sol = new SolutionProps();
		sol.target = target;
		sol.out_bin = name;
		p.solutions.set(name, sol);
		p._path = name;
		p.common.sources.push("src");
		TargetDetails.onCreate(sol);
		return p;
	}
	
	private function unpack(j:Dynamic):Void{
		try{
			common.unpack(j.common);
			for(j_sol in Reflect.fields(j.solutions)){
				var sol = new SolutionProps();
				sol.unpack(Reflect.field(j.solutions, j_sol));
				solutions.set(j_sol, sol);
			}
		}catch(e:Dynamic){
			fatal("Malformed source json");
		}
		validateTarget();
	}

	private function validateTarget():Void{
		for(f in solutions.keys()){
			var target = solutions.get(f).target;
			switch(target){
				case JS: continue;
				case LUA: fatal('Target $target not supported.');
				case SWF: fatal('Target $target not supported.');
				case AS3: fatal('Target $target not supported.');
				case NEKO: continue;
				case PHP: continue;
				case CPP: continue;
				case CPPIA: fatal('Target $target not supported.');
				case CS: fatal('Target $target not supported.');
				case JAVA: continue;
				case PYTHON: continue;
				default: fatal('Target \'${target}\' invalid.');
			}
		}
	}

	public function save():Void{
		File.saveContent(projFilePath(), Json.stringify(this, null, "  "));
	}

	public function binFullpath(props:SolutionProps):String{
		return '$_path/${props.out_dir}';
	}
	private function projFilePath() return '$_path/$_filename';

}
