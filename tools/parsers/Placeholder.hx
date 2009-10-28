package haxe.org.dassista.tools.parsers;

import haxe.xml.Fast;
import neko.io.File;

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
			
		for (key in context.keys()) // TODO ask for input , thus iterate within the target placeholders, not in the context's
		{
			if (target.indexOf("{" + key + "}") != -1) // if there is a placeholder found
			{
				var value:String = context.get(key);
				if (value == null) // key value not found, ask for such
				{
					File.stdout().writeString("please input value for " + key + ":");
					value = File.stdin().readUntil(13);
				}
				if (value == null)
					throw "could not find value for {"+key+"}";
				target = target.split("{" + key + "}").join(context.get(key));
			}
		}
		trace(target);
		context.set("result", target);
		return true;
    }
}
