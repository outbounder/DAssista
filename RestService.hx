package haxe.org.dassista;

import neko.Web;
import haxe.org.dassista.contexts.RestServiceContext;

class RestService
{
	private static var restContext:RestServiceContext;
	
	public static function main()
	{
		restContext = new RestServiceContext();
		
		// push the rootFolder 
		restContext.set("rootFolder", Web.getCwd().split("/").join("\\"));
			
		handleRequests();
		// execute the context according incoming variables
		Web.cacheModule(handleRequests);
	}
	
	private static function handleRequests():Void
	{
		// push all variables in the context
		for (arg in Web.getParams().keys())
			restContext.set(arg, Web.getParams().get(arg));
		restContext.execute(restContext);
	}
}