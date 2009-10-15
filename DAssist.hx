import haxe.Log;
import neko.Sys;
import neko.vm.Loader;
import neko.vm.Module;

class DAssist
{
	public static function main()
	{
		trace(Sys.args());
		var local:Loader = Loader.local();
		trace(local.getPath());
		var m:Module = Module.readPath("test.n", ["./"], local);
		trace(m.execute());
	}
}