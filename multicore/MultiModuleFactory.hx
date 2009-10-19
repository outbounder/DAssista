package haxe.org.dassista.multicore;

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
		// compile to the module's class path folder
		var result:Int = compiler.compile();
		if(result != 0)
		  throw "exception found during compile... "+result;
		
		// load the module & return its instance
		var moduleCompiledPath:String = this.rootPath+this.getMultiModuleNekoPath(moduleClassPath);
		var nekoModule:Module = Loader.local().loadModule(moduleCompiledPath);
		return nekoModule.execute();
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
