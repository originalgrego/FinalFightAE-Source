;================================================
hijack_bonus_stage_win_condition_checks:
   jsr get_player_count
   cmp.b #$1, D1
   bne multiple_players_active
   
   jmp $004fb2
   
multiple_players_active:
   jmp $004FAA
;================================================

;================================================
hijack_determine_bonus_stage_winner:
   bsr determine_highest_bonus_score

   ; Compare all players to highest score and set appropriate player bits
   moveq #$0, D0

   cmp.l (p1_bonus_score_start, A5), D1
   bne hijack_determine_bonus_stage_winner_check_p2
   
   bset #$0, D0
 
hijack_determine_bonus_stage_winner_check_p2:
   cmp.l (p2_bonus_score_start, A5), D1
   bne hijack_determine_bonus_stage_winner_check_p3
   
   bset #$1, D0
 
hijack_determine_bonus_stage_winner_check_p3:
   cmp.l (p3_bonus_score_start, A5), D1
   bne hijack_determine_bonus_stage_winner_exit
   
   bset #$2, D0

hijack_determine_bonus_stage_winner_exit:
   move.b D0, ($14,A4) ; Set winning players

   jmp $0050F4
;================================================

;================================================
; Calculates the highest score and returns it in d1
;================================================
determine_highest_bonus_score:
   moveq   #$0, D1 ; Initialize d1, will contain the highest score of all players after comparisons
   
   cmp.l (p1_bonus_score_start, A5), D1
   bgt determine_highest_bonus_score_check_p2
   
   move.l (p1_bonus_score_start, A5), D1
   
determine_highest_bonus_score_check_p2:
   cmp.l (p2_bonus_score_start, A5), D1
   bgt determine_highest_bonus_score_check_p3
   
   move.l (p2_bonus_score_start, A5), D1
   
determine_highest_bonus_score_check_p3:
   cmp.l (p3_bonus_score_start, A5), D1
   bgt determine_highest_bonus_score_exit
   
   move.l (p3_bonus_score_start, A5), D1

determine_highest_bonus_score_exit:
   rts
;================================================

;================================================
bonus_draw_winner_text:
  btst #$0, ($14,A6)
  beq bonus_draw_winner_text_check_p2

  move.w  #$15, D0
  jsr $14ae.w
  
bonus_draw_winner_text_check_p2:
  btst #$1, ($14,A6)
  beq bonus_draw_winner_text_check_p3

  move.w  #$16, D0
  jsr $14ae.w
  
bonus_draw_winner_text_check_p3:
  btst #$2, ($14,A6)
  beq bonus_draw_winner_text_exit
  
  move.w  #$4F, D0
  jsr $14ae.w
  
bonus_draw_winner_text_exit:  
  rts
;================================================
  
;================================================
bonus_hide_winner_text:
  btst #$0, ($14,A6)
  beq bonus_hide_winner_text_check_p2

  move.w  #$95, D0
  jsr $14ae.w
  
bonus_hide_winner_text_check_p2:
  btst #$1, ($14,A6)
  beq bonus_hide_winner_text_check_p3

  move.w  #$96, D0
  jsr $14ae.w
  
bonus_hide_winner_text_check_p3:
  btst #$2, ($14,A6)
  beq bonus_hide_winner_text_exit
  
  move.w  #$CF, D0
  jsr $14ae.w
  
bonus_hide_winner_text_exit:  
  rts
;================================================
  
;================================================
bonus_draw_winner_score:
  btst #$0, ($14,A6)
  beq bonus_draw_winner_score_check_p2

  move.w  #$1b, D0
  jsr $14ae.w
  
bonus_draw_winner_score_check_p2:
  btst #$1, ($14,A6)
  beq bonus_draw_winner_score_check_p3

  move.w  #$1c, D0
  jsr $14ae.w
  
bonus_draw_winner_score_check_p3:
  btst #$2, ($14,A6)
  beq bonus_draw_winner_score_exit
  
  move.w  #$55, D0
  jsr $14ae.w
  
bonus_draw_winner_score_exit:  
  rts
;================================================
  
