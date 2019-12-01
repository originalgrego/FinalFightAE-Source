;================================================
hijack_title_screen_click_in:
  jsr     $295e.w
  move.b D0, -(A7) ; Save d0

  jsr p3_calc_input
  jsr p3_check_press_start
  beq hijack_title_screen_click_in_no_p3_start

  move.b (A7)+, D0
  bset #$2, D0

  bra hijack_title_screen_click_in_continue

hijack_title_screen_click_in_no_p3_start:
  move.b (A7)+, D0

hijack_title_screen_click_in_continue:
  tst.b   D0
  beq hijack_title_screen_click_in_exit
  
  tst.b   ($7e,A5) ; Free play
  bne     hijack_title_screen_click_in_finish_click_in
  
  tst.b   ($5480,A5) ; Two credits to click in flag
  bne     hijack_title_screen_click_in_check_two_credits
  
  cmpi.w  #$1, ($4c,A5) ; Check if credit available
  bcs     hijack_title_screen_click_in_exit
  
  subq.w  #1, ($4c,A5)
  
  bra hijack_title_screen_click_in_finish_click_in

hijack_title_screen_click_in_check_two_credits:
  cmpi.w  #$2, ($4c,A5) ; Check if two credits available
  bcs     hijack_title_screen_click_in_exit
  
  subq.w  #2, ($4c,A5)
  
hijack_title_screen_click_in_finish_click_in:
  jmp $001168
  
hijack_title_screen_click_in_exit:
  rts
;================================================ 

;================================================
hijack_title_screen_click_in_set_active_player:
  move.b  D0, ($7f,A5)
  move.b  D0, ($5470,A5)
  rts
;================================================



