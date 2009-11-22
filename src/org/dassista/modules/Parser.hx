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
	 */
	public function execute(context:MethodContext):Bool
	{
		if (!context.hasArg("target"))
			throw "target needed";
		this.startTime = Sys.time();
		context.output("parsing " + context.getArg("target"));
		
		var result:Bool = this.parseTarget(context);
		  
		var end:Float = Sys.time();
		context.output("time " + (end - this.startTime) + " s");
		return result;
	}
	
	/**
	 * @target to be parsed
	 * @return Dynamic (parser's result)
	 */
	public function parseTarget(context:MethodContext):Bool
	{
		var target:String = context.getArg("target");
		var fullPath:String = context.getRealPath(target);
		if (fullPath.lastIndexOf(".pdml") == -1)
			fullPath = fullPath + ".pdml";
			
		if (!FileSystem.exists(fullPath))
			throw "can not find " + target + " to parse";
		
		// retrieve the pdml data
		var pdmlContent:String = File.getContent(fullPath);
		var xml:Xml = Xml.parse(pdmlContent);
		var pdml:Fast = new Fast(xml.firstElement());
		
		context.setArg("pdml", pdml);
		try
		{
			return context.callModuleMethod(pdml.att.parser, "execute", context);
		}
		catch(e:Dynamic)
		{
			throw "could not parse "+target+" with parser:"+pdml.att.parser+" reason:"+e;
		}
	}
}

