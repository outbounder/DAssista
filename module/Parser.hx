package haxe.org.dassista.module;

import haxe.org.dassista.Context;

import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;

import neko.Sys;
import neko.FileSystem;

class Parser implements IMultiModule
{
	private var startTime:Float;
	private var target:String;
	
    public function new()
    {
		this.startTime = Sys.time();
    }
	
    public static function main():Dynamic
	{
		if (Sys.args().length != 0)
		{
			trace("dassista parser v0.1");
			var instance:Parser = new Parser();
			var globalRoot:String = FileSystem.fullPath(Sys.args()[0]);
			var pdmlTarget:String = Sys.args()[1];
			var alwaysCompile:Bool = false;
			if (Sys.args().length == 3)
				alwaysCompile = Sys.args()[2] == "true";
			// init context
			var context:Context = new Context(instance, globalRoot, alwaysCompile);
			context.setTarget(pdmlTarget);
			return instance.execute(context);
		}
		else
			return new Parser();
	}
	
	public function execute(context:IMultiModuleContext):Bool
	{
		trace("parsing " + context.getTarget());
		
		if (!context.parseTarget(context.getTarget()))
		{
		  trace("----------- execute failed");
		  return false;
		}
		  
		var end:Float = Sys.time();
		trace("time " + (end - this.startTime) + " s");
		return true;
	}
	
	
}

