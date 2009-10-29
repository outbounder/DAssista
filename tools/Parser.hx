package haxe.org.dassista.tools;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;

import haxe.rtti.Infos;
import neko.Sys;
import neko.FileSystem;
import neko.io.File;
import neko.io.Path;
import haxe.xml.Fast;

/**
 * @author Boris Filipov
 * @version 0.1
 * @name haxe.org.dassista.tools.Parser
 * @description Reads target class path entry (appending .pdml) & uses its self-defined parser.
 */
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
	 * @return Bool
	 * @_target class|file path to entry without the .pdml extension
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("target"))
			throw new ModuleException("target needed", this, "execute");
		this.startTime = Sys.time();
		trace("parsing " + context.get("target"));
		
		var result:Dynamic = this.parseTarget(context.get("target"), context);
		if (!result)
			trace("failed");
		  
		var end:Float = Sys.time();
		trace("time " + (end - this.startTime) + " s");
		return result;
	}
	
	/**
	 * @param  target to be parsed
	 * @return Dynamic (parser's result)
	 */
	public function parseTarget(target:String, context:IMultiModuleContext):Dynamic
	{
		var fullPath:String = context.getRealPath(target);
		if (fullPath.lastIndexOf(".pdml") == -1)
			fullPath = fullPath + ".pdml";
			
		if (!FileSystem.exists(fullPath))
			throw new ModuleException("can not find " + target + " to parse", this, "parseTarget");
		
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

