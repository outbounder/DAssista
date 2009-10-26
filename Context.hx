package haxe.org.dassista;

import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;
import haxe.org.multicore.neko.NekoMultiModuleFactory;
import haxe.org.multicore.neko.NekoMultiModuleFactoryContext;

import neko.io.File;
import neko.io.Path;

class Context implements IMultiModuleContext
{
	private var _caller:IMultiModule;
	
	private var _factory:NekoMultiModuleFactory;
	private var _factoryContext:NekoMultiModuleFactoryContext;
	
	private var _hash:Hash<Dynamic>;
	private var _rootFolder:String;
    
    public function new(caller:IMultiModule,rootFolder:String)
    {
		this._hash = new Hash();
		this._rootFolder = rootFolder;
		
		this._factoryContext = new NekoMultiModuleFactoryContext(rootFolder);
		this._factory = new NekoMultiModuleFactory();
    }
	
	public function clone(caller:IMultiModule):IMultiModuleContext
	{
		return new Context(caller, this._rootFolder);
	}
	
	public function getRootFolder():String
	{
		return this._rootFolder;
	}
	
	public function getCaller():IMultiModule
	{
		return this._caller;
	}
	
	public function get(key:String):Dynamic
	{
		return this._hash.get(key);
	}
	
	public function set(key:String, value:Dynamic):Void
	{
		this._hash.set(key, value);
	}
	
	public function executeTargetModule(target:String, context:IMultiModuleContext):Bool
	{
		var classPath:String = this.getClassPath(target);
		this._factoryContext.setModuleUID(classPath);
        var instance:IMultiModule = this._factory.createMultiModule(this._factoryContext);
		return instance.execute(context);
	}
	
	public function createTargetModule(target:String):IMultiModule
	{
		var classPath:String = this.getClassPath(target);
		this._factoryContext.setModuleUID(classPath);
		var instance:IMultiModule = this._factory.createMultiModule(this._factoryContext);
		return instance;
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