package epidev;

import epidev.macro.BuildNum;

@:build(epidev.macro.BuildNum.build())
@:final class BuildTool{
	
	public static function main(){
		trace("wee!" + BuildNum.get());
	}

}
