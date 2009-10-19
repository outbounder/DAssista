package haxe.org.dassista;

import haxe.org.dassista.module.ScriptedModule;
import haxe.org.dassista.multicore.IMultiModule;
import haxe.org.dassista.multicore.IMultiModuleContext;
import haxe.org.dassista.multicore.MultiModuleContextFactory;

import haxe.Log;
import neko.Sys;
import haxe.xml.Fast;
import neko.io.File;
import neko.FileSystem;
import neko.vm.Loader;
import neko.vm.Module;


class DAssista extends ScriptedModule
{
    public static function main():Dynamic
	{
        // init context
	    var contextFactory:MultiModuleContextFactory = new MultiModuleContextFactory(null);
		var context:IMultiModuleContext = contextFactory.generate();
		context.hashView("root",FileSystem.fullPath(Sys.args()[0])); // global root 
		
		// retrieve the pdml data
        var pdmlContent:String = File.getContent(context.hashView("root")+Sys.args()[1]);
        var xml:Xml = Xml.parse(pdmlContent);
        var pdml:Fast = new Fast(xml.firstElement());
        
        context.hashView("pdml",pdml); // global pdml
		
		// create instance & execute
		var instance:DAssista = new DAssista();
		return instance.execute(context);
	}
}
