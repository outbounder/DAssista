package org.dassista.api.contexts.neko;

import neko.Sys;
import neko.vm.Module;
import neko.vm.Loader;
import neko.FileSystem;
import neko.io.Path;

class AppContext extends RepoContext
{
	private var _outputHandler:Dynamic->Void;
	
	public function new()
	{
		super();
		
		this.set("moduleCache", new Hash());
		this.set("moduleBinPaths", new Array());
		this.set("moduleSourcePaths", new Array());
	}
	
	private function getOutputHandler():Dynamic->Void
	{
		return this._outputHandler;
	}
	
	private function setOuputHandler(handler:Dynamic->Void):Void
	{
		this._outputHandler = handler;
	}
	
	private function getModuleSearchBinaryPaths():Array<String>
	{
		return this.get("moduleBinPaths");
	}
	
	private function getModuleSearchSourcePaths():Array<String>
	{
		return this.get("moduleSourcePaths");
	}
	
	private function getModuleCache():Hash<Dynamic>
	{
		return this.get("moduleCache");
	}
	
	public function defineModulesSearchPath(sourcePath:String,binaryPath:String):Void
	{
		this.getModuleSearchSourcePaths().push(this.getRealPath(sourcePath));
		this.getModuleSearchBinaryPaths().push(this.getRealPath(binaryPath));
	}
	
	public function callModuleMethod(target:String, method:String, context:MethodContext):Dynamic
	{
		if(method == null || method == "")
			throw "methodName must be provided";
		var module:Dynamic = this.getModule(target);
		var f = Reflect.field(module, method);
		if(Reflect.isFunction(f))
			return Reflect.callMethod(module, f, [context]);
		else
			return null;
	}
	
	public function getModule(target:String):Dynamic
	{
		if(target == null || target == "")
			throw "moduleName must be provided";
			
		// check cache 
        if(this.getModuleCache().exists(target))
            return this.getModuleCache().get(target);
                
		if (this.needsCompile(target))
			if(this.compileModule(target).length != 0)
				throw "can not compile target "+target;
		
		var nekoModule:Module = Module.readPath(this.findDestPath(target.split('.').join('\\')), this.getModuleSearchBinaryPaths(), Loader.local());
		var module:Dynamic = nekoModule.execute(); // execute the module, it should register in the context himself ;)
		
		this.getModuleCache().set(target, module); // save to cache the module instance
		
		return module;
	}
	
	public function compileModule(target:String):String
	{
		var targetaspath:String = target.split('.').join('\\');
		
		var result:Int = -1;
		try
		{		
			var sourcePath:String = this.findSource(targetaspath);
			var destPath:String = this.findDestPath(targetaspath);

			var oldCwd:String = Sys.getCwd();
			Sys.setCwd(sourcePath);
			
			this.createDestDirectory(Path.directory(destPath));
			
			var cmd:String = "haxe -neko " + destPath + " -main " + target + " -D use_rtti_doc";			
			
			var prc:org.neko.Prc = new org.neko.Prc();
			var result:String = prc.exec(cmd);
			if(result.length != 0)
				this.output(result+ " @ "+cmd);
				
			Sys.setCwd(oldCwd);
			
			return result;
		}
		catch (e:Dynamic)
		{
			throw e + " while compiling " + target;
		}
	}
	
	public function createDestDirectory(destPath:String):Void
	{
		destPath = destPath.split(this.getRootFolder())[1]; // exlude root folder
		var curDirPath:String = this.getRootFolder();
		var parts:Array<String> = destPath.split("\\");
		for (dirname in parts)
		{
			curDirPath += dirname;
			if(!FileSystem.exists(curDirPath))
				FileSystem.createDirectory(curDirPath);
			curDirPath+="\\";
		}
	}
	
	private function needsCompile(target:String):Bool
	{
		target = target.split('.').join('\\');
		// try finding the module
		for(path in this.getModuleSearchBinaryPaths())
			if (FileSystem.exists(path +"\\"+target+".n"))
				return false;
				
		return true;
	}
	
	private function findSource(target:String):String
	{
		for(path in this.getModuleSearchSourcePaths())
			if (FileSystem.exists(path +"\\"+target+".hx"))
				return path;
		throw "source path not found "+target+" within "+this.getModuleSearchSourcePaths();
	}
	
	private function findDestPath(target):String
	{
		for(i in 0...this.getModuleSearchSourcePaths().length)
		{
			if (FileSystem.exists(this.getModuleSearchSourcePaths()[i] +"\\"+target+".hx"))
				return this.getModuleSearchBinaryPaths()[i]+"\\"+target+".n";
		}
		throw "binary path not found "+target+" within "+this.getModuleSearchBinaryPaths()+" sources:"+this.getModuleSearchSourcePaths();
	}
	
	public function output(value:Dynamic):Void
	{
		this._outputHandler(value);
	}
}