package haxe.org.dassista.tools.parsers;

import haxe.xml.Fast;
import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

class ActionPdml implements IMultiModule
{
    public function new()
    {
        
    }
    public static function main():Dynamic
    {
        return new ActionPdml();
    }

    public function execute(context:IMultiModuleContext):Dynamic
    {        
        var pdml:Fast = context.get("pdml");
        
        if(pdml == null)
            throw "can not find pdml instanceof Fast input field";
        
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
			// finally set the pdml to be passed out 
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
				
			// gather all results presented in the context in as results
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
			throw "can not parse arg " + arg + " using haxe.org.dassista.tools.parsers.Placeholder";
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
			throw 'not a possible action ' + actionName + " over module " + Type.getClass(actionInstance);
			return false;
		}
	}
}
