package haxe.org.dassista.module;

import haxe.xml.Fast;
import haxe.org.dassista.multicore.IMultiModule;
import haxe.org.dassista.multicore.AbstractModule;
import haxe.org.dassista.multicore.IMultiModuleContext;

class ActionPdml extends AbstractModule
{
    public static function main():IMultiModule
    {
        return new ActionPdml();
    }

    public function new()
    {
        super();
    }

    public override function execute(context:IMultiModuleContext):Bool
    {
        this.context = context;    
        
        var pdml:Fast = context.hashView("pdml");
        var module:Dynamic = null;
        
        if(pdml == null)
            throw "can not find pdml instanceof Fast input field";  
        if(pdml.has.classname)
           module = context.getModuleFactory().createMultiModule(pdml.att.classname);
            
        for(action in pdml.elements)
        {
            var actionContext:IMultiModuleContext = context.getModuleContextFactory().clone(this.context);
            actionContext.hashView("pdml", action);
            
            if(action.has.classname)
            {
                trace("execute "+action.att.classname);
                var actionInstance:IMultiModule = context.getModuleFactory().createMultiModule(action.att.classname);
                if(!actionInstance.execute(actionContext))
                    return false;
            }
            
            if(module != null)
            {
                var f = Reflect.field(module, action.name);
                if(Reflect.isFunction(f))
                {
                    if(!Reflect.callMethod(module, f, [actionContext]))
                        return false;
                }
                else
                {
                    trace('not a possible action '+action.name+" over module "+Type.typeof(module));
                    return false;
                }
            }
        }
    
        trace(context.hashView("result"));
    
        return true;
    }
}
