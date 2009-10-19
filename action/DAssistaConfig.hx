package haxe.org.dassista.action;

import haxe.org.dassista.pdml.impl.action.ScriptedModule;
import haxe.org.dassista.action.Git;
import haxe.xml.Fast;

class DAssistaConfig extends ScriptedModule
{
	public static function main():Dynamic
	{
		return new DAssistaConfig();
	}
	
	public function config(xml:Fast):Void
	{
		neko.Lib.println("checking git existing...");
		if(!Git.ready())
		{
		  neko.Lib.println("git does not exists as environment variable path. Try additing it ;)");
		  return;
		}

    var git:Git = new Git(this.getContext().getRepo().getBasePath());
    git.fetchClone(xml.node.publicClone.toString());
	}
	
}
