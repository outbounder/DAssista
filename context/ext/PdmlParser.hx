package haxe.org.dassista.context.ext;

import haxe.org.multicore.IMultiModuleContext;
import haxe.org.multicore.IMultiModule;
import neko.FileSystem;
import neko.io.File;
import haxe.xml.Fast;

class PdmlParser
{
	public function new()
	{
		
	}
	
	public function parseTarget(target:String, context:IMultiModuleContext):Bool
	{
		if (target.indexOf("/") == -1)
			return this.parsePdmlClass(context.getTarget(), context);
		else
			return this.parsePdmlFile(context.getTarget(), context);
	}
	
	public function parsePdmlClass(moduleClassPath:String, context:IMultiModuleContext):Bool
    {
		moduleClassPath = context.getRealPath(moduleClassPath);
		return this.parsePdmlFile(moduleClassPath + ".pdml", context);
    }

    public function parsePdmlFile(fullPath:String, context:IMultiModuleContext):Bool
    {
		fullPath = context.getRealPath(fullPath);
		
        // retrieve the pdml data
        var pdmlContent:String = File.getContent(fullPath);
        var xml:Xml = Xml.parse(pdmlContent);
        var pdml:Fast = new Fast(xml.firstElement());
        
        var parser:IMultiModule = context.createMultiModule(pdml.att.parser);
		context.setPdml(pdml);
        return parser.execute(context);
    }
}