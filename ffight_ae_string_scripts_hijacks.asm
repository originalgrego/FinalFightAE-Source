;=======================================
draw_string_calc_string_address:
   and.l #$000000ff, D0
   add.w   D0, D0

   lea new_string_indexes.l, A1
   move.l  (A1,D0.w), A1
   
   rts
;=======================================

;=======================================
hijack_draw_string_script:
   bsr draw_string_calc_string_address
   
   jmp $0014C2
;=======================================
   
;=======================================
hijack_hide_string_script:
   bsr draw_string_calc_string_address
   
   jmp $0017DC
;=======================================
   
;=======================================
draw_string_p23_handler:
   btst.b   #$0, ($0,A6)
   bne draw_string_p23_handler_exit

   add.b    #$39, D0   
   
draw_string_p23_handler_exit:
   jmp $14ae.w 
;=======================================

;=======================================
hijack_show_p2_additional_credits_message:
  btst.b   #$0, ($0,A6)
  bne hijack_show_p2_additional_credits_message_p2
 
  move.w  #$3d, D0 ; Show additional credit message p3
  jmp     $9e6c.l
 
hijack_show_p2_additional_credits_message_p2:
  move.w  #$27, D0 ; Show additional credit message p2
  jmp     $9e6c.l
;=======================================

;=======================================
hijack_hide_p2_additional_credits_message:
  btst.b   #$0, ($0,A6)
  bne hijack_hide_p2_additional_credits_message_p2
 
  move.w  #$bd, D0 ; Hide additional credit message p3
  jmp     $9e6c.l
 
hijack_hide_p2_additional_credits_message_p2:
  move.w  #$a7, D0 ; Hide additional credit message p2
  jmp     $9e6c.l
;=======================================
	
;=======================================

;=======================================
hijack_p1_select_player_countdown:
   movea.l #$0090879C, A1
   
   tst.b   ($53a9,A5)
   beq     p1_countdown_continue
   
   jmp $015C58
   
p1_countdown_continue:
   jmp $015C5C
;=======================================

;=======================================
hijack_p2_select_player_countdown:
   btst.b   #$0, ($0,A6)
   bne p2_countdown_handler
   
   movea.l #$0090971C, A1
   bra p2_countdown_exit
   
p2_countdown_handler:
   movea.l #$00908F1C, A1

p2_countdown_exit:
   tst.b   ($53a9,A5)
   beq     p2_countdown_continue
   
   jmp $0164C6
   
p2_countdown_continue:
   jmp $0164CA
;=======================================

;=======================================
hijack_p1_continue_countdown
  movea.l #$00908A0C, A1
  moveq #$0, D0
  jmp $0156CA
;=======================================

;=======================================
hijack_p2_continue_countdown:
   btst.b  #$0, ($0,A6)
   bne p2_continue_countdown_handler
   
   movea.l #$0090998C, A1
   bra p2_continue_countdown_exit
   
p2_continue_countdown_handler:
   movea.l #$0090918C, A1

p2_continue_countdown_exit:
   moveq #$0, D0
   jmp $015F3E
;=======================================

;=======================================
; Random code moved to make room for a draw handler in the early banks
; This is fucked up.... if something jumps to 143a (things do) and we use more space after this hijack we will cause a break
move_00142E:
   addi.w  #$10, D0
   move.w  D0, ($4,A0)
   move.w  D1, ($6,A0)
   lea     ($80,A0), A0
   move.w  (-$6eb2,A5), D0
   
   jmp $001442
;=======================================

