package epidev.cli;

import epidev.cli.PrintHelper.*;

@:final class CliParams{

	public var tail:Array<String> = [];
	private var params:Array<CliFlag>;
	private var helpFlag = new CliFlag({short:"h", long:"help", desc:"What you're seeing now"});

	public function new(params:Array<CliFlag>){
		this.params = [helpFlag].concat(params);
	}

	public function process(entryPoints:Map<CliEntryPoint, Void->Void>){
		entryPoints.set(new CliEntryPoint([helpFlag]), printHelp);
		parse_();
		for(p in params) p.sanity();
		var satisfiedEPs = [
			for( k in entryPoints.keys()) 
				if(k.satisfied()) k
		];
		if(satisfiedEPs.length == 0) printHelp();
		for(sEP in satisfiedEPs) entryPoints.get(sEP)();
	}

	public function printHelp(){
		var pt = new PrintTable(3);
		pt.add(["Short","Long","Default","Description"]);
		pt.add(["---","---","---","---"]);
		for(p in params) pt.add(p.helpRow());
		pt.print();
		Sys.exit(0);
	}

	private function parse_(){
		var args:Array<String> = Sys.args();
		var i:Int = 0;
		var f:Bool;
		while(i<args.length){
			var arg = args[i];
			i++;
			f = false;
			for(p in params){
				if(p.match(arg)){
					i = p.parse(i, args);
					f = true;
					break;
				}
			}
			if(f) tail = []
			else tail.push(arg);
		}
	}

}

@:final class CliEntryPoint{

	public var params:Array<CliFlag>;
	public var preprocessors:Array<Void->Void>;
	public function new(params:Array<CliFlag>, ?pps:Array<Void->Void>){
		this.params = params;
		this.preprocessors = pps;
	}
	public function satisfied():Bool{
		if(preprocessors!=null) for(pp in preprocessors) pp();
		for(f in params) if(!f.exists) return false;
		return true;
	}

}

typedef CliFlagStruct = {
	@:optional var short:String;
	@:optional var long:String;
	@:optional var desc:String;
	@:optional var helpInclude:Bool;
}
private class CliFlagParams{
	public var short(default,null):String;
	public var long(default,null):String;
	public var desc(default,null):String;
	public var helpInclude(default,null):Bool = true;
	public function new(p:CliFlagStruct){
		short = p.short;
		long = p.long;
		desc = p.desc;
		helpInclude = p.helpInclude==null?helpInclude:p.helpInclude;
	}
}
class CliFlag{
	public var exists(default,null):Bool;
	private var p:CliFlagParams;
	public function new(?params:CliFlagStruct){
		if(params!=null) this.p = new CliFlagParams(params);
		this.exists = false;
	}
	public function match(s:String) 
		return (p.short != "" && s == '-${p.short}') || (p.long != "" && s == '--${p.long}');

	public function sanity():Bool return true;

	public function parse(i:Int, args:Array<String>){
		exists = true;
		return i;
	}

	public function helpRow():Array<String> return [
		p.short==null?"":'-${p.short}', 
		p.long==null?"":'--${p.long}', 
		"",
		p.desc==null?"":p.desc
	];

	public function trace():Void trace('${p.long}\t-\t$exists');
}

class CliCommand extends CliFlag{

	public function new(?params:CliFlagStruct){
		super(params);
	}
	@:final override public function match(s:String) 
		return (p.short != null && s == '${p.short}') || (p.long != null && s == '${p.long}');

	override public function helpRow():Array<String> return [
		p.short==null?"":'${p.short}', 
		p.long==null?"":'${p.long}', 
		"N/A",
		p.desc==null?"":p.desc
	];

}

typedef CliParamStruct = {
	@:optional var short:String;
	@:optional var long:String;
	@:optional var desc:String;
	@:optional var auto:String;
	@:optional var req:Bool;
	@:optional var helpInclude:Bool;
}
private class CliParamParams extends CliFlagParams{
	public var auto(default,null):String;
	public var req(default,null):Bool = false;
	public function new(p:CliParamStruct){
		super(p);
		auto = p.auto;
		req = p.req==null?req:p.req;
	}
}

@:final class CliParam extends CliFlag{
	public var val(default,null):String = null;
	private var ps:CliParamParams;
	public function new(params:CliParamStruct){
		super(params);
		ps = new CliParamParams(params);
	}
	override public function sanity():Bool{
		if(val == null) val = ps.auto;
		if(ps.req && val == null) {
			printErr_('Mandatory param \'${ps.long}\' unspecified');
			return false;
		}
		return true;
	}

	override public function parse(i:Int, args:Array<String>){
		val = args[i];
		exists = true;
		return i+1;
	}

	override public function helpRow() return [
		ps.short==null?"":'-${ps.short}', 
		ps.long==null?"":'--${ps.long}', 
		ps.auto==null?"":ps.auto,
		ps.desc==null?"":ps.desc
	];

	public function setVal(x:String){
		val = x;
		exists = true;
	}

	override public function trace():Void trace('${ps.long}\t-\t${val}');
}
