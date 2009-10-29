package haxe.org.dassista.tools.parsers;

import haxe.rtti.Infos;
import haxe.xml.Fast;
import neko.io.File;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;

/**
 * @description parser for pdml files where it finds all elements(nodes) and puts them in the context as key/value pairs if possible
 */
class MetadataPdml implements IMultiModule, implements Infos
{
    public function new()
    {
        
    }

    public static function main():Dynamic
    {
        return new MetadataPdml();
    }
    
	/**
	 * @pdml Fast presentation of the pdml file which have to be parsed
	 * @return Bool
	 * @throws ModuleException
	 */
    public function execute(context:IMultiModuleContext):Dynamic
    {
		if(!context.has("pdml"))
            new ModuleException("can not find pdml instanceof Fast input field", this, "execute");
			
		var pdml:Fast = context.get("pdml"); 
        for(entry in pdml.elements)
        {
            context.set(entry.name, entry.innerData);
        }
        
        return true;
    }
}
