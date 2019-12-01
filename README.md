# FinalFightAE-Source
Final Fight Anniversary Edition Source

## Intro:

Final Fight 30th Anniversary Edition is a modification to Final Fight World, ffight.zip in mame, that enhances the game in the following ways:

 * Three Players
 * Selectable Palettes
 * Unlocked Character Selection
 * More Health for Enemies/Bosses with three players
 * Uncensored Intro / No Region Warning
 
Every system in the game has been reworked to support three players and enhancements that would improve this experience have been implemented.

It is compatible with real CPS1 hardware through use of a B-21 C-Board for player three input.

## Legal:

This project is a collaboration between authors Grego and Rotwang.

It is distributed under GNU General Public License v3: https://www.gnu.org/licenses/gpl-3.0.html

Please do not distribute this work without providing all source code and attribution as required.

## Compiling from source:

All required tools for compiling under windows is provided within the repository, the build scripts may work under wine on linux/mac.

You need a directory one directory up from FinalFightAE-Source called FinalFight3pBuild, if you were on windows it would look as so:

C:\Users\You\FinalFightAE-Source
C:\Users\You\FinalFight3pBuild

You need to create an out directory in FinalFight3pBuild

C:\Users\You\FinalFight3pBuild\out

Extract ffight.zip (Final Fight World) from the mame rom set into the out directory

Copy the Rommangler.jar, combine.bat, combine_gfx.bat, final_fight_gfx_split.cfg, and final_fight_split.cfg from your FinalFightAE-Source to your out directory.

Run both combine.bat and combine_gfx.bat.

Move the generated ffight.bin and ffight_gfx.bin into your FinalFight3pBuild directory.

Delete Rommangler.jar, combine.bat, combine_gfx.bat, final_fight_gfx_split.cfg, and final_fight_split.cfg from your out directory

Edit the "SET ROM_DIR" command in apply_patch.bat to point to your mame\roms directory.

You are now ready to build Final Fight AE.  Run apply_patch.bat, a new file ffight3p.zip should have been created in your ROM_DIR.

You will need a modified copy of mame, which you can find here to run FFAE:

https://www.dropbox.com/s/6oytpu2d63gxvgg/ffae-mame.zip?dl=0

It's source can be found here:

https://github.com/originalgrego/mame