@echo off
cd .\haxe\org\dassista\
haxe -cp ..\..\..\ -main haxe.org.dassista.DAssista -neko DAssista.n
nekotools boot DAssista.n
DAssista.exe .\..\..\..\ config.pdml 
cd ..\..\..\