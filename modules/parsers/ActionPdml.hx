package haxe.org.dassista.modules.parsers;

import haxe.xml.Fast;
import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

class ActionPdml implements IMultiModule
{
    public function new()
    {
        
    }
    public static function main():IMultiModule
    {
        return new ActionPdml();
    }

    public function execute(context:IMultiModuleContext):Bool
    {        
        var pdml:Fast = context.get("pdml");
        
        if(pdml == null)
            throw "can not find pdml instanceof Fast input field";
        
		var module:Dynamic = null;
        if (pdml.has.classname)
			module = context.createTargetModule(pdml.att.classname);
		else
			module = context.getCaller();
            
        for(action in pdml.elements)
        {
			var actionContext:IMultiModuleContext = context.clone();
            actionContext.set("pdml", action);
			for (actionArg in action.elements)
				actionContext.set(actionArg.name, actionArg.innerData);
            
			var actionInstance:IMultiModule = null;
            if(action.has.classname)
                actionInstance = context.createTargetModule(action.att.classname);
			else
				actionInstance = module;
			
			var f = Reflect.field(actionInstance, action.name);
			if(Reflect.isFunction(f))
			{
				if(!Reflect.callMethod(actionInstance, f, [actionContext]))
					return false;
			}
			else
			{
				trace('not a possible action '+action.name+" over module "+Type.getClass(actionInstance));
				return false;
			}
        }
    
        return true;
    }
}
