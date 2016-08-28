package epidev;

import haxe.Json;
import epidev.cli.PrintHelper.*;

@:final class Properties{

	private var name:String;
	private var target:String;
	private var source_dir:Array<String>;
	private var main:String;
	private var out_dir:String;
	private var out_bin:String;
	private var libraries_haxe:Map<String,String>;
	private var libraries_reg:Map<String,String>;

	public function new(){
	}
	
	public function unpack(j:Json):Void{
		try{
			name = j.name;
			target = j.target;
			source_dir = j.source_dir;
			main = j.main;
			out_dir = j.out_dir;
			out_bin = j.out_bin;
			libraries_haxe = j.libraries.haxe;
			libraries_reg = j.libraries.target;
		}catch(e:Dynamic){
			fatal("Malformed source json");
			return false;
		}
		return true;
	}

	public function createBuild():Array<String>{
		return [
			'-$target',
			''
		];
	}

}
