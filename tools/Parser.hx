package haxe.org.dassista.tools;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

import neko.Sys;
import neko.FileSystem;
import neko.io.File;
import neko.io.Path;
import haxe.xml.Fast;

class Parser implements IMultiModule
{
	private var startTime:Float;

    public function new()
    {
    }
	
    public static function main():Dynamic
	{
		return new Parser();
	}
	
	public function execute(context:IMultiModuleContext):Dynamic
	{
		this.startTime = Sys.time();
		trace("parsing " + context.get("target"));
		
		var result:Dynamic = this.parseTarget(context.get("target"), context);
		if (!result)
			trace("failed");
		  
		var end:Float = Sys.time();
		trace("time " + (end - this.startTime) + " s");
		return result;
	}
	
	public function parseTarget(target:String, context:IMultiModuleContext):Dynamic
	{
		var fullPath:String = context.getRealPath(target);
		if (fullPath.lastIndexOf(".pdml") == -1)
			fullPath = fullPath + ".pdml";
			
        // retrieve the pdml data
        var pdmlContent:String = File.getContent(fullPath);
        var xml:Xml = Xml.parse(pdmlContent);
        var pdml:Fast = new Fast(xml.firstElement());
        
        var parser:IMultiModule = context.createTargetModule(pdml.att.parser);
		var parserContext:IMultiModuleContext = context.clone();
		parserContext.set("pdml", pdml);
        return parser.execute(parserContext);
	}
}

