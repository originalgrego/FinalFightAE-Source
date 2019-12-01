 ; Scroll
 org 0x061F4C  
   bra $61fb0 ; Branch if both 1P and 2P active 

 org 0x061fb0
   jmp hijack_playerscroll_0
   
 org 0x062072
   bra $62120 ; Branch if both 1P and 2P active 
 
 org 0x062120
   jmp hijack_playerscroll_2
 ; Scroll 