package haxe.org.dassista;

import haxe.org.multicore.AbstractMultiModuleContext;
import haxe.org.multicore.neko.AbstractNekoMultiModuleFactoryContext;
import haxe.org.multicore.neko.NekoMultiModuleFactory;
import haxe.org.multicore.IMultiModule;

class PdmlContext extends AbstractMultiModuleContext
{
    private var _hash:Hash<Dynamic>;
    private var _factoryContext:AbstractNekoMultiModuleFactoryContext;
    private var alwaysCompile:Bool;
    private var rootFolder:String;
    
    public function new(caller:IMultiModule, rootFolder:String, ?alwaysCompile:Bool)
    {
        super(caller,new NekoMultiModuleFactory()); // pushing so isn't very cool, but it is the `heard beat`...
        this._hash = new Hash();
        this._factoryContext = new AbstractNekoMultiModuleFactoryContext();
        this._factoryContext.setRootFolder(rootFolder);        
        this.alwaysCompile = alwaysCompile;
        this.rootFolder = rootFolder;
    }
    
    public function get(key:String):Dynamic
    {
        return _hash.get(key);  
    }

    public function put(key:String,value:Dynamic):Void
    {
        _hash.set(key,value);
    }

    public function createNekoModule(classPath:String):IMultiModule
    {
        this._factoryContext.setModuleUID(classPath);
        this._factoryContext.setCompileEnabled(alwaysCompile == true);
        return this.getModuleFactory().createMultiModule(this._factoryContext);
    }
	
	public function getPdmlFactory():IMultiModule
	{
		return this.createNekoModule("haxe.org.dassista.module.PdmlFactory");
	}

    public function getRootFolder():String
    {
        return this.rootFolder;
    }
}