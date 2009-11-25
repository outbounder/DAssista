package org.dassista.modules.parsers;

import haxe.rtti.Infos;
import haxe.xml.Fast;
import neko.io.File;

import org.dassista.api.contexts.neko.MethodContext;


/**
 * @description parser for pdml files where it finds all elements(nodes) and puts them in the context as key/value pairs if possible
 */
class MetadataPdml implements Infos
{
	private var metadata:Hash<Dynamic>;
	
    public function new()
    {
		this.metadata = new Hash();
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
    public function execute(context:MethodContext):Bool
    {
		if(!context.hasArg("pdml"))
            throw "can not find pdml instanceof Fast input field";
			
		var pdml:Fast = context.getArg("pdml"); 
        for(entry in pdml.elements)
        {
            this.metadata.set(entry.name, entry.innerData);
        }
        
        return true;
    }
	
	/**
	 * @name key name within metadata hash
	 * @return
	 */
	public function get(context:MethodContext):Dynamic
	{
		if(context.hasArg("name"))
			return this.metadata.get(context.getArg("name"));
		else
			return null;
	}
}
