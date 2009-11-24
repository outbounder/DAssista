package org.dassista.app;

import neko.Sys;
import org.dassista.api.contexts.neko.MethodContext;

class Shell
{
	public static function main():Bool
	{
	    // all is only a single context 
		var shellContext:ShellContext = new ShellContext();
		shellContext.setArgsArray(Sys.args());
		shellContext.setRootFolder(Sys.getCwd().split("/").join("\\")); // releases.org.dassista.app.Shell
		shellContext.defineModulesSearchPath("haxe.org.dassista.src", "_app.org.dassista.modules");
		try
		{
			shellContext.callModuleMethod(shellContext.getModuleName(),shellContext.getMethodName(), new MethodContext(shellContext));
			return true;
		}
		catch(e:Dynamic)
		{
			shellContext.output(e);
			return false;
		}
	}
}