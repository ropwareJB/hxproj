package epidev.cli;

import epidev.cli.PrintHelper.*;
using StringTools;

@:final class PrintTable{

	private var rows:Array<Array<String>> = [];
	private var padding:Int;
	private var colsLen:Array<Int> = [];

	public function new(padding:Int=0){
		this.padding = padding;
	}

	public function add(x:Array<String>) {
		rows.push(x);
		for(xi in 0...x.length){
			if(colsLen.length <= xi) colsLen.push(0);
			if(x[xi].length > colsLen[xi]) 
				colsLen[xi] = x[xi].length;
		}
	}

	public function print():Void{
		for(r in rows){
			for(r_i in 0...r.length)
				_print(r[r_i].rpad(" ", colsLen[r_i]+padding));
			_print("\n");
		}
	}

}
