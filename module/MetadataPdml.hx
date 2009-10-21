package haxe.org.dassista.module;

import haxe.xml.Fast;
import neko.io.File;

import haxe.org.multicore.IMultiModule;
import haxe.org.multicore.IMultiModuleContext;

class MetadataPdml implements IMultiModule
{
    public function new()
    {
        
    }

    public static function main():IMultiModule
    {
        return new MetadataPdml();
    }
    
    public function execute(context:IMultiModuleContext):Bool
    {
        var pdml:Fast = context.get("pdml"); 

        for(entry in pdml.elements)
        {
            context.put(entry.name, entry.innerData);
        }
        
        return true;
    }
}
