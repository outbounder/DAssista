package org.dassista.app;

class RestServiceContext extends ShellContext
{
	private override function handleOutput(value:Dynamic):Void
	{
		neko.Lib.println("<output>" + value + "</output>");
	}
}