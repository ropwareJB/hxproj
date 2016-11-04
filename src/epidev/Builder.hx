package epidev;

import sys.FileSystem;
import sys.io.Process;
import sys.io.File;
import epidev.cli.PrintHelper.*;
import epidev.Properties;

@:final class Builder{

	private var props:Properties;

	public function new(p:Properties){
		this.props = p;
	}

	public function buildCmd(props:SolutionProps):Array<String>{
		var cmds = ['--cwd', this.props._path,'-main', props.main];

		cmds.push('-${props.target}');
		if(TargetDetails.targetRequiresDir(props)){
			var outdir = '${props.out_dir}/${props.target}';
			if(!FileSystem.exists(outdir))
				FileSystem.createDirectory(outdir);
			cmds.push(outdir);
		}else{
			var dir = props.out_dir == "" ? "" : '${props.out_dir}/';
			cmds.push('$dir${props.out_bin}');
		}

		for(cp in props.sources) 
			cmds = cmds.concat(["-cp", cp]);

		for(lib in props.libraries_haxe.keys()){
			var r = ':${props.libraries_haxe.get(lib)}';
			if(r == ":*") r = "";
			cmds = cmds.concat(["-lib", '$lib$r']);
		}

		for(flag in props.flags) 
			cmds = cmds.concat(["-D", flag]);

		for(res in props.resources.keys())
			cmds = cmds.concat(["-resource", '${props.resources.get(res)}@$res']);
		
		return cmds;
	}

	private function getBuildNames(names:Array<String>):Array<String>{
		if(names.length == 0){
			var keys = [for(k in props.solutions.keys()) k];
			if(keys.length != 1){
				fatal("Multiple solutions defined. No name passed to build command.");
			}
			names = [props.solutions.keys().next()];
		}
		return names;
	}

	public function echoBuildCmd(names:Array<String>):Void{
		names = getBuildNames(names);
		for(name in names){
			var props = this.props.merge(name);
			println_(buildCmd(props).join(" "));
		}
	}

	public function build(names:Array<String>):Void{
		names = getBuildNames(names);
		for(name in names) build_(name);
	}
	private function build_(name:String):Void{
		var props = this.props.merge(name);
		var cmd:Array<String> = buildCmd(props);

		printGood_("haxe "+cmd.join(" "));
		var p = new Process("haxe", cmd);
		var code = p.exitCode();
		if(code != 0){
			printErr('Compile error $code');
			println_("\t"+p.stderr.readAll().toString());
			return;
		}
		
		if(TargetDetails.targetRequiresDir(props))
			FileSystem.rename('${props.out_dir}/'+TargetDetails.getDefaultOutput(props), '${props.out_dir}/${props.out_bin}');

		var fpbin:String = '${this.props.binFullpath(props)}/${props.out_bin}';
		if(props.prepend != null && props.prepend.length > 0){
			var cc = File.getContent(fpbin);
			File.saveContent(fpbin, props.prepend+cc);
		}
		if(props.prependFile != null && props.prependFile.length > 0){
			var ppc = File.getContent(props.prependFile);
			var cc = File.getContent(fpbin);
			File.saveContent(fpbin, ppc+cc);
		}

		new Process("chmod", ["+x", fpbin]);
	}

}
