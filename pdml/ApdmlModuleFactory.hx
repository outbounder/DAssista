package haxe.org.dassista.pdml;

import haxe.org.dassista.pdml.ApdmlModule;

import neko.FileSystem;
import neko.Lib;
import neko.Sys;
import neko.vm.Module;
import neko.vm.Loader;

class ApdmlModuleFactory
{
	private var rootPath:String;
	
	public function new(rootPath:String)
	{
		this.rootPath = rootPath;
	}
	
	public function createApdmlModule(module:String):ApdmlModule
	{
		// ensure that the module is up-to-date
		this.compileApdmlModuleToNekoBytecode(module);
		
		// load the module
		var nekoModule:Module = Loader.local().loadModule(this.getApdmlModuleFolder(module)+this.getApdmlModuleName(module) + ".n");
		//Module.readPath(, [this.getApdmlModuleFolder(module)], Loader.local());
		var apdmlModule:ApdmlModule = new ApdmlModule(nekoModule, this.getApdmlModuleName(module));
		return apdmlModule;
	}
	
	public function getApdmlModuleHaxePath(module:String):String
	{
		return module.split(".").join("/") + ".hx";
	}
	
	public function getApdmlModuleNekoPath(module:String):String
	{
		return module.split(".").join("/") + ".n";
	}
	
	public function compileApdmlModuleToNekoBytecode(module:String):Void
	{
		var moduleHaxeSourcePath:String = this.rootPath+this.getApdmlModuleHaxePath(module);
		var moduleName = this.getApdmlModuleName(module);
		
		// if the module is found as source then recompile
		// TODO this need to be optimized with caching compiled output until the source code is changed.
		if (FileSystem.exists(moduleHaxeSourcePath))
		{
			var oldCwd:String = Sys.getCwd();
			Sys.setCwd(this.getApdmlModuleFolder(module));
			var cmd:String = "haxe -cp " + this.rootPath + " -neko " + moduleName + ".n " + module;
			Sys.command(cmd);
			Sys.setCwd(oldCwd);
		}
		else
			throw "DAssista > can not find source code at " + moduleHaxeSourcePath;
	}
	
	public function getApdmlModuleName(module:String):String
	{
		return module.split(".").pop();
	}
	
	public function getApdmlModuleFolder(module:String):String
	{
		var path:Array < String > =  module.split(".");
		path.pop();
		return this.rootPath + path.join("/")+"/";
	}
}