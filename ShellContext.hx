package haxe.org.dassista;

import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.ModuleException;
import haxe.Stack;

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
	
	public static function main():Dynamic 
	{
		trace("dassista shell context v0.1");
		if (Sys.args().length == 0)
			throw "not supported execution, try with module=<moduleClassPath> <module additional args>";
		
		var shellInstance:ShellContext = new ShellContext(Sys.getCwd(), new Hash(), new Hash());
		for (arg in Sys.args())
			shellInstance.set(arg.split("=")[0], arg.split("=")[1]);
		
		var result:Bool = false;
		try
		{
			if(shellInstance.getSysArg("method") == null)
				result = shellInstance.executeTargetModule(shellInstance.getSysArg("module"), shellInstance); 
			else
				result = shellInstance.callTargetModuleMethod(shellInstance.getSysArg("module"), shellInstance.getSysArg("method"), shellInstance); 
		}
		catch (e:Dynamic)
		{
			var module = Reflect.field(e, "getModule");
			if (Reflect.isFunction(module)) 
			{
				// assuming it is ModuleException
				trace("-- ModuleException found:\n" + e.getMessage());
				trace("-- Module:\n"+shellInstance.describe(e.getModule()));
				trace("-- Method:\n" + shellInstance.describe(e.getModule(), e.getMethod()).toString());
				trace(Stack.toString(Stack.exceptionStack()));
			}
			else	
				trace("Unknown exception found:" + e);
		}
		if (result == false)
			trace("shell execution failed");
		return result;
	}
	
	private function getSysArg(name:String):String
	{
		for (arg in Sys.args())
		{
			var parts:Array < String > = arg.split("=");
			if (parts[0] == name)
				return parts[1];
		}
		return null;
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
	
	public function has(key:String):Bool
	{
		return this._hash.exists(key);
	}
	
	public function get(key:String):Dynamic
	{
		return this._hash.get(key);
	}
	
	public function set(key:String, value:Dynamic):Void
	{
		this._hash.set(key, value);
	}
	
	public function keys():Iterator<String>
	{
		return this._hash.keys();
	}
	
	public function describe(instance:IMultiModule, ?field:String):Xml
	{
		return haxe.org.dassista.Attributes.of(Type.getClass(instance), field).toXml();
	}
	
	public function executeTargetModule(target:String, targetContext:IMultiModuleContext):Dynamic
	{
		var classPath:String = this.getClassPath(target);
		var instance:IMultiModule = this.createTargetModule(classPath);
		return instance.execute(targetContext);
	}
	
	public function callTargetModuleMethod(target:String, methodName:String, methodContext:IMultiModuleContext):Dynamic
	{
		var classPath:String = this.getClassPath(target);
		var instance:IMultiModule = this.createTargetModule(classPath);
		var f = Reflect.field(instance, methodName);
		if(Reflect.isFunction(f))
			return Reflect.callMethod(instance, f, [methodContext]);
		else
			throw new ModuleException('not a possible action '+methodName+" over module "+Type.getClass(instance), instance, methodName);
	}
	
	public function createTargetModule(target:String):IMultiModule
	{
		var moduleClassPath:String = this.getClassPath(target);
		
		// check cache 
        if(this._cache.exists(moduleClassPath))
            return this._cache.get(moduleClassPath);
                
        // load the module & return its instance
		try
		{
			this.compileTargetModule(moduleClassPath);
			
			var moduleCompiledPath:String = this.getRealPath(moduleClassPath)+".n";
			var nekoModule:Module = Loader.local().loadModule(moduleCompiledPath);
			var multiModuleInstance:Dynamic = nekoModule.execute();
			
			this._cache.set(moduleClassPath, multiModuleInstance); // save to cache
			return multiModuleInstance;
		}
		catch (e:Dynamic)
		{
			trace("module can not be created:" + target);
			trace("------- stack -----------");
			throw e;
			return null;
		}
	}
	
	public function compileTargetModule(moduleClassPath:String):Bool
	{
		var moduleDir:String = this.getRealPath(Path.withoutExtension(moduleClassPath)); // only rootFolder + the directory of the module 
		var moduleName:String = Path.extension(moduleClassPath); // only module name
		
		var result:Int = -1;
		try
		{
			var oldCwd:String = Sys.getCwd();
			Sys.setCwd(moduleDir);
			var cmd:String = "haxe -cp "+this._rootFolder+" -neko " + moduleName + ".n -main " + moduleClassPath+" -D use_rtti_doc";
			result = Sys.command(cmd);
			Sys.setCwd(oldCwd);
		}
		catch (e:Dynamic)
		{
			throw e+" while compiling "+moduleClassPath;
		}
		
		return result == 0;
	}
	
	public function getRealPath(target:String):String
	{
		if (target.indexOf(":") != -1)
			return target; // it is full path
			
		if (target.indexOf("/") == -1)
			target = target.split(".").join("/");  // it is class name path style, convert to file system.
		if (target.indexOf("./") == 0)
			target = target.substr(2); // remove the relative prefix
		var result:String = this._rootFolder + target;
		result = result.split("/").join("\\"); // workaround slashes
		// remove last slash
		if (result.charAt(result.length - 1) == "\\") // to be changed
			return result.substr(0, result.length - 1);
		else
			return result;
	}
	
	public function getClassPath(target:String):String
	{
		// full/relative path with extension is not permitted for class paths.
		if(target.indexOf(".") != -1 && (target.indexOf(":") != -1 || target.indexOf("./") != -1)) 
			target = Path.withoutExtension(target);
		if (target.indexOf(this._rootFolder) != -1)
			target = target.split(this._rootFolder)[1]; // remove the root folder
		if (target.indexOf("./") == 0)
			target = target.substr(3, target.length - 2);
		if (target.indexOf(":") != -1)
			throw "can not convert full path outside of repo to classpath " + target;
		return target.split("\\").join(".");
	}
}