;================================================
bonus_hide_winner_score:
  btst #$0, ($14,A6)
  beq bonus_hide_winner_score_check_p2

  move.w  #$9b, D0
  jsr $14ae.w
  
bonus_hide_winner_score_check_p2:
  btst #$1, ($14,A6)
  beq bonus_hide_winner_score_check_p3

  move.w  #$9c, D0
  jsr $14ae.w
  
bonus_hide_winner_score_check_p3:
  btst #$2, ($14,A6)
  beq bonus_hide_winner_score_exit
  
  move.w  #$D5, D0
  jsr $14ae.w
  
bonus_hide_winner_score_exit:  
  rts
;================================================
  
;================================================
hijack_winner_score_countdown:
  jsr $1fe28 ; Subtract from score
  bne hijack_winner_score_countdown_exit

  btst #$0, ($14,A6)
  beq hijack_winner_score_countdown_check_p2
  
  jsr $01FDE6
  
hijack_winner_score_countdown_check_p2:
  btst #$1, ($14,A6)
  beq hijack_winner_score_countdown_check_p3
  
  jsr $01FE0A

hijack_winner_score_countdown_check_p3:
  btst #$2, ($14,A6)
  beq hijack_winner_score_countdown_exit

  bsr p3_add_winner_bonus

hijack_winner_score_countdown_exit:
  rts
;================================================

;================================================
p3_add_winner_bonus:
  lea (p3_bonus_score_after, A5), A0
  jsr $1fe80 ; Add to bonus score
  bsr draw_p3_bonus_score

  move.b  #$D0, D0
  jsr     $19e8.w ; Update score

  movea.l #$9094A4, A0
  jmp     $1fe92  ; Update winner score
;================================================

;================================================
hijack_hide_all_winner_text: 
  jsr bonus_hide_winner_score
  jmp bonus_hide_winner_text
;================================================
 
;================================================
hijack_bonus_time_points:
  lea (p1_main_mem,A5), A0
  jsr $200d0 ; p1

  lea (p2_main_mem,A5), A0
  jsr $200e8 ; p2

  jmp p3_add_bonus_time_points
;================================================

;================================================
p3_add_bonus_time_points:
  lea (p3_main_mem,A5), A0

  tst.b ($0,A0)
  bne p3_add_bonus_time_points_continue
  
  rts

p3_add_bonus_time_points_continue:
  lea (p3_bonus_score_after,A5), A0
  jsr $2011c ; Add bonus time points

  bsr draw_p3_bonus_score

  move.b #$D0, D0
  jmp $19e8.w ; Update score
;================================================

;================================================
hijack_draw_final_bonus_scores_check_winner:
  btst #$0, ($546A,A5)
  beq hijack_draw_final_bonus_scores_check_winner_not_p1
 
  jsr $1fc90 ; p1
  
hijack_draw_final_bonus_scores_check_winner_not_p1:
  btst #$1, ($546A,A5)
  beq hijack_draw_final_bonus_scores_check_winner_not_p2
  
  jsr $1fca0 ; p2
  
hijack_draw_final_bonus_scores_check_winner_not_p2:
  btst #$2, ($546A,A5)
  beq hijack_draw_final_bonus_scores_check_winner_exit
  
  bsr hide_or_show_p3_final_bonus_score
  
hijack_draw_final_bonus_scores_check_winner_exit:
  jmp $01FC72
;================================================

;================================================
hide_or_show_p3_final_bonus_score:
  tst.b   ($80,A6)
  beq     hide_or_show_p3_final_bonus_score_hide

  jmp draw_p3_bonus_score

hide_or_show_p3_final_bonus_score_hide:
  move.w #$C9, D0
  jmp $14ae.w ; Hide string
;================================================

;================================================
hijack_bonus_perfect_select_player:
  cmp.b #$4, ($14,A6)
  beq p3_bonus_perfect_handler
  
  cmp.b #$2, ($14,A6)
  beq hijack_bonus_perfect_select_player_p2
  
  jmp $01FF8C ; Player 1 
  
hijack_bonus_perfect_select_player_p2:
  jmp $01FFA2
;================================================

