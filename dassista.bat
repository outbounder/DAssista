@echo off
haxe -cp D:/pd-repo/ -main haxe.org.dassista.DAssista -neko DAssista.n 
nekotools boot DAssista.n
DAssista.exe %*
