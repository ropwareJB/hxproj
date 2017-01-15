package epidev.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import sys.io.File;
import sys.FileSystem;
using Std;

@:enum abstract MSGS(String) to String{
	var ERR_READ = 'No read permissions to build number file';
	var ERR_INT = 'Build number in build number file NaN';
	var ERR_WRITE = 'No write permissions to build number file.';
}

@:final class BuildNum{

	public static var filename:String;

	macro public static function build(path:String=".build"):Array<haxe.macro.Expr.Field>{
		filename = path;
		var n:Null<Int> = get();
		if(n == -1) Context.fatalError(ERR_READ, Context.currentPos());
		else if(n == null) Context.fatalError(ERR_INT, Context.currentPos());
		n++;
		try File.saveContent(filename, '${n}')
		catch(e:Dynamic){
			Context.fatalError(ERR_WRITE, Context.currentPos());
		}
		return Context.getBuildFields();
	}

	macro public static function get():ExprOf<Null<Int>>{
		if(!FileSystem.exists(filename)) return macro $v{0};
		var no:Int;
		try no = File.getContent(filename).parseInt()
		catch(e:Dynamic){
			return macro $v{-1};
		}
		return macro $v{no};
	}

}