;================================================
p3_bonus_perfect_handler:
  jsr     $1ffba ; Subtract from perfect score bonus
  bne     p3_bonus_perfect_handler_exit

  lea     (p3_bonus_score_after,A5), A0
  jsr     $20014 ; Add to bonus score
  bsr     draw_p3_bonus_score
  move.b  #$D0, D0
  jmp     $19e8.w ; Add to score

p3_bonus_perfect_handler_exit:
  rts
;================================================

;================================================
hijack_add_destroyed_bonus_item_count:
  tst.b   D0
  beq hijack_add_destroyed_bonus_item_count_p1
  
  btst #$0, D0
  beq hijack_add_destroyed_bonus_item_count_p3
  
  lea (p2_bonus_items_destroyed, A5), A1
  bra hijack_add_destroyed_bonus_item_count_exit
  
hijack_add_destroyed_bonus_item_count_p3:
  lea (p3_bonus_items_destroyed, A5), A1
  bra hijack_add_destroyed_bonus_item_count_exit
  
hijack_add_destroyed_bonus_item_count_p1:
  lea (p1_bonus_items_destroyed, A5), A1

hijack_add_destroyed_bonus_item_count_exit:
  addq.b #$1, (A1) ; Add 1 to objects destroyed for player
  rts
;================================================

;================================================
hijack_level_init:
  clr.l (p1_bonus_score_start,A5)
  clr.l (p2_bonus_score_start,A5)
  clr.l (p3_bonus_score_start,A5)
  clr.b (p1_bonus_items_destroyed,A5)
  clr.b (p2_bonus_items_destroyed,A5)
  clr.b (p3_bonus_items_destroyed,A5)
  jmp $004D6E
;================================================

;================================================
p3_check_high_score:
; Compare p2 to high score?
  move.l  (p3_score_start, A5), D1 ; Get p2 score
  cmp.l   (top_score, A5), D1 ; Compare to high score
  bls     p3_check_high_score_exit

  move.l  D1, (top_score,A5) ; Set high score
  jmp     $001a2e ; Draw high score

p3_check_high_score_exit:
	rts
;================================================
	
;================================================
check_score_assign_enemy_81:
  tst.b   ($81,A6)	
  bne  score_assign_all_players
  
  bra score_assign_enemy
;================================================

;================================================
check_score_assign_enemy_b0:
  tst.b   ($b0,A6)	
  bne  score_assign_all_players
  
  bra score_assign_enemy
;================================================

;================================================
check_score_assign_enemy_a3:
  tst.b   ($a3,A6)	
  bne  score_assign_all_players
  
  bra score_assign_enemy
;================================================

;================================================
check_score_assign_enemy_a2:
  tst.b   ($a2,A6)	
  bne  score_assign_all_players
  
  bra score_assign_enemy
;================================================

;================================================
score_assign_enemy:
  tst.b   ($69,A6)
  bmi score_assign_enemy_exit
  beq score_assign_enemy_continue ; Player 1

  btst.b   #$0, ($69,A6)
  beq score_assign_enemy_p3

  ori.b   #$80, D0
  bra score_assign_enemy_continue ; Player 2

score_assign_enemy_p3:
  ori.b   #$C0, D0
  
score_assign_enemy_continue:
  jmp     $2852.w
  
score_assign_enemy_exit:
  rts
;================================================

;================================================
score_assign_enemy_no_minus_check:
  tst.b   ($69,A6)
  beq score_assign_enemy_continue ; Player 1

  btst.b   #$0, ($69,A6)
  beq score_assign_enemy_p3

  ori.b   #$80, D0
  bra score_assign_enemy_continue ; Player 2
;================================================

;================================================
score_assign_player_a6:
  tst.b   ($13,A6)
  beq score_assign_player_a6_continue ; Player 1

  btst.b   #$0, ($13,A6)
  beq score_assign_player_a6_p3

  ori.b   #$80, D0
  bra score_assign_player_a6_continue ; Player 2

score_assign_player_a6_p3:
  ori.b   #$C0, D0
  
score_assign_player_a6_continue:
  jmp     $2852.w
;================================================

;================================================
score_assign_player_a0:
  tst.b   ($13,A0)
  beq score_assign_player_a0_continue ; Player 1

  btst.b   #$0, ($13,A0)
  beq score_assign_player_a0_p3

  ori.b   #$80, D0
  bra score_assign_player_a0_continue ; Player 2

