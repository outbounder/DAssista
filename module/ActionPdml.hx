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
        var pdml:Fast = context.get("pdml");
        var module:Dynamic = null;
        
        if(pdml == null)
            throw "can not find pdml instanceof Fast input field";
              
        if(pdml.has.classname)
           module = context.createNekoModule(pdml.att.classname);
            
        for(action in pdml.elements)
        {
            context.put("pdml", action);
            
            if(action.has.classname)
            {
                var actionInstance:IMultiModule = context.createNekoModule(action.att.classname);
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
