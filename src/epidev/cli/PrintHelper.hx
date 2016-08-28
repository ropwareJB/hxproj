package epidev.cli;

import sys.io.FileOutput;
import sys.io.File;
using StringTools;

@:final class PrintHelper{

	public static var outputFilename:String = null;
	public static var colour:Bool = true;

	public static inline function _print(x:String){
		if(outputFilename != null){
			var fo:FileOutput = File.append(outputFilename, true);
			fo.writeString(x);
		}
		return Sys.print(x);
	}
  public static inline function println(x:String) println_('[+] $x');
  public static inline function println_(x:String) _print('$x\n');
  public static inline function printGood(x:String) return println_(clrGood('[+] $x'));
  public static inline function printGood_(x:String) return println_(clrGood(x));
  public static inline function printWarn(x:String) return println_(clrWarn('[+] $x'));
  public static inline function printWarn_(x:String) return println_(clrWarn('$x'));
  public static inline function printNor(x:String) return println_(clrNorm('[+] $x'));
  public static inline function printNor_(x:String) return println_(clrNorm('$x'));
  public static inline function printErr(x:String) return println_(clrBad('[-] $x'));
  public static inline function printErr_(x:String) return println_(clrBad('$x'));
  public static inline function fatal(x:String) {
    printErr_(x);
		Sys.exit(0);
  }

	public static function formTabular(l:String, r:String, len:Int, c:String="."):String{
		return l.rpad(c, len-r.length)+r;
	}

	public static function clrGood(x:String) return colour?'\033[0;92m$x\033[0m':x;
	public static function clrWarn(x:String) return colour?'\033[1;33m$x\033[0m':x;
	public static function clrBad(x:String)  return colour?'\033[1;31m$x\033[0m':x;
	public static function clrNorm(x:String) return colour?'\033[0;37m$x\033[0m':x;

	public static function testColours():Void{
		var x = ["Good" => printGood, "Normal" => printNor, "Warn" => printWarn, "Error" => printErr];
		for(k in x.keys()) x[k]('{$k} The quick brown fox jumps over the lazy dog');
	}
}
