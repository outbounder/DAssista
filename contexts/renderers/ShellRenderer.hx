package haxe.org.dassista.contexts.renderers;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;
import haxe.rtti.Infos;
import neko.io.File;

class ShellRenderer implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new ShellRenderer(); }
	
	/**
	 * @param context
	 * @value value to be rendered. If it is ModuleException, then context.describe will be used.
	 * @return Bool
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("value"))
			throw new ModuleException("value is needed", this, "execute");
		var value:Dynamic = context.get("value");
		if (Type.getClassName(Type.getClass(value)) == "haxe.org.dassista.ModuleException")
		{
			File.stdout().writeString("EXCEPTION:\n");
			File.stdout().writeString(value.getMessage() + "\n");
			File.stdout().writeString("MODULE:\n");
			File.stdout().writeString(context.describe(value.getModule()).toString() + "\n");
			File.stdout().writeString("METHOD:\n");
			File.stdout().writeString(context.describe(value.getModule(), value.getMethod()).toString()+"\n");
		}
		else
			File.stdout().writeString(value+"\n");
		return true;
	}
}