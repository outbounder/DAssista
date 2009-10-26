package haxe.org.dassista.modules.outbounder;

import haxe.org.dassista.Context;

import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;

import neko.Sys;
import neko.FileSystem;
import neko.io.File;
import neko.io.Path;
import haxe.xml.Fast;

class Parser implements IMultiModule
{
	private var startTime:Float;
	private var target:String;
	
    public function new()
    {
		this.startTime = Sys.time();
    }
	
    public static function main():Dynamic
	{
		return new Parser();
	}
	
	public function execute(context:IMultiModuleContext):Bool
	{
		trace("parsing " + context.get("target"));
		
		var result:Bool = this.parseTarget(context.get("target"), context);
		if (!result)
			trace("----------- execute failed");
		  
		var end:Float = Sys.time();
		trace("time " + (end - this.startTime) + " s");
		return result;
	}
	
	public function parseTarget(target:String, context:IMultiModuleContext):Bool
	{
		var fullPath:String = context.getRealPath(target);
		if (fullPath.lastIndexOf(".pdml") == -1)
			fullPath = fullPath + ".pdml";
			
        // retrieve the pdml data
        var pdmlContent:String = File.getContent(fullPath);
        var xml:Xml = Xml.parse(pdmlContent);
        var pdml:Fast = new Fast(xml.firstElement());
        
        var parser:IMultiModule = context.createTargetModule(pdml.att.parser);
		var parserContext:IMultiModuleContext = context.clone(this);
		parserContext.set("pdml", pdml);
        return parser.execute(parserContext);
	}
}

