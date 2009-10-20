package haxe.org.dassista.multicore;

import haxe.org.dassista.multicore.IMultiModule;
import haxe.org.dassista.multicore.IMultiModuleContext;
import haxe.org.dassista.multicore.MultiModuleFactory;
import haxe.org.dassista.multicore.MultiModuleContextFactory;

class AbstractModule implements IMultiModule
{
    private var context:IMultiModuleContext;
    
    public function new()
    {	
    }

    public function getContext():IMultiModuleContext
    {
        return this.context;
    }

    public function execute(context:IMultiModuleContext):Bool
    {
        return false;
    }
}
