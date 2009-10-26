package haxe.org.dassista;

import neko.FileSystem;
import neko.Sys;

class Shell
{
	public static function main():Bool 
	{
		trace("dassista shell v0.1");
		var globalRoot:String = FileSystem.fullPath(Sys.args()[1]);
		var target:String = Sys.args()[2];
			
		// init context
		var context:Context = new Context(null, globalRoot);
		context.set("target", target);
		return context.executeTargetModule(Sys.args()[0], context);
	}
}