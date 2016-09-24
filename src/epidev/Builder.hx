package epidev;

import sys.FileSystem;

@:final class Builder{

	private var props:Properties;

	public function new(p:Properties){
		this.props = p;
	}

	public function buildCmd():Array<String>{
		var cmds = ['haxe', '-main'];
		cmds.push(props.main);

		cmds.push('-${props.target}');
		if(targetRequiresDir()){
			var outdir = '${props.out_dir}/${props.target}';
			if(!FileSystem.exists(outdir))
				FileSystem.createDirectory(outdir);
			cmds.push(outdir);
		}else{
			cmds.push('${props.out_dir}/${props.out_bin}');
		}

		for(cp in props.sources) 
			cmds = cmds.concat(["-cp", cp]);

		for(lib in Reflect.fields(props.libraries_haxe)){
			var r = Reflect.field(props.libraries_haxe, lib);
			cmds = cmds.concat(["-lib", '$lib:$r']);
		}
		
		return cmds;
	}

	private function targetRequiresDir():Bool{
		switch(props.target){
			case JS:   return false;
			case LUA:  return false;
			case SWF:  return false;
			case AS3:  return true;
			case NEKO: return false;
			case PHP:  return true;
			case CPP:  return true;
			case CPPIA:return false;
			case CS:	 return true;
			case JAVA: return true;
			case PYTHON: return false;
		}
	}
	
}
