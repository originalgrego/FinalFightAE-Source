;================================================
hijack_player_two_input:
   move.b  ($6aa,A5), ($6ab,A5)
   move.b  ($5e,A5), D0
   move.b  D0, ($6aa,A5)
   lea     ($f4,A5), A3
   jsr     $002BB4

   bsr p3_calc_input
   
   lea     ($f4,A5), A3
   jsr     $002BB4

   jmp $002BA6   
;================================================

;================================================
p3_calc_input:
   move.w  $800176.l, D0
   not.w   D0

   move.b  D0, ($686A,A5)
   
   move.b  ($676A,A5), ($676b,A5)
   move.b  ($686A,A5), D0
   move.b  D0, ($676A,A5)
   
   lsl.w   (p3_start_button_fifo,A5)
   
   btst #$7, ($676a,A5)
   beq p3_calc_input_end
   bset #$0, (p3_start_button_fifo,A5)
   
   
p3_calc_input_end:
   bclr #$7, ($676a,A5)
   bclr #$7, ($676b,A5)
 
   rts
;================================================

;================================================
p3_check_press_start:
  moveq #$0, D0
  
  move.b  (p3_start_button_fifo,A5), D0
  cmp.b   #$1, D0
  bne     p3_check_press_start_fail

  moveq #$1, D0
  rts
  
p3_check_press_start_fail:
  moveq #$0, D0
  rts
;================================================
