package haxe.org.dassista;

import haxe.org.dassista.module.PdmlFactory;
import haxe.org.dassista.module.PdmlContext;
import haxe.org.multicore.neko.IMultiModule;
import haxe.org.multicore.neko.IMultiModuleContext;
import haxe.org.multicore.neko.MultiModuleFactory;

import neko.Sys;
import neko.FileSystem;


class DAssista extends PdmlFactory
{
    public static function main():Bool
	{
	    var start:Float = Sys.time();
	    trace("start " + start);
	    
	    var instance:DAssista = new DAssista();
	    var globalRoot:String = FileSystem.fullPath(Sys.args()[0]);
        var pdml:String = FileSystem.fullPath(globalRoot+Sys.args()[1]);
        var compileModules:Bool = Sys.args()[2]=="true"?true:false;
        
        // init context
        var moduleFactory:MultiModuleFactory = new MultiModuleFactory(globalRoot,compileModules);
		var context:PdmlContext = new PdmlContext(instance,moduleFactory);

        // set initial input values
        context.put("pdml",pdml); // pdml content
        context.put("root",globalRoot); // global root 
		
		// create execute
		var result:Bool = instance.execute(context);
		if(!result)
		  trace("execute failed");
		  
		trace(context.get("result"));
		  
		var end:Float = Sys.time();
		trace("end " + end);
		trace("time "+ (end-start)+ " s");
		return result;
	}
}

