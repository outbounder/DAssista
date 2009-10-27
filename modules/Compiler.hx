package haxe.org.dassista.modules;

import haxe.xml.Fast;
import neko.Sys;
import neko.io.Path;
import neko.FileSystem;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

class Compiler implements IMultiModule
{
	private var startTime:Float;
	
    public function new()
    {
    }
	
	public static function main():Dynamic
	{
		return new Compiler();
	}
	
	public function execute(context:IMultiModuleContext):Bool
	{
		this.startTime = Sys.time();
		
		var target:String = null;
		var pdml:Fast = context.get("pdml");
		if (context.get("target") != null)
			target = context.get("target");
		if (context.get("pdml") != null)
			target = pdml.att.target;

		if (target == null)
			throw "can not compile undefined target";
			
		trace("compiling " + target);
		var result:Bool = this.compileTarget(target,context);
		if(!result)
		  trace("----------- execute failed");
		  
		var end:Float = Sys.time();
		trace("time " + (end - this.startTime) + " s");
		return result;
	}
	
	private function compileTarget(target:String, context:IMultiModuleContext):Bool
	{
		if (target.indexOf("*") == target.length - 1)
		{
			// compile all found under target & its subtargets
			return this.compileDir(target.split("*")[0], context);
		}
		else
		{
			// compile exactly target
			return context.compileTargetModule(target);
		}
	}
	
	private function compileDir(target:String,context:IMultiModuleContext):Bool
	{
		var dirFullPath:String = context.getRealPath(target);
		
		// compile all
		var entries:Array<String> = FileSystem.readDirectory(dirFullPath);
		for (entry in entries)
		{
			if (FileSystem.kind(dirFullPath+entry) == FileKind.kdir)
			{
				if (!this.compileDir(target+entry+".", context))
					return false;
			}
			else if(Path.extension(entry) == "hx")
			{
				if (!context.compileTargetModule(target+Path.withoutExtension(entry)))
					return false;
			}
		}
		return true;
	}
}