package haxe.org.dassista;

import haxe.org.dassista.ShellContext;
import neko.Web;
import neko.Sys;
import neko.FileSystem;

class RestServiceContext extends ShellContext
{
	public static function main():Dynamic 
	{
		trace("dassista restService context v0.1 @"+Web.getCwd());
		if (Sys.args().length != 0)
		{
			throw "not supported execution";
		}
		else
		{
			var shellInstance:RestServiceContext = new RestServiceContext(Web.getCwd().split("/").join("\\"), new Hash(), new Hash());
			shellInstance.handleRequest();
			Web.cacheModule(shellInstance.handleRequest);
			return true;
		}
	}
	
	private function handleRequest():Void
	{
		for (param in Web.getParams().keys())
		{
			this.set(param, Web.getParams().get(param));
		}
		if(Web.getParams().get("method") == null)
			this.executeTargetModule(Web.getParams().get("module"), this);
		else
			this.callTargetModuleMethod(Web.getParams().get("module"), Web.getParams().get("method"), this);
	}
	
	public function new(rootFolder:String,cache:Hash<Dynamic>,hash:Hash<Dynamic>)
	{
		super(rootFolder, cache, hash);
	}
	
	public override function clone():IMultiModuleContext
	{
		return new RestServiceContext(this._rootFolder, this._cache, new Hash());
	}
}