score_assign_player_a0_p3:
  ori.b   #$C0, D0
  
score_assign_player_a0_continue:
  jmp     $2852.w
;================================================

;================================================
score_assign_all_players:
  jsr     $2852.w

  ori.b   #$80, D0
  jsr     $2852.w ; p2

  ori.b   #$40, D0
  jmp     $2852.w ; p3
;================================================

;================================================
hijack_score_calc:
  tst.b D0
  bmi hijack_score_calc_p23

  bra hijack_score_calc_p1

hijack_score_calc_p23:
  btst #$6, D0
  bne hijack_score_calc_p3

  jmp $001AB2 ; Do p2

hijack_score_calc_p1:
  ; copied from $001AA2
  lea     ($5f0,A5), A1 ; Just after p1 score
  lea     $90880c.l, A2 ; p1 score position
  move.w  #$180, D5
  jmp     $001ac0
  ; copied from $001AA2

hijack_score_calc_p3:
  lea     (p3_score_after, A5), A1
  lea     $90970C.l, A2 ; p3 score position
  move.w  #$180, D5
  jmp     $001ac0
;================================================

;================================================
hijack_score_updates:
  tst.b D0
  bmi hijack_score_updates_p23
  
  bra hijack_score_updates_p1
  
hijack_score_updates_p23:
  btst #$6, D0
  bne hijack_score_updates_p3
 
  jmp $0019FA ; Check p2

;-------------------------------------------------
hijack_score_updates_p1:
  tst.b   ($568,A5)
  bne     hijack_score_updates_p1_continue
  
  rts
  
hijack_score_updates_p1_continue:
  jmp $0019F2
;-------------------------------------------------

;-------------------------------------------------
hijack_score_updates_p3:
  tst.b (p3_main_mem, A5)
  bne hijack_score_updates_p3_continue

  rts
  
hijack_score_updates_p3_continue: 
  jsr     $001a9e ; Do score calc
  jsr     $001982 ; Draw score
  bra     p3_check_high_score
;-------------------------------------------------
;================================================

;================================================
hijack_bonus_score_draw:
  tst.b   (p1_main_mem,A5)
  beq     hijack_bonus_score_draw_try_p2

  jsr     $00211e

hijack_bonus_score_draw_try_p2:
  jsr     $002130 

  tst.b   (p3_main_mem,A5)
  beq     hijack_bonus_score_draw_exit

  jsr draw_p3_bonus_score

hijack_bonus_score_draw_exit:
  rts
;================================================

;================================================
draw_p3_bonus_score:
  movea.l #$909494, A0 ; Load screen position
  move.w  (p3_bonus_score_start,A5), D0 ; First word of bonus score
  jsr     $002154

  move.w  (p3_bonus_score_start_2,A5), D0  ; Second word of bonus score
  jsr     $002160

  rts
;================================================

;================================================
hijack_car_assign_points:
  lea (p1_bonus_score_after,A5), A0

  tst.b ($69,A6)
  beq hijack_car_assign_points_exit ; P1

  btst #$0, ($69,A6)
  beq hijack_car_assign_points_p3

  lea (p2_bonus_score_after,A5), A0
  ori.b #$80, D0
  bra hijack_car_assign_points_exit ; P2

hijack_car_assign_points_p3:
  lea (p3_bonus_score_after,A5), A0
  ori.b #$C0, D0

hijack_car_assign_points_exit:
  jmp $054364
;================================================

;================================================
hijack_glass_assign_points:
  lea (p1_bonus_score_after,A5), A0

  tst.b ($84,A6)
  beq hijack_glass_assign_points_exit ; P1

  btst #$0, ($84,A6)
  beq hijack_glass_assign_points_p3

  lea (p2_bonus_score_after,A5), A0
  ori.b #$80, D0
  bra hijack_glass_assign_points_exit ; P2

hijack_glass_assign_points_p3:
  lea (p3_bonus_score_after,A5), A0
  ori.b #$C0, D0

hijack_glass_assign_points_exit:
  jmp $0530D6
;================================================
