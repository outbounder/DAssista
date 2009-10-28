package haxe.org.dassista.tools;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.rtti.Infos;

import neko.Sys;
import neko.FileSystem;
import neko.io.File;
import neko.io.Path;
import haxe.xml.Fast;

class Parser implements IMultiModule, implements Infos
{
	private var startTime:Float;

    public function new()
    {
    }
	
    public static function main():Dynamic
	{
		return new Parser();
	}
	
	/**
	 * @param  context
	 * @return true or false
	 * @_target class|file path to entry without the .pdml extension
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		this.startTime = Sys.time();
		trace("parsing " + context.get("target"));
		
		var result:Dynamic = this.parseTarget(context.get("target"), context);
		if (!result)
		{
			trace("failed");
			trace(context.describe(this,"execute"));
		}
		  
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
		var result:Dynamic = parser.execute(parserContext);
		for (key in parserContext.keys())
			context.set(key, parserContext.get(key));
		return result;
	}
}

