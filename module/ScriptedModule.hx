package haxe.org.dassista.module;

import haxe.xml.Fast;
import neko.io.File;
import haxe.org.dassista.multicore.IMultiModule;
import haxe.org.dassista.multicore.IMultiModuleContext;
import haxe.org.dassista.multicore.MultiModuleFactory;
import haxe.org.dassista.multicore.MultiModuleContextFactory;

class ScriptedModule implements IMultiModule
{
    private var contextFactory:MultiModuleContextFactory;
    
	public function new()
	{
        this.contextFactory = new MultiModuleContextFactory(this);	
	}
	
	public function execute(context:IMultiModuleContext):Dynamic
	{
	    var pdml:Fast = context.hashView("pdml");    
	    var moduleFactory:MultiModuleFactory = new MultiModuleFactory(context.hashView("root"));
        var module:Dynamic = moduleFactory.createMultiModule(pdml.att.classname);
        var actions:Iterator<Xml> = pdml.x.elements();
        for(action in actions)
        {
          var methodName:String = action.nodeName.toString();
          var f = Reflect.field(module, methodName);
          if(Reflect.isFunction(f))
          {
            var output:Dynamic = Reflect.callMethod(module, f, [context,new Fast(action)]);
            context.getVectorView().push(output);
          }
          else
          {
            trace('not a possible action '+methodName);
            return false;
          }
        }
        return true;
	}
}