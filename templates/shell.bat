@echo off
cd .\haxe\org\dassista\
haxe -cp ..\..\..\ -main haxe.org.dassista.ShellContext -neko ShellContext.n
cd ..\..\..\
neko .\haxe\org\dassista\ShellContext.n module=%*
