;================================================
hijack_player_2_init_top_entity:
  movea.l  #$ffff8000, A5
  lea     (-$6dbc,A5), A6
  lea     (p2_main_mem,A5), A4
  jsr     $15fc6

  move.b  #$1, ($0,A6)
  btst    #$1, ($7f,A5)
  bne     hijack_player_2_init_top_entity_exit

  move.w  #$2, ($2, A6)
  
hijack_player_2_init_top_entity_exit:
  move.w  #$1, D0 
  jsr     $87e.w

  jsr     $015D7A
  
  bra     hijack_player_2_init_top_entity_exit
;================================================
  

;================================================
hijack_player_2_add_top_entity:
   move.w  #$30, D0
   movea.l #$15d4e, A0 ; Load player 2 init jump address
   jsr     $826.w ; Call trap 0 handler, add player 2 init entity to entity manager

   move.w  #$D0, D0 ; Take entity location 10D0 for player 3 top level handler
   movea.l #player_3_top_level_entity_init, A0
   jsr     $826.w
   
   jmp $004CEC
;================================================

;================================================
hijack_player_2_remove_top_entity:
  bsr remove_p123_top_entities
  jmp $009382
   
hijack_player_2_remove_top_entity_main_screen:
  bsr remove_p123_top_entities
  jmp $0011F4
  
hijack_player_2_remove_top_entity_main_screen_demo:
  bsr remove_p123_top_entities
  jmp $018260
;================================================

;================================================
remove_p123_top_entities:
  move.w #$20, D0 ; Remove p1
  jsr $860.w ; Trap 2

  move.w #$30, D0 ; Remove p2
  jsr $860.w ; Trap 2

  move.w #$D0, D0 ; Remove p3
  jsr $860.w ; Trap 2

  rts
;================================================
  
;================================================
hijack_player_2_top_entity_init_player:
  btst.b    #$0, ($0,A6)
  beq hijack_player_2_top_entity_init_player_p3

  jsr $00a14c.l ; Init player 2
  
  bra hijack_player_2_top_entity_init_player_exit

hijack_player_2_top_entity_init_player_p3:
  jsr player_3_main_init

hijack_player_2_top_entity_init_player_exit:
  move.l  #$0, ($2,A6)

  jmp $015DA0
;================================================

;================================================
hijack_p2_initialize_health_and_score
  jsr     $1e90.w ; Draw player health bar

  btst.b  #$1, ($13,A4)
  bne hijack_p2_initialize_health_and_score_p3

  move.w  #$80, D0
  bra hijack_p2_initialize_health_and_score_exit

hijack_p2_initialize_health_and_score_p3:
  move.w  #$C0, D0

hijack_p2_initialize_health_and_score_exit:
  jsr $2852.w ; Add score fifo entry to initialize score 

  jmp $0160EA
;================================================

;================================================
player_3_top_level_entity_init:
  movea.l  #$ffff8000, A5
  lea     ($7480,A5), A6 ; This memory is used for timers and other functions of the top entity (sets $2 to $0004 when a player has clicked in on the game over screen)
  lea     (p3_main_mem,A5), A4
  jsr     $15fc6

  move.b  #$2, ($0,A6)
  btst    #$2, ($7f,A5)
  bne     player_3_top_level_entity_init_exit

  move.w  #$2, ($2, A6)

player_3_top_level_entity_init_exit:
  move.w  #$1, D0 
  jsr     $87e.w

  jsr     $015D7A
  
  bra     player_3_top_level_entity_init_exit
;================================================


;================================================
hijack_player_top_entity_click_in_branch:
  moveq   #$0, D0
  move.b  (A6), D0
  and.b   #$01, D0
  add.b   D0, D0
  
  jmp $002E24
;================================================
  
  
;================================================
hijack_player_top_entity_click_in_branch_2:
  moveq   #$0, D0
  move.b  (A6), D0
  and.b   #$01, D0
  add.b   D0, D0
  
  jmp $002D92
;================================================
    
;================================================
hijack_p1_top_entity_click_in_check:
  tst.b (A6)
  beq p1_click_in
  
  bra p3_check_click_in

p1_click_in:  
  tst.b ($82,A5) ; Game started
  bne p1_click_in_game_active
  
  jmp $002E36

p1_click_in_game_active:
  jmp $002E50
;================================================

;================================================
hijack_p1_top_entity_continue_check:
  tst.b (A6)
  beq hijack_p1_top_entity_continue_check_p1_continue
  
  bra p3_check_click_in

hijack_p1_top_entity_continue_check_p1_continue:  
  tst.b   ($82,A5) ; Game started
  bne     p1_continue_game_active
  
  jmp $002DA4

p1_continue_game_active:
  jmp $002DBE
;================================================

;================================================
hijack_p2_continue_start_button_check:
   btst.b  #$1, (A6)
   beq p2_continue_start_button_check
   
   jsr p3_check_press_start
   beq     hijack_p2_continue_start_button_check_fail
   
   bra hijack_p2_continue_start_button_check_click_in
   
p2_continue_start_button_check
   jsr     $295e.w ; Check p2 start button while selecting player!
   btst    #$1, D0
   beq     hijack_p2_continue_start_button_check_fail

hijack_p2_continue_start_button_check_click_in:
   jmp $016474

hijack_p2_continue_start_button_check_fail:
   jmp $016496
;================================================

;================================================
p3_check_click_in:
   tst.b   ($82,A5)
   bne     p3_check_click_in_game_active

p3_check_click_in_fail:
   or.b    D0, D0
   rts

p3_check_click_in_finish:
   bset    #$2, ($7f,A5)
   move    #$1, CCR
   rts

p3_check_click_in_game_active:
   tst.b   ($7e,A5) ; Free play
   bne     p3_check_click_in_check_start_button

   tst.w   ($4c,A5) ; Check coins
   beq     p3_check_click_in_fail

; Check player 3 click in
p3_check_click_in_check_start_button:
   jsr p3_check_press_start
   beq     p3_check_click_in_fail
   
   tst.b   ($5480,A5)
   beq     p3_check_click_in_one_credit

   cmpi.w  #$2, ($4c,A5) ; Has two coins?
   bcs     p3_check_click_in_fail

; Subtract a credit!
   subq.w  #1, ($4c,A5)

; Subtract a credit!
p3_check_click_in_one_credit:
   subq.w  #1, ($4c,A5)
   jsr     $002cb4.w

   bra     p3_check_click_in_finish
;================================================

;================================================
hijack_p2_top_entity_disable_player:
  btst    #$1, (A6)
  beq     p2_disable_player

  bclr    #$2, ($7f,A5) ; Clear p3 active flag
  bra     hijack_p2_top_entity_disable_player_exit
  
p2_disable_player:
  bclr    #$1, ($7f,A5) ; Clear p2 active flag

hijack_p2_top_entity_disable_player_exit:
  move.w  #$78, ($a,A6)
  clr.b   ($81,A4)

  jmp $016548
;================================================

;================================================
hijack_clear_player_active_bit_on_game_end:
  btst #$1, (A6)
  beq hijack_clear_player_active_bit_on_game_end_p2

  bclr #$2, ($7f,A5)
  bra hijack_clear_player_active_bit_on_game_end_exit

hijack_clear_player_active_bit_on_game_end_p2:
  bclr #$1, ($7f,A5)

hijack_clear_player_active_bit_on_game_end_exit:
  clr.b (A4)
  clr.b ($80,A4)
 
  jmp $0165B2
;================================================
