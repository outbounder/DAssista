package haxe.org.dassista;

import neko.io.File;
import haxe.xml.Fast;
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
        super(caller,new NekoMultiModuleFactory());
        
        this._factoryContext = new AbstractNekoMultiModuleFactoryContext();
        this._factoryContext.setRootFolder(rootFolder);        
		
		this._hash = new Hash();
		
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
	
	public function parsePdmlClass(moduleClassPath:String):Bool
    {
		moduleClassPath = this.getRealPath(moduleClassPath);
		return this.parsePdmlFile(moduleClassPath + ".pdml");
    }

    public function parsePdmlFile(fullPath:String):Bool
    {
		fullPath = this.getRealPath(fullPath);
		
        // retrieve the pdml data
        var pdmlContent:String = File.getContent(fullPath);
        var xml:Xml = Xml.parse(pdmlContent);
        var pdml:Fast = new Fast(xml.firstElement());
        
        var parser:IMultiModule = this.createNekoModule(pdml.att.parser);
        this.put("pdml", pdml);
		this.put("pdml-path", fullPath);
        return parser.execute(this);
    }
	
    public function getRootFolder():String
    {
        return this.rootFolder;
    }
	
	public function getRealPath(target:String):String
	{
		if (target.indexOf(":") != -1)
			return target; // it is full path
			
		if (target.indexOf("/") == -1)
			target = target.split(".").join("/");  // it is class name path style, convert to file system.
			
		return this.rootFolder + target; // return always with root if not a full path
	}
	
	public function getClassPath(target:String):String
	{
		if (target.indexOf(this.rootFolder) != -1) 
			target = target.split(this.rootFolder)[1]; // remove the root folder if possible
		if (target.indexOf(":") != -1)
			throw "can not convert full path outside of repo to classpath " + target;
		return target.split("/").join(".");
	}
}