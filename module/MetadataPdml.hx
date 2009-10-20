package haxe.org.dassista.module;

import haxe.xml.Fast;
import neko.io.File;

import haxe.org.multicore.neko.AbstractMultiModule;
import haxe.org.multicore.neko.IMultiModule;
import haxe.org.multicore.neko.IMultiModuleContext;

class MetadataPdml extends AbstractMultiModule
{
    public static function main():Dynamic
    {
        return new MetadataPdml();
    }
    
    public function new()
    {	
        super();
    }
    
    public override function execute(context:IMultiModuleContext):Bool
    {
        super.execute(context);
        
        var pdml:Fast = context.get("pdml"); 

        for(entry in pdml.elements)
        {
            context.put(entry.name, entry.innerData);
            trace(context.get(entry.name));
        }
        
        return true;
    }
}
