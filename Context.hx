package haxe.org.dassista;

import haxe.org.multicore.AbstractMultiModuleContext;
import haxe.org.multicore.neko.AbstractNekoMultiModuleFactoryContext;
import haxe.org.multicore.neko.NekoMultiModuleFactory;
import haxe.org.multicore.IMultiModule;

import haxe.org.dassista.context.ext.ModuleCompiler;
import haxe.org.dassista.context.ext.PdmlParser;

import neko.io.File;
import neko.io.Path;
import haxe.xml.Fast;

class Context extends AbstractMultiModuleContext
{
	private var _rootFolder:String;
    private var _factoryContext:AbstractNekoMultiModuleFactoryContext;
    private var _alwaysCompile:Bool;
	private var _pdml:Fast;
	private var _target:String;
	private var _parser:PdmlParser;
	private var _compiler:ModuleCompiler;
	private var _hash:Hash<Dynamic>;
    
    public function new(caller:IMultiModule, rootFolder:String, alwaysCompile:Bool)
    {
        super(caller,new NekoMultiModuleFactory());
        
        this._factoryContext = new AbstractNekoMultiModuleFactoryContext();
        this._factoryContext.setRootFolder(rootFolder);        
		this._alwaysCompile = alwaysCompile;
        this._rootFolder = rootFolder;
		
		this._parser = new PdmlParser();
		this._compiler = new ModuleCompiler();
		this._hash = new Hash();
    }
	
	public function get(key:String):Dynamic
	{
		return this._hash.get(key);
	}
	
	public function set(key:String, value:Dynamic):Void
	{
		this._hash.set(key, value);
	}
	
	public function getTarget():String
	{
		return _target;
	}
	
	public function setTarget(value:String):Void
	{
		this._target = value;
	}
	
	public function setAlwaysCompile(value:Bool):Void
	{
		this._alwaysCompile = value;
	}
	
	public function getAlwaysCompile():Bool
	{
		return this._alwaysCompile;
	}
    
    public function getPdml():Fast
    {
		return this._pdml;
    }
	
	public function setPdml(value:Fast):Void
	{
		this._pdml = value;
	}
	
	public function getRootFolder():String
    {
        return this._rootFolder;
    }
	
	public function compileTarget(target:String):Bool
	{
		return this._compiler.compileTarget(target, this);
	}
	
	public function parseTarget(target:String):Bool
	{
		return this._parser.parseTarget(target, this);
	}
	
	public function compileMultiModule(classPath:String):Bool
	{
		this._factoryContext.setModuleUID(classPath);
		return this.getModuleFactory().compileMultiModule(this._factoryContext);
	}

    public function createMultiModule(classPath:String):IMultiModule
    {
        this._factoryContext.setModuleUID(classPath);
        this._factoryContext.setCompileEnabled(this._alwaysCompile == true);
        return this.getModuleFactory().createMultiModule(this._factoryContext);
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
		if(target.indexOf(".") != -1) // full/relative path with extension is not permitted for class paths.
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