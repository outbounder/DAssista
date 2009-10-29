package haxe.org.dassista.contexts;

import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.ModuleException;
import haxe.rtti.Infos;

import neko.vm.Module;
import neko.vm.Loader;
import neko.FileSystem;
import neko.io.Path;
import neko.Sys;

class MultiModuleContext implements IMultiModuleContext, implements IMultiModule, implements Infos
{
	private var _rootFolder:String;
	private var _hash:Hash<Dynamic>;
	private var _cache:Hash<Dynamic>;
	
	public static function main() { return new MultiModuleContext(); }
	
	public function new() 
	{ 
		this._hash = new Hash(); 
		this._cache = new Hash();
	}
	
	/**
	 * 
	 * @param	context
	 * @return Dynamic or false
	 * @module which has to be compiled/created
	 * @rootFolder which will be used to compile, getClassPath, getRealPath
	 * @method (optional) which has to be invoked otherwise default 'execute' method is invoked
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		try
		{
			if (!context.has("module") || !context.has("rootFolder"))
				throw new ModuleException("module and rootFolder are needed", this, "execute");
				
			this._rootFolder = context.get("rootFolder"); // refine rootFolder for the current instance
			
			// execute the target module or its method
			if (context.has("method"))
				return this.callTargetModuleMethod(context.get("module"), context.get("method"), this);
			else
				return this.executeTargetModule(context.get("module"), this);
		}
		catch (e:Dynamic)
		{
			this.output(e);
			return false;
		}
	}
	
	public function clone():IMultiModuleContext
	{
		var clone:IMultiModuleContext = new ShellContext();
		clone._rootFolder = this._rootFolder;
		clone._cache = this._cache;
		return clone;
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
	
	public function output(value:Dynamic):Void
	{
		trace(value);
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
			throw new ModuleException("module can not be created:" + target,this,"createTargetModule");
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
			throw new ModuleException(e+" while compiling "+moduleClassPath,this,"compileTargetModule");
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
			throw new ModuleException("can not convert full path outside of repo to classpath " + target,this,"getClassPath");
		return target.split("\\").join(".");
	}
}