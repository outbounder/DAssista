@echo off
haxe -main DAssist -neko DAssist.n 
nekotools boot DAssist.n
DAssist.exe %*
