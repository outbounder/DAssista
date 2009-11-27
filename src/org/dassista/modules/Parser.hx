package org.dassista.modules;

import org.dassista.api.contexts.neko.MethodContext;

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
class Parser implements Infos
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
	 * @return Bool
	 * @target class|file path to entry without the .pdml extension
	 * @xml xml content to be parsed 
	 */
	public function execute(context:MethodContext):Bool
	{
		if (!context.hasArg("target") && !context.hasArg("xml"))
			throw "target or xml are needed";
		
		var pdml:Fast = null;
		var parserContext:MethodContext = new MethodContext(context);
		var pdmlOrigin:String = "unknown";
		
		if (context.hasArg("target"))
		{
			var target:String = context.getArg("target");
			var fullPath:String = context.getRealPath(target);
			if (fullPath.lastIndexOf(".pdml") == -1)
				fullPath = fullPath + ".pdml";
				
			if (!FileSystem.exists(fullPath))
				throw "can not find " + target + " to parse";
				
			pdmlOrigin = fullPath;
			
			// retrieve the pdml data
			var pdmlContent:String = File.getContent(fullPath);
			var xml:Xml = Xml.parse(pdmlContent);
			pdml = new Fast(xml.firstElement());
			parserContext.setArg("pdml", pdml);
		}
		else
		if(context.hasArg("xml"))
		{
			var xml:Xml = Xml.parse(context.getArg("xml"));
			pdml = new Fast(xml.firstElement());
			pdmlOrigin = "dynamic xml";
			parserContext.setArg("pdml", pdml);
		}
		
		try
		{
			return context.callModuleMethod(pdml.att.parser, "execute", parserContext);
		}
		catch(e:Dynamic)
		{
			throw "could not parse "+pdmlOrigin+" with parser:"+pdml.att.parser+" reason:"+e;
		}
	}
}

