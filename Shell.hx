package haxe.org.dassista;

import neko.Sys;
import haxe.org.dassista.contexts.ShellContext;

class Shell
{
	public static function main()
	{
		var shellContext:ShellContext = new ShellContext();
		
		// push all variables in the context
		for (arg in Sys.args())
			shellContext.set(arg.split("=")[0], arg.split("=")[1]);
			
		// push the rootFolder 
		shellContext.set("rootFolder", Sys.getCwd());
			
		// execute the context according incoming variables
		return shellContext.execute(shellContext);
	}
}