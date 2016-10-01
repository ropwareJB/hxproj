package epidev;

import sys.FileSystem;

@:final class Builder{

	private var props:Properties;

	public function new(p:Properties){
		this.props = p;
	}

	public function buildCmd():Array<String>{
		var cmds = ['haxe', '-main', props.main];

		cmds.push('-${props.target}');
		if(TargetDetails.targetRequiresDir(props)){
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
			var r = ':${Reflect.field(props.libraries_haxe, lib)}';
			if(r == ":*") r = "";
			cmds = cmds.concat(["-lib", '$lib$r']);
		}

		for(flag in props.flags) 
			cmds = cmds.concat(["-D", flag]);
		
		return cmds;
	}



}
