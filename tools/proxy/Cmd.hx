package haxe.org.dassista.tools.proxy;

import haxe.io.Input;
import haxe.io.Output;
import haxe.org.dassista.IMultiModule;
import haxe.org.dassista.IMultiModuleContext;
import haxe.org.dassista.ModuleException;
import haxe.rtti.Infos;

import neko.Sys;
import neko.FileSystem;
import neko.io.Process;

class Cmd implements IMultiModule, implements Infos
{
	public function new() { }
	public static function main() { return new Cmd(); }
	
	/**
	 * 
	 * @root folder upon which current cwd will be set
	 * @cmd command and arguments to be executed as shell command
	 * @capture stderr | stdout string mode for capturing the output
	 * @return Int
	 */
	public function execute(context:IMultiModuleContext):Dynamic
	{
		if (context.get("root") == null || context.get("cmd") == null)
			throw new ModuleException("root and cmd are needed", this, "execute");
			
		var root:String = context.getRealPath(context.get("root"));
		var cmd:String = context.get("cmd");
		
	
		var oldCwd:String = Sys.getCwd();
		Sys.setCwd(root); 
		var oldPath:String = Sys.getEnv("PATH");
		var newPath:String  = oldPath + ";" + context.getRealPath("haxe.org.dassista.tools")+"\\"; // to be changed for unix support
		Sys.putEnv("PATH", newPath); // this shouldn't be here.
		
		// create the process (command line execution only)
		/* var prc:Process = new Process("cmd.exe", ['/c '+cmd]);
		
		// get & read the output
		
		var prcInput:Input = null;
		if (context.get("capture") == 'stdout')
			prcInput = prc.stdout;
		else
			prcInput = prc.stderr;
		
		try
		{
			while (true)
			{
				var str:String = prcInput.readLine();
				context.output(str);
			}
		}
		catch ( ex:haxe.io.Eof )  { } 

		var result:Int = prc.exitCode(); */
		
		var prc:haxe.org.neko.Prc = new haxe.org.neko.Prc();
		var prcOutput:String = prc.exec(cmd);
		context.output(prcOutput);
		
		Sys.setCwd(oldCwd);
		Sys.putEnv("PATH", oldPath);
		return prcOutput;
	}
}