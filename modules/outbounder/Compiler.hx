package haxe.org.dassista.modules.outbounder;

import haxe.xml.Fast;
import neko.Sys;
import neko.io.Path;
import neko.FileSystem;

import haxe.org.dassista.Context;

import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;
import haxe.org.multicore.neko.NekoMultiModuleFactory;
import haxe.org.multicore.neko.NekoMultiModuleFactoryContext;

class Compiler implements IMultiModule
{
	private var startTime:Float;
	private var _factory:NekoMultiModuleFactory;
	private var _factoryContext:NekoMultiModuleFactoryContext;
	
    public function new()
    {
		this.startTime = Sys.time();
		this._factory = new NekoMultiModuleFactory();
		this._factoryContext = new NekoMultiModuleFactoryContext();
    }
	
	public static function main():Dynamic
	{
		return new Compiler();
	}
	
	public function execute(context:IMultiModuleContext):Bool
	{
		var target:String = null;
		if (context.get("target") != null)
			target = context.get("target");
		if (context.get("pdml") != null)
		{
			var pdml:Fast = context.get("pdml");
			target = pdml.att.target;
		}
		if (target == null)
			throw "can not compile undefined target";
			
		trace("compiling " + target);
		this._factoryContext.setRootFolder(context.getRootFolder());
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
			return this.compileModule(target, context);
		}
	}
	
	private function compileDir(target:String,context:IMultiModuleContext):Bool
	{
		var dirFullPath:String = context.getRealPath(target);
		
		// clear all compiled modules
		var entries:Array<String> = FileSystem.readDirectory(dirFullPath);
		for (entry in entries)
		{
			if (Path.extension(dirFullPath + entry) == "n" && entry != "Compiler.n")
			{
				FileSystem.deleteFile(dirFullPath + entry);
				continue;
			}
		}
		
		// compile all
		var entries:Array<String> = FileSystem.readDirectory(dirFullPath);
		for (entry in entries)
		{
			if (FileSystem.kind(dirFullPath+entry) == FileKind.kdir)
			{
				if (!this.compileDir(dirFullPath+entry+"/", context))
					return false;
			}
			else
			{
				if (!this.compileModule(dirFullPath+Path.withoutExtension(entry), context))
					return false;
			}
		}
		return true;
	}
	
	private function compileModule(target:String, context:IMultiModuleContext):Bool
	{
		// do not self compile
		var classPath:String = context.getClassPath(target);
		if (classPath == "haxe.org.dassista.modules.outbounder.Compiler")
			return true;

		this._factoryContext.setModuleUID(classPath);
		return this._factory.compileMultiModule(this._factoryContext);
	}
}