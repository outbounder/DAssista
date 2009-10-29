package haxe.org.dassista.tools.parsers;

import haxe.rtti.Infos;
import haxe.xml.Fast;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;

/**
 * @author Boris Filipov
 * @version 0.1
 * @name haxe.org.dassista.tools.parsers.ActionPdml
 * @description parses pdml files provided by class path "target" entry. Can not parse directories. Parse means execute given class' method according provided args.
 * @uses haxe.org.dassista.tools.parsers.Placeholder to parse any placeholders arguments
 */
class ActionPdml implements IMultiModule, implements Infos
{
    public function new()
    {
        
    }
    public static function main():Dynamic
    {
        return new ActionPdml();
    }
	
	/**
	 * 
	 * @param	context
	 * @return Bool
	 * @_pdml Fast instance of XML to be parsed
	 */
    public function execute(context:IMultiModuleContext):Dynamic
    {        
        var pdml:Fast = context.get("pdml");
        
        if(pdml == null)
            throw new ModuleException("can not find pdml instanceof Fast input field", this, "execute");
        
		var module:Dynamic = null;
        if (pdml.has.classname)
			module = context.createTargetModule(pdml.att.classname);
		else
			module = this;
            
        for(action in pdml.elements)
        {
			// prepare context
			var actionContext:IMultiModuleContext = context.clone();
			// assign all results gathered so far, this will also put the pdml later overriden 
			for (key in context.keys()) 
				actionContext.set(key, context.get(key)); 
			// assign all action's inner elements
			for (actionArg in action.elements)
				actionContext.set(actionArg.name, this.parseArg(actionArg.innerData, actionContext));
			// finally set the pdml to be passed in 
			actionContext.set("pdml", action);
            
			// prepare instance
			var actionInstance:IMultiModule = module;
            if(action.has.classname)
                actionInstance = context.createTargetModule(action.att.classname);
			if (actionInstance == null)
				throw "can not call action over null action instance for " + action.x.toString();
				
			// call 
			if (!this.synchMethodCaller(actionInstance, action.name, actionContext))
				return false;
				
			// gather all results presented in the context as out
			for (key in actionContext.keys())
				context.set(key, actionContext.get(key));
        }
    
        return true;
    }
	
	private function parseArg(arg:String, context:IMultiModuleContext):String
	{
		// prepare context for the placeholder
		var placeholderContext:IMultiModuleContext = context.clone();
		for (key in context.keys()) 
				placeholderContext.set(key, context.get(key));
		placeholderContext.set("--target--", arg);
		
		if (!context.executeTargetModule("haxe.org.dassista.tools.parsers.Placeholder", placeholderContext))
			throw new ModuleException("can not parse arg " + arg + " using haxe.org.dassista.tools.parsers.Placeholder", this, "execute");
		return placeholderContext.get("result");
	}
	
	private function synchMethodCaller(actionInstance:IMultiModule, actionName:String, actionContext:IMultiModuleContext):Dynamic
	{
		var f = Reflect.field(actionInstance, actionName);
		if(Reflect.isFunction(f))
		{
			return  Reflect.callMethod(actionInstance, f, [actionContext]);
		}
		else
		{
			throw new ModuleException('not a possible action ' + actionName + " over module " + Type.getClass(actionInstance), this, "execute");
			return false;
		}
	}
}
