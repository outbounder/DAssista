package haxe.org.dassista;

import neko.Web;
import haxe.org.dassista.contexts.RestServiceContext;
import haxe.org.dassista.IMultiModuleContext;

class RestService
{
	private static var restContext:RestServiceContext;
	
	public static function main()
	{
		restContext = new RestServiceContext();
		restContext._rootFolder = Web.getCwd().split("/").join("\\");
		
		// execute the context according incoming variables
		handleRequests();
		Web.cacheModule(handleRequests);
	}
	
	private static function handleRequests():Void
	{
		var requestContext:IMultiModuleContext = restContext.clone();
		
		// push all variables in the context
		for (arg in Web.getParams().keys())
			requestContext.set(arg, Web.getParams().get(arg));
			
		restContext.execute(requestContext);
	}
}