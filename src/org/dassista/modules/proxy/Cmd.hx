package org.dassista.modules.proxy;

import haxe.io.Input;
import haxe.io.Output;
import haxe.rtti.Infos;
import neko.Sys;
import neko.FileSystem;
import neko.io.Process;

import org.dassista.api.contexts.neko.MethodContext;
import org.neko.Prc;

class Cmd implements Infos
{
	public function new() { }
	public static function main() { return new Cmd(); }
	
	/**
	 * 
	 * @root folder upon which current cwd will be set
	 * @cmd command and arguments to be executed as shell command
	 * @capture stderr | stdout string mode for capturing the output
	 * @return Int
	 */
	public function execute(context:MethodContext):Dynamic
	{
		if (!context.hasArg("root")|| !context.hasArg("cmd"))
			throw "root and cmd are needed";
			
		var root:String = context.getRealPath(context.getArg("root"));
		var cmd:String = context.getArg("cmd");
		
	
		var oldCwd:String = Sys.getCwd();
		Sys.setCwd(root); 
		var oldPath:String = Sys.getEnv("PATH");
		var newPath:String  = oldPath + ";" + context.getRealPath("releases.org.dassita.tools")+"\\"; // to be changed for unix support
		Sys.putEnv("PATH", newPath); // this shouldn't be here.
				
		var prc:Prc = new Prc();
		var prcOutput:String = prc.exec(cmd);
		context.output(prcOutput);
		context.setOutput(prcOutput);
		Sys.setCwd(oldCwd);
		Sys.putEnv("PATH", oldPath);
		return prcOutput;
	}
}