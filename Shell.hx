package haxe.org.dassista;

import neko.Sys;
import haxe.org.dassista.contexts.ShellContext;

class Shell
{
	public static function main()
	{
		var shellContext:ShellContext = new ShellContext();
		shellContext._rootFolder = Sys.getCwd();

		// push all variables in the context
		for (arg in Sys.args())
			shellContext.set(arg.split("=")[0], arg.split("=")[1]);
			
		// execute the context according incoming variables
		return shellContext.execute(shellContext);
	}
}