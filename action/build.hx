package haxe.org.dassista.action;

class Build implements haxe.org.dassista.pdml.IApdmlModule
{
	public function new()
	{
		
	}
	
	public function execute(context:Dynamic):Dynamic
	{
		return context+" - tested";
	}
	
	public static function main():Dynamic
	{
		return new Build();
	}
}