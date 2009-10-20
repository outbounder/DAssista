package haxe.org.dassista;

import haxe.org.dassista.multicore.AbstractModule;
import haxe.org.dassista.multicore.IMultiModuleContext;

class Config extends AbstractModule
{
    public static function main():Dynamic
    {
        return new Config();
    }

    public function inputGlobals(context:IMultiModuleContext):Bool
    {
        trace(context.hashView("result"));
        return true;
    }
}
