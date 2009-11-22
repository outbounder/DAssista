package org.dassista.app;

import neko.Web;

class RestService
{
	private static var restContext:RestServiceContext;
	
	public static function main()
	{
		restContext = new RestServiceContext();
		restContext.setRootFolder(Web.getCwd()); // releases.org.dassista.app.RestService		
		restContext.defineModulesSearchPath("haxe.org.dassista.src", "releases.org.dassista.modules");	
		
		handleRequests();
		Web.cacheModule(handleRequests);
	}
	
	private static function handleRequests():Void
	{
		restContext.setArgsHash(Web.getParams());
		try
		{
			restContext.callModuleMethod(restContext.getModuleName(),restContext.getMethodName(), restContext.clone());
		}
		catch(e:Dynamic)
		{
			restContext.output(e);
		}
	}
}