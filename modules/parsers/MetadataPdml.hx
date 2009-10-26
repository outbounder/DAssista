package haxe.org.dassista.modules.parsers;

import haxe.xml.Fast;
import neko.io.File;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

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
		
		if(pdml == null)
            throw "can not find pdml instanceof Fast input field";

        for(entry in pdml.elements)
        {
            context.set(entry.name, entry.innerData);
        }
        
        return true;
    }
}
