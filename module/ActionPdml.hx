package haxe.org.dassista.module;

import haxe.xml.Fast;
import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;

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
        var pdml:Fast = context.getPdml();
        
        if(pdml == null)
            throw "can not find pdml instanceof Fast input field";
        
		var module:Dynamic = null;
        if (pdml.has.classname)
			module = context.createMultiModule(pdml.att.classname);
		else
			module = context.getCaller();
            
        for(action in pdml.elements)
        {
            context.setPdml(action);
            
			var actionInstance:IMultiModule = null;
            if(action.has.classname)
                actionInstance = context.createMultiModule(action.att.classname);
			else
				actionInstance = module;
			
			var f = Reflect.field(actionInstance, action.name);
			if(Reflect.isFunction(f))
			{
				if(!Reflect.callMethod(actionInstance, f, [context]))
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
