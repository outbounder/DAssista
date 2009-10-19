package org.dassista.pdml.impl.action;

import haxe.org.dassista.pdml.IApdmlModule;
import haxe.org.dassista.pdml.IApdmlModuleContext;
import haxe.org.dassista.pdml.ApdmlModuleFactory;

class ScriptedModule implements IApdmlModule
{
	private var context:IApdmlModuleContext;
	
	public function new()
	{
		
	}
	
	public function execute(context:IApdmlModuleContext):Dynamic
	{
		this.context = context;
		
		var actions:Iterator<Xml> = context.getPdml().x.elements();
		for(action in actions)
		{
			var methodName:String = action.nodeName.toString();
			if(methodName != "pdml")
			{
				var f = Reflect.field(this, methodName);
				if(Reflect.isFunction(f))
				{
					Reflect.callMethod(this, f, []);
				}
				else
				{
					trace('not a possible action '+actionName.toString());
					return false;
				}
			}
			else
			{
				var pdmlProcessor:APDMLProcessor = new APDMLProcessor(action.toString(), this.getContext().getRepo());
				return pdmlProcessor.execute(ApdmlModuleFactory.createCurrentContext(this));
			}
		}
		return true;
	}
	
	public function getContext():IApdmlModuleContext
	{
		return this.context;
	}
}