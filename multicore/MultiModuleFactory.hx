package haxe.org.dassista.pdml;

import haxe.org.dassista.multicore.IMultiModule;
import haxe.org.dassista.multicore.IMultiModuleContext;

import neko.FileSystem;
import neko.Lib;
import neko.Sys;
import neko.vm.Module;
import neko.vm.Loader;
import haxe.xml.Fast;

class MultiModuleFactory
{
	private var rootPath:String;
	
	public function new(rootPath:String)
	{
		this.rootPath = rootPath;
	}
	
	public function createMultiModule(moduleClassPath:String):IMultiModule
	{
		// ensure that the module is up-to-date
		var compiler:ModuleCompiler = new ModuleCompiler(this.rootPath, this.getMultiModuleHaxePath(moduleClassPath));
		compiler.compile();
		
		// load the module & return its instance
		var nekoModule:Module = Loader.local().loadModule(this.getMultiModuleNekoPath(moduleClassPath));
		var multiModuleInstance:Dynamic = nekoModule.execute();
		if(Std.is(multiModuleInstance, IMultiModule))
		{
      return multiModuleInstance;
    }
    else
      throw "given module class is not a multimodule entry point";
	}
	
	public function getMultiModuleHaxePath(module:String):String
	{
		return module.split(".").join("/") + ".hx";
	}
	
	public function getMultiModuleNekoPath(module:String):String
	{
		return module.split(".").join("/") + ".n";
	}
}
