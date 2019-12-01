 org  0
   incbin  "..\FinalFight3pBuild\ffight.bin"

 org 0x00057E
   move.w D1, $800166.l ;ctrl
 org 0x05E7D8 
   move.w #$12ce, $800166.l ;ctrl
 
 org 0x000554 
   move.w ($72,A5), $800168.l ;priority mask
 org 0x00055C 
   move.w ($74,A5), $80016a.l ;priority mask
 org 0x000564 
   move.w ($76,A5), $80016c.l ;priority mask
 org 0x00056C 
   move.w ($78,A5), $80016e.l ;priority mask

 org 0x00058C 
   move.w #$3f, $800170.l ;palctrl
 org 0x05EB7C 
   move.w #$3f, $800170.l ;palctrl
 
 org 0x05E850
   nop
	
 include "ffight_ae_main.asm"
 
 
 
 
 
 
 