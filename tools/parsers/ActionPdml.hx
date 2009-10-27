package haxe.org.dassista.tools.parsers;

import haxe.xml.Fast;
import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

class ActionPdml implements IMultiModule
{
	private var actionInstance:IMultiModule;
	private var actionContext:IMultiModuleContext;
	private var action:Fast;
	
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
			this.action = action;
			this.actionContext = context.clone();
            this.actionContext.set("pdml", action);
			for (actionArg in action.elements)
				this.actionContext.set(actionArg.name, actionArg.innerData);
            
			this.actionInstance = module;
			
            if(action.has.classname)
                this.actionInstance = context.createTargetModule(action.att.classname);
			if (actionInstance == null)
				throw "can not call action over null action instance for " + action.x.toString();
				
			if (!this.asyncMethodCaller())
				return false;
        }
    
        return true;
    }
	
	private function asyncMethodCaller():Dynamic
	{
		var f = Reflect.field(this.actionInstance, this.action.name);
		if(Reflect.isFunction(f))
		{
			return Reflect.callMethod(actionInstance, f, [this.actionContext]);
		}
		else
		{
			throw 'not a possible action ' + this.action.name + " over module " + Type.getClass(this.actionInstance);
			return false;
		}
	}
}
