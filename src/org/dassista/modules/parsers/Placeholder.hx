package org.dassista.modules.parsers;

import haxe.rtti.Infos;
import haxe.xml.Fast;
import neko.io.File;
import neko.Lib;

import org.dassista.api.contexts.neko.MethodContext;

/**
 * @description parser class for replacing any {key} placeholders with its actual value found within the context
 */
class Placeholder implements Infos
{
    public function new()
    {
        
    }

    public static function main():Dynamic
    {
        return new Placeholder();
    }
    
	/**
	 * @--target-- used to specify the string which will be searched for placeholders
	 * @--mode-- null|leave, in leave mode if the placeholder's value is not found in the context, it is not changed
	 * @throws ModuleException if placeholder's value is not found & mode is null & isModNeko
	 * @return String
	 * @result String is set back to the context with replaced --target-- placeholders
	 */
    public function execute(context:MethodContext):Dynamic
    {
        var target:String = context.getArg("--target--");
		if (target == null)
			throw "--target-- field is required";
			
		var r:EReg = new EReg("{[^{}]+}", "");
		while (r.match(target))
		{
			var value:String = r.matched(0);
			var newvalue:String = this.getMetadata(value.substr(1, value.length-2),context); 
			if (newvalue == null)
			{
				if (neko.Web.isModNeko)
					throw "can not find value for " + value+" in web mode";
				Lib.println("need a value for " + value);
				newvalue = File.stdin().readLine();
			}
			target = target.split(value).join(newvalue);
		}
		context.setOutput(target);
		return true;
    }
	
	private function getMetadata(name:String, context:MethodContext):Dynamic
	{
		// metadata is usually stored within MetadataPdml module
		var mContext:MethodContext = new MethodContext(context);
		mContext.setArg("name", name);
		return mContext.callModuleMethod("org.dassista.modules.parsers.MetadataPdml", "get", mContext);
	}
}
