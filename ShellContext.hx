package haxe.org.dassista;

import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.IMultiModule;

import neko.FileSystem;
import neko.Sys;
import neko.io.Path;
import neko.FileSystem;
import neko.vm.Module;
import neko.vm.Loader;

class ShellContext implements IMultiModuleContext
{
	private var _hash:Hash<Dynamic>;
	private var _cache:Hash<Dynamic>;
	private var _rootFolder:String;
	
	public static function main():Bool 
	{
		trace("dassista shell context v0.1");
		var shellInstance:ShellContext = new ShellContext(FileSystem.fullPath(Sys.args()[0]), new Hash(), new Hash());
		for (arg in Sys.args())
		{
			shellInstance.set(arg.split("=")[0], arg.split("=")[1]);
		}
		return shellInstance.executeTargetModule(Sys.args()[1],shellInstance);
	}
	
	public function new(rootFolder:String,cache:Hash<Dynamic>,hash:Hash<Dynamic>)
	{
		this._rootFolder = rootFolder;
		this._hash = cache;
		this._cache = hash;
	}
	
	public function clone():IMultiModuleContext
	{
		return new ShellContext(this._rootFolder,this._cache,new Hash());
	}
	
	public function get(key:String):Dynamic
	{
		return this._hash.get(key);
	}
	
	public function set(key:String, value:Dynamic):Void
	{
		this._hash.set(key, value);
	}
	
	public function executeTargetModule(target:String, targetContext:IMultiModuleContext):Bool
	{
		var classPath:String = this.getClassPath(target);
		var instance:IMultiModule = this.createTargetModule(classPath);
		return instance.execute(targetContext);
	}
	
	public function createTargetModule(target:String):IMultiModule
	{
		var moduleClassPath:String = this.getClassPath(target);
		
		// check cache 
        if(this._cache.exists(moduleClassPath))
            return this._cache.get(moduleClassPath).execute();
                
        // load the module & return its instance
		try
		{
			this.compileTargetModule(moduleClassPath);
			
			var moduleCompiledPath:String = this.getRealPath(moduleClassPath)+".n";
			var nekoModule:Module = Loader.local().loadModule(moduleCompiledPath);
			this._cache.set(moduleClassPath, nekoModule); // save to cache
			
			var multiModuleInstance:Dynamic = nekoModule.execute();
			return multiModuleInstance;
		}
		catch (e:Dynamic)
		{
			trace("module can not be created:" + target);
			trace("------- stack -----------");
			trace(e);
			return null;
		}
	}
	
	public function compileTargetModule(moduleClassPath:String):Bool
	{
		var moduleDir:String = this.getRealPath(Path.withoutExtension(moduleClassPath)); // only rootFolder + the directory of the module 
		var moduleName:String = Path.extension(moduleClassPath); // only module name
		var oldCwd:String = Sys.getCwd();
		Sys.setCwd(moduleDir);
		var cmd:String = "haxe -cp "+this._rootFolder+" -neko " + moduleName + ".n -main " + moduleClassPath;
		var result:Int = Sys.command(cmd);
		Sys.setCwd(oldCwd);
		return result == 0;
	}
	
	public function getRealPath(target:String):String
	{
		if (target.indexOf(":") != -1)
			return target; // it is full path
			
		if (target.indexOf("/") == -1)
			target = target.split(".").join("/");  // it is class name path style, convert to file system.
			
		return this._rootFolder + target; // return always with root if not a full path
	}
	
	public function getClassPath(target:String):String
	{
		// full/relative path with extension is not permitted for class paths.
		if(target.indexOf(".") != -1 && (target.indexOf(":") != -1 || target.indexOf("./") != -1)) 
			target = Path.withoutExtension(target);
		if(target.indexOf(this._rootFolder) != -1)
			target = target.split(this._rootFolder)[1]; // remove the root folder
		if (target.indexOf("./") == 0)
			target = target.substr(3, target.length - 2);
		if (target.indexOf(":") != -1)
			throw "can not convert full path outside of repo to classpath " + target;
		return target.split("/").join(".");
	}
}