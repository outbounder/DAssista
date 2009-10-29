package haxe.org.dassista.contexts.renderers;

import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;
import haxe.rtti.Infos;
import neko.io.File;

/**
 * @description renders all values passed to execute to the web
 */
class RestRenderer implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new RestRenderer(); }
	
	/**
	 * @param context
	 * @value value to be rendered. If it is ModuleException, then context.describe will be used.
	 * @throws ModuleException
	 * @return Bool
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		if (!context.has("value"))
			throw new ModuleException("value is needed", this, "execute");
		var value:Dynamic = context.get("value");
		if (Type.getClassName(Type.getClass(value)) == "haxe.org.dassista.ModuleException")
		{
			neko.Lib.println("<EXCEPTION>");
			neko.Lib.println(value.getMessage());
			neko.Lib.println("</EXCEPTION>");
			neko.Lib.println("<MODULE>");
			neko.Lib.println(context.describe(value.getModule()).toString());
			neko.Lib.println("</MODULE>");
			neko.Lib.println("<METHOD name='"+value.getMethod()+"'>");
			neko.Lib.println(context.describe(value.getModule(), value.getMethod()).toString());
			neko.Lib.println("</METHOD>");
		}
		else
			neko.Lib.println("<output>"+value.toString()+"</output>");
		return true;
	}
}