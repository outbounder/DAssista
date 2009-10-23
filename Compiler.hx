package haxe.org.dassista;

import neko.Sys;
import neko.FileSystem;

import haxe.org.dassista.Context;

import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;

class Compiler implements IMultiModule
{
	private var startTime:Float;
	
    public function new()
    {
		this.startTime = Sys.time();
    }
	
	public static function main():Dynamic
	{
		if (Sys.args().length != 0)
		{
			trace("dasista compiler v0.1");
			var instance:Compiler = new Compiler();
			var globalRoot:String = FileSystem.fullPath(Sys.args()[0]);
			var pdmlTarget:String = Sys.args()[1];
			
			// init context
			var context:Context = new Context(instance, globalRoot, true);
			context.setTarget(pdmlTarget);
			return instance.execute(context);
		}
		else 
		{
			return new Compiler();
		}
	}
	
	public function execute(context:IMultiModuleContext):Bool
	{
		trace("compiling " + context.getTarget());
		var result:Bool = context.compileTarget(context.getTarget());
		if(!result)
		  trace("----------- execute failed");
		  
		var end:Float = Sys.time();
		trace("time " + (end - this.startTime) + " s");
		return result;
	}
}