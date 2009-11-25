package org.dassista.app;

import neko.Web;
import org.dassista.api.contexts.neko.MethodContext;

class RestService
{
	private static var restContext:RestServiceContext;
	
	public static function main()
	{
		restContext = new RestServiceContext();
		restContext.setRootFolder(Web.getCwd().split("/").join("\\"));
		restContext.defineModulesSearchPath("haxe.org.dassista.src", "_app.org.dassista.modules");
		
		handleRequests();
		Web.cacheModule(handleRequests);
	}
	
	private static function handleRequests():Void
	{
		restContext.setArgsHash(Web.getParams());
		try
		{
			restContext.callModuleMethod(restContext.getModuleName(),restContext.getMethodName(), new MethodContext(restContext));
		}
		catch(e:Dynamic)
		{
			restContext.output(e);
		}
	}
}