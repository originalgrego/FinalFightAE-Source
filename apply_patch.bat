SET ROM_DIR=C:\Users\grego\Desktop\MAME\roms

Asm68k.exe /p  ffight_ae.asm, ..\FinalFight3pBuild\ffight_hack.bin

del ..\FinalFight3pBuild\ffight_gfx_hack.bin
copy ..\FinalFight3pBuild\ffight_gfx.bin ..\FinalFight3pBuild\ffight_gfx_hack.bin

liteips.exe ffight_gfx_new.ips ..\FinalFight3pBuild\ffight_gfx_hack.bin

java -jar RomMangler.jar split final_fight_gfx_out_split.cfg ..\FinalFight3pBuild\ffight_gfx_hack.bin
java -jar RomMangler.jar split final_fight_out_split.cfg ..\FinalFight3pBuild\ffight_hack.bin

java -jar RomMangler.jar zipdir ..\FinalFight3pBuild\out %ROM_DIR%\ffightae.zip