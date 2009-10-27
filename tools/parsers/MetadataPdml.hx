package haxe.org.dassista.tools.parsers;

import haxe.xml.Fast;
import neko.io.File;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;

class MetadataPdml implements IMultiModule
{
    public function new()
    {
        
    }

    public static function main():Dynamic
    {
        return new MetadataPdml();
    }
    
    public function execute(context:IMultiModuleContext):Dynamic
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
