package haxe.org.dassista;

import haxe.org.dassista.PdmlContext;
import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;
import haxe.org.multicore.neko.NekoMultiModuleFactory;
import haxe.org.multicore.neko.AbstractNekoMultiModuleFactoryContext;
import haxe.xml.Fast;

import neko.Sys;
import neko.FileSystem;


class DAssista implements IMultiModule
{
    public function new()
    {
    }
	
    public static function main():Bool
	{
	    var start:Float = Sys.time();
	    
	    var instance:DAssista = new DAssista();
	    var globalRoot:String = FileSystem.fullPath(Sys.args()[0]);
        var pdml:String = Sys.args()[1];
        var compileModules:Bool = Sys.args()[2]=="true"?true:false;
        
        // init context
		var context:PdmlContext = new PdmlContext(instance,globalRoot,compileModules);
		context.put("pdml", pdml);
		var result:Bool = instance.execute(context);
		if(!result)
		  trace("----------- execute failed");
		
		var end:Float = Sys.time();
		trace("time "+ (end-start)+ " s");
		return result;
	}
	
	public function execute(context:IMultiModuleContext):Bool
	{
		var pdml:String = context.get("pdml");
		if (pdml.indexOf("/") == -1)
			return context.parsePdmlClass(pdml);
		else
			return context.parsePdmlFile(pdml);
	}
}

