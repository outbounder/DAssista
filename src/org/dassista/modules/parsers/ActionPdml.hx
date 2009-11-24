package org.dassista.modules.parsers;

import haxe.rtti.Infos;
import haxe.xml.Fast;

import org.dassista.api.contexts.neko.MethodContext;
import org.dassista.api.contexts.neko.IContext;

/**
 * @author Boris Filipov
 * @version 0.1
 * @name haxe.org.dassista.tools.parsers.ActionPdml
 * @description parses pdml files provided by class path "target" entry. Can not parse directories. Parse means execute given class' method according provided args.
 * @uses haxe.org.dassista.tools.parsers.Placeholder to parse any placeholders arguments
 */
class ActionPdml implements Infos
{
    public function new()
    {
        
    }
    public static function main():Dynamic
    {
        return new ActionPdml();
    }
	
	/**
	 * @return Bool
	 * @pdml Fast instance of XML to be parsed
	 */
    public function execute(context:MethodContext):Bool
    {        
        if(!context.hasArg("pdml"))
            throw "can not find pdml instanceof Fast input field";
        var pdml:Fast = context.getArg("pdml");

		var module:Dynamic = null;
        if (pdml.has.classname)
        {

			module = context.getModule(pdml.att.classname);
		}
		else
		{
			module = this;
		}

        for(method in pdml.elements)
        {
			// prepare context
			var methodContext:MethodContext = new MethodContext(context);
			
			for (arg in method.elements)
			{
				if(arg.innerHTML.length != 0)
					methodContext.setArg(arg.name, this.parseArg(arg.innerHTML, context));
				else
					methodContext.setArg(arg.name, "");
			}
			
            if(method.has.classname)
                module = context.getModule(method.att.classname);
			if (module == null)
				throw "can not call action over null action instance for " + method.x.toString();

			// call 
			if (!this.synchMethodCaller(module, method.name, methodContext))
			{
				context.output("method not executed " + method.name + " at " + method.att.classname);
				return false;
			}
        }
    
        return true;
    }
	
	private function parseArg(arg:String, context:MethodContext):String
	{
		context.setArg("--target--", arg);
		if (!context.callModuleMethod("org.dassista.modules.parsers.Placeholder", "execute", context))
			throw "can not parse arg " + arg + " using org.dassista.modules.parsers.Placeholder";
		return context.getOutput();
	}
	
	private function synchMethodCaller(module:Dynamic, methodName:String, context:MethodContext):Dynamic
	{
		try
		{
			var f = Reflect.field(module, methodName);
			if(Reflect.isFunction(f))
				return  Reflect.callMethod(module, f, [context]);
			else
				throw 'not a possible action ' + methodName + " over module " + Type.getClass(module);
		}
		catch(e:Dynamic)
		{
			throw "failed on "+methodName+" "+e;
		}
	}
}
