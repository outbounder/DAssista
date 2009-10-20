package haxe.org.dassista;

import haxe.org.dassista.module.ActionPdml;
import haxe.org.dassista.multicore.AbstractModule;
import haxe.org.dassista.multicore.IMultiModule;
import haxe.org.dassista.multicore.IMultiModuleContext;
import haxe.org.dassista.multicore.MultiModuleFactory;
import haxe.org.dassista.multicore.MultiModuleContextFactory;

import haxe.Log;
import neko.Sys;
import haxe.xml.Fast;

import neko.io.File;
import neko.FileSystem;
import neko.vm.Loader;
import neko.vm.Module;


class DAssista extends ActionPdml
{
    public static function main():Bool
	{
	    var start:Float = Sys.time();
	    trace("start " + start);
	    
	    var globalRoot:String = FileSystem.fullPath(Sys.args()[0]);
        var instance:DAssista = new DAssista();
        var compileModules:Bool = Sys.args()[2]=="true"?true:false;
        
        // init context
	    var contextFactory:MultiModuleContextFactory = new MultiModuleContextFactory(instance);
		var context:IMultiModuleContext = contextFactory.generate(new MultiModuleFactory(globalRoot,compileModules));
		
		// retrieve the pdml data
        var pdmlContent:String = File.getContent(globalRoot+Sys.args()[1]);
        var xml:Xml = Xml.parse(pdmlContent);
        var pdml:Fast = new Fast(xml.firstElement());
        
        // set initial input values
        context.hashView("pdml",pdml); // pdml content
        context.hashView("root",globalRoot); // global root 
		
		// create execute
		var result:Bool = instance.execute(context);
		if(!result)
		  trace("execute failed");
		  
		var end:Float = Sys.time();
		trace("end " + end);
		trace("time "+ (end-start)+ " s");
		return result;
	}
}
