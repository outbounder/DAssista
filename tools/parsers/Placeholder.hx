package haxe.org.dassista.tools.parsers;

import haxe.xml.Fast;
import neko.io.File;
import neko.Lib;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

class Placeholder implements IMultiModule
{
    public function new()
    {
        
    }

    public static function main():Dynamic
    {
        return new Placeholder();
    }
    
    public function execute(context:IMultiModuleContext):Dynamic
    {
        var target:String = context.get("--target--");
		if (target == null)
			throw "--target-- field is required";
		
		switch(context.get("--algo--"))
		{
			case null:
			{
				var r:EReg = new EReg("{[^{}]+}", "");
				while (r.match(target))
				{
					var value:String = r.matched(0);
					var newvalue:String = context.get(value.substr(1, value.length-2));
					if (newvalue == null)
					{
						if (neko.Web.isModNeko)
							throw "can not find value for " + value+" in web mode";
						Lib.println("need a value for " + value);
						newvalue = File.stdin().readLine();
						context.set(value.substr(1, value.length-2), newvalue);
					}
					target = target.split(value).join(newvalue);
				}
			};
			case "leave":
			{
				for (key in context.keys()) 
				{
					if (target.indexOf("{" + key + "}") != -1) // if there is a placeholder found
						target = target.split("{" + key + "}").join(context.get(key));
				}
			};
		}
		
		context.set("result", target);
		return true;
    }
}
