package haxe.org.dassista.module;

import haxe.xml.Fast;
import haxe.org.multicore.neko.IMultiModule;
import haxe.org.multicore.neko.IMultiModuleContext;

class ActionPdml extends IMultiModule
{
    public static function main():IMultiModule
    {
        return new ActionPdml();
    }

    public override function execute(context:IMultiModuleContext):Bool
    {
        super.execute(context);
        
        var pdml:Fast = context.get("pdml");
        var module:Dynamic = null;
        
        if(pdml == null)
            throw "can not find pdml instanceof Fast input field";
              
        if(pdml.has.classname)
           module = context.createMultiModule(pdml.att.classname);
            
        for(action in pdml.elements)
        {
            context.put("pdml", action);
            
            if(action.has.classname)
            {
                trace("execute "+action.att.classname);
                var actionInstance:IMultiModule = context.createMultiModule(action.att.classname);
                if(!actionInstance.execute(context))
                    return false;
                    
                var f = Reflect.field(actionInstance, action.name);
                if(Reflect.isFunction(f))
                {
                    if(!Reflect.callMethod(actionInstance, f, [context]))
                        return false;
                }
                else
                {
                    trace('not a possible action '+action.name+" over module "+Type.typeof(module));
                    return false;
                }
            }
        }
    
        return true;
    }
}
