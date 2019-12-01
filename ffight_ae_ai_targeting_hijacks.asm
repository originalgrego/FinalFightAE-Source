;================================================
hijack_ai_targeting:
   move.w  #$7FFF, ($7FF8, A5)
   move.w  #$FFFF, ($7FFA, A5)

   lea     (p1_main_mem,A5), A0
   jsr     $0280d6
   move.w  D0, D2
   bmi check_p2_ai_target
   
   move.w ($7FF8, A5), D0
   cmp.w D0, D2
   bmi continue_p1_ai_target
   
   bra check_p2_ai_target
   
continue_p1_ai_target:
   move.w D2, ($7FF8, A5)
   move.w #$0000, ($7FFA, A5)
   
check_p2_ai_target:
   lea     (p2_main_mem,A5), A0
   jsr     $0280d6
   move.w  D0, D2
   bmi check_p3_ai_target

   move.w ($7FF8, A5), D0
   cmp.w D0, D2
   bmi continue_p2_ai_target
   
   bra check_p3_ai_target
   
continue_p2_ai_target:
   move.w D2, ($7FF8, A5)
   move.w #$0001, ($7FFA, A5)
   
check_p3_ai_target:
   lea     (p3_main_mem,A5), A0
   jsr     $0280d6
   move.w  D0, D2
   bmi finish_ai_target
   
   move.w ($7FF8, A5), D0
   cmp.w D0, D2
   bmi continue_p3_ai_target
   
   bra finish_ai_target
   
continue_p3_ai_target:
   move.w D2, ($7FF8, A5)
   move.w #$0002, ($7FFA, A5)
      
finish_ai_target:
   move.w ($7FFA, A5), D2
   bmi all_players_invalid
   
   beq ai_target_player_1
   
   cmp.w #$0001, D2
   beq ai_target_player_2
   
   jmp ai_target_player_3
   
ai_target_player_2:   
   jmp $0280CC
   
ai_target_player_1:   
   jmp $0280C2
   
all_players_invalid:
   jmp $0280BC
;================================================

;================================================
hijack_minor_enemy_targeting:
 lea     (p2_main_mem,A5), A0
 moveq   #$2, D1
 jsr     $27ae6
 
 bne hijack_minor_enemy_targeting_success

 lea     (p3_main_mem,A5), A0
 moveq   #$4, D1
 jsr     $27ae6

 bne hijack_minor_enemy_targeting_success

 jmp $027AD2

hijack_minor_enemy_targeting_success:
 jmp $027AD6
;================================================

;================================================
hijack_shuffle_check_active_player:
  move.b  (p1_main_mem,A5), D0 ; Active
  or.b    (p2_main_mem,A5), D0 ; Active
  or.b    (p3_main_mem,A5), D0 ; Active
  beq      hijack_shuffle_check_active_player_fail

  jmp $027C00

hijack_shuffle_check_active_player_fail:
  jmp $027c68
;================================================

;================================================
hijack_shuffle_check_player_8E:
  move.b  ($5f6,A5), D0 ; $8E
  or.b    ($6b6,A5), D0 ; $8E
  or.b    ($6776,A5), D0 ; $8E
  bne  hijack_shuffle_check_player_8E_success

  jmp $027C0E

hijack_shuffle_check_player_8E_success:
  jmp $027c64
;================================================

;================================================
hijack_shuffle_try_next_player:  
  cmpa.w  (p1_main_mem, A5), A4 ; Compare to currently targeted player
  beq     hijack_shuffle_try_next_player_p2 
  
  cmpa.w  (p2_main_mem, A5), A4 ; Compare to currently targeted player
  beq     hijack_shuffle_try_next_player_p3
  
  jmp $027C2A ; Player 1
  
hijack_shuffle_try_next_player_p2:
  jmp $027c30

hijack_shuffle_try_next_player_p3:
  lea (p3_main_mem, A5), A0
  jmp $027C34
;================================================

;================================================
hijack_boss_ai_targeting:
  moveq   #$1, D3
  lea     (p2_main_mem,A5), A0
  tst.b   ($0,A0)
  beq     check_p3_boss_ai
  jsr     $040a7c
  bne     exit_boss_ai
  
check_p3_boss_ai:
  moveq   #$2, D3
  lea     (p3_main_mem,A5), A0
  tst.b   ($0,A0)
  beq     bad_p3_target
  jmp     $040a7c

bad_p3_target:
  moveq   #$0, D0
  
exit_boss_ai:
  rts
;================================================

;================================================
hijack_andore_switch_player:
  movea.l ($80,A6), A1
  cmp.b   #$1, ($13,A1) ; Check player 2 previously targeted
  beq     andore_switch_player_try_p3 ; If it was player 2 try player 3

  movea.l ($80,A6), A1
  cmp.b   #$2, ($13,A1) ; Check player 3 previously targeted
  beq     andore_switch_player_try_p1 ; If it was player 3 try player 1
  
  bra andore_switch_player_try_p2

andore_switch_player_try_p1:
  lea     (p1_main_mem,A5), A0
  moveq   #$0, D3
  bra andore_switch_player_try_player

andore_switch_player_try_p2:
  lea     (p2_main_mem,A5), A0
  moveq   #$1, D3
  bra andore_switch_player_try_player

andore_switch_player_try_p3:
  lea     (p3_main_mem,A5), A0
  moveq   #$2, D3

andore_switch_player_try_player:
  jsr $02E630
  beq andore_switch_player_exit ; we done, bad target
  
  jsr $02E610 ; Target considered player

andore_switch_player_exit:
  rts
;================================================

;================================================
andore_prox_damage_check:
  lea     (p1_main_mem,A5), A3
  jsr     $02de1c

  lea     (p2_main_mem,A5), A3
  jsr     $02de1c

  lea     (p3_main_mem,A5), A3
  jsr     $02de1c

  rts
;================================================

;================================================
hijack_andore_prox_check_other:
  bsr andore_prox_damage_check
  
  jmp $02D134
;================================================

;================================================
hijack_andore_butt_slam_prox
  bsr andore_prox_damage_check
  
  jmp $02DE0E
;================================================

;================================================
hijack_andore_proximity_results:
   jsr $02E630
   bsr invert_d0_result
   rts

hijack_andore_targeting:
   move.l  A3, -(A7)
   
   movea.l #hijack_andore_proximity_results, A3
   
   bsr boss_ai_targeting_proximity_start
   
   movea.l (A7)+, A3

   bsr invert_d0_result
   
   cmp.b   ($88,A6), D3
   beq     exit_andore_targeting ; Was already targeted
   
   tst.b D0
   beq exit_andore_targeting
   
   jsr $02E610

exit_andore_targeting:   
   rts
;================================================

;================================================
invert_d0_result:
  eor.b #$01, D0
  rts
;================================================

;================================================
hijack_sodom_initialize:
  bsr boss_health_init_common
  jmp $040C74
;================================================

;================================================
hijack_sodom_targeting_1:
   move.l  A3, -(A7)
   
   movea.l #$0004277E, A3
   
   bsr boss_ai_targeting_proximity_start
   
   movea.l (A7)+, A3
   
   rts

hijack_sodom_targeting_2:
   move.l  A3, -(A7)
   
   movea.l #$000427F8, A3
   
   bsr boss_ai_targeting_proximity_start
   
   movea.l (A7)+, A3
   
   rts
;================================================

;================================================
hijack_major_enemy_hit_tageting:
   move.l  A3, -(A7)
   move.l  D2, -(A7)
   
   movea.l #major_enemy_hit_targeting_proximity_calc, A3
   
   bsr boss_ai_targeting_proximity_start
   
   tst.b D0
   beq hijack_major_enemy_hit_tageting_finish
   
   lea (p1_main_mem, A5), A0
   moveq #$0, D3

hijack_major_enemy_hit_tageting_finish:   
   move.l (A7)+, D2
   movea.l (A7)+, A3
   
   rts
;================================================
   
;================================================
major_enemy_hit_targeting_proximity_calc:
  tst.b   (A0)
  bne  major_enemy_hit_targeting_proximity_calc_continue

  move.w  #$7FFF, D1
  moveq  #$1, D0
  rts

major_enemy_hit_targeting_proximity_calc_continue:
  move.w  ($6,A0), D1
  sub.w   ($6,A6), D1
  bpl     major_enemy_hit_targeting_proximity_calc_exit
  
  neg.w   D1
  
major_enemy_hit_targeting_proximity_calc_exit:
  moveq  #$0, D0
  rts
;================================================

;================================================
hijack_damnd_targeting_2:
   move.l  A3, -(A7)
   
   movea.l #$00040718, A3
   
   bsr boss_ai_targeting_proximity_start
   
   movea.l (A7)+, A3
   
   rts

hijack_damnd_targeting_3:
   move.l  A3, -(A7)
   
   movea.l #$00040792, A3
   
   bsr boss_ai_targeting_proximity_start
   
   movea.l (A7)+, A3
   
   rts
;================================================
   
;================================================
; G Oriber
hijack_g_oriber_targeting:
   move.l  A3, -(A7)
   move.l  D3, -(A7)
   
   movea.l #$00032C00, A3
   
   bsr boss_ai_targeting_proximity_start
   
   move.l (A7)+, D3
   movea.l (A7)+, A3
   
   tst.b D0
   
   rts

;------------------------------------------------

hijack_g_oriber_targeting_2:
   move.l  A3, -(A7)
   move.l  D3, -(A7)
   
   movea.l #$00032C76, A3 
   
   bsr boss_ai_targeting_proximity_start
   
   move.l (A7)+, D3
   movea.l (A7)+, A3

   tst.b D0
   
   rts
;================================================
   
;================================================
hijack_andore_boss_proximity:
;	Whichever player is the leader of the outro demo will become Boss Andore's target.
;	$91 is the leader byte. 00 = leader, !0 = follower
;	A0 is set as target player address to Boss Andore's RAM upon return.
	lea     (p1_main_mem,A5), A0
	tst.b   (A0)
	beq		hijack_andore_boss_proximity_2p
	tst.b	($91,A0)
	beq		hijack_andore_boss_proximity_return
hijack_andore_boss_proximity_2p:
	lea     (p2_main_mem,A5), A0
	tst.b   (A0)
	beq		hijack_andore_boss_proximity_3p
	tst.b	($91,A0)
	beq		hijack_andore_boss_proximity_return
hijack_andore_boss_proximity_3p:
	lea     (p3_main_mem,A5), A0
hijack_andore_boss_proximity_return:
	rts
;================================================
   
;================================================
boss_ai_targeting_proximity_start:
   move.w  #$7FFF, ($7FF8, A5)
   move.w  #$FFFF, ($7FFA, A5)
   
   lea (p1_main_mem,A5), A0
   jsr (A3)
   bne boss_ai_targeting_proximity_check_p2
   
   move D1, D2
   move.w ($7FF8, A5), D0
   cmp.w D0, D2
   bmi boss_ai_targeting_proximity_continue_p1
   
   bra boss_ai_targeting_proximity_check_p2
   
boss_ai_targeting_proximity_continue_p1:
   move.w D2, ($7FF8, A5)
   move.w #$0000, ($7FFA, A5)
   
boss_ai_targeting_proximity_check_p2:
   lea (p2_main_mem,A5), A0
   jsr (A3)
   bne boss_ai_targeting_proximity_check_p3
   
   move D1, D2
   move.w ($7FF8, A5), D0
   cmp.w D0, D2
   bmi boss_ai_targeting_proximity_continue_p2
   
   bra boss_ai_targeting_proximity_check_p3
   
boss_ai_targeting_proximity_continue_p2:
   move.w D2, ($7FF8, A5)
   move.w #$0001, ($7FFA, A5)

boss_ai_targeting_proximity_check_p3:
   lea (p3_main_mem,A5), A0
   jsr (A3)
   bne boss_ai_targeting_proximity_finish
   
   move D1, D2
   move.w ($7FF8, A5), D0
   cmp.w D0, D2
   bmi boss_ai_targeting_proximity_continue_p3
   
   bra boss_ai_targeting_proximity_finish
   
boss_ai_targeting_proximity_continue_p3:
   move.w D2, ($7FF8, A5)
   move.w #$0003, ($7FFA, A5)   

boss_ai_targeting_proximity_finish:
   move.w ($7FFA, A5), D2
   bmi boss_ai_targeting_proximity_invalid
   
   beq boss_ai_targeting_proximity_select_p1
   
   cmp.w #$0001, D2
   beq boss_ai_targeting_proximity_select_p2
   
   jmp boss_ai_targeting_proximity_select_p3

boss_ai_targeting_proximity_select_p1:
   lea     (p1_main_mem,A5), A0
   moveq   #$0, D3
   moveq   #$0, D0
   rts

boss_ai_targeting_proximity_select_p2:
   lea     (p2_main_mem,A5), A0
   moveq   #$1, D3
   moveq   #$0, D0
   rts

boss_ai_targeting_proximity_select_p3:
   lea     (p3_main_mem,A5), A0
   moveq   #$2, D3
   moveq   #$0, D0
   rts

boss_ai_targeting_proximity_invalid:
  move.b  #$1, D0
  rts
;================================================

;================================================
boss_health_init_common:
  bsr get_player_count
  
  cmpi.b #$1, D1
  bne    boss_health_init_check_2p
  
  move.w  #$12c, D1 ; 1 player health
  rts
  
boss_health_init_check_2p:
  cmpi.b #$2, D1
  bne    boss_health_init_3p
  
  move.w  #$1c2, D1 ; 2 Player health
  rts

boss_health_init_3p:
  move.w  #$258, D1 ; 3 Player health
  rts
;================================================


;================================================
hijack_damnd_initialize:
  bsr boss_health_init_common
  move.b  ($546a,A5), D0 ; Load main player status
  jmp $03D41C
;================================================

;================================================
hijack_damnd_choose_initial_player:
  bsr get_player_count
  tst.b D1
  beq damnd_choose_initial_player_none_active
  
  bsr boss_choose_random_player
  jmp $03D51A
  
damnd_choose_initial_player_none_active:
  jmp $03D4EC
  
;================================================

;================================================
choose_random_player:
  move.b ($546a,A5), D0  

choose_random_player_D0:
  bsr get_player_count_D0
  tst.b D1
  beq choose_random_player_none_active

  cmpi.b #$1, D1
  bne choose_random_player_check_two
  
  bra get_active_player_D0
  
choose_random_player_check_two:
  cmpi.b #$2, D1
  bne choose_random_player_three_active
  
  bra get_random_player_two_active_D0

choose_random_player_three_active:
  bra get_random_player_three_active

choose_random_player_none_active:
  bra return_player_1
;================================================
  
;================================================
boss_choose_random_player:
  bsr choose_random_player
  move.b D0, D3
  rts
;================================================
  
;================================================
hijack_damnd_player_status_jmp:
  jsr $03D5FC
  
  jmp $03D5A2
;================================================

;================================================
get_random_player_two_active:
  move.b ($546a,A5), D0  

get_random_player_two_active_D0:
  btst #$0, D0
  beq get_random_player_two_active_p2_p3
  
  btst #$1, D0
  beq get_random_player_two_active_p1_p3
  
  bsr coin_flip
  beq return_player_1
  
  bra return_player_2
  
get_random_player_two_active_p2_p3:
  bsr coin_flip
  beq return_player_2
  
  bra return_player_3
  
get_random_player_two_active_p1_p3:
  bsr coin_flip
  beq return_player_1
  
  bra return_player_3
;================================================

;================================================
coin_flip:
  jsr     $3bec.w ; Random!?

  andi.w  #$f, D0 ; Random value clamped to 0 - f
  move.w  #$aaaa, D1 ; This is odd, but the lowest nibble is all that matters, choose half the bits, #$a
  btst    D0, D1 ; Check if bit 1 or 3 are set on the lowest nibble
  rts
;================================================

;================================================
get_random_player_three_active:
  jsr     $3bec.w ; Random
  andi.w  #$ff, D0 ; Random value clamped to 00 - ff

  cmpi.b  #$55, D0
  bpl  get_random_player_three_active_check_p2
  
  bra return_player_1

get_random_player_three_active_check_p2:
  cmpi.b  #$AA, D0
  bpl  get_random_player_three_active_p3

  bra return_player_2
  
get_random_player_three_active_p3:
  bra return_player_3
;================================================

;================================================
return_player_1:
  moveq   #$0, D0
  lea     (p1_main_mem, A5), A0
  rts

return_player_2:
  moveq   #$1, D0
  lea     (p2_main_mem,A5), A0
  rts

return_player_3:
  moveq   #$2, D0
  lea     (p3_main_mem,A5), A0
  rts
;================================================
  
;================================================
get_active_player:
  move.b ($546a,A5), D0  

get_active_player_D0:
  btst #$0, D0
  beq get_active_player_check_p2
  
  bra return_player_1
  
get_active_player_check_p2:
  btst #$1, D0
  beq get_active_player_p3

  bra return_player_2
  
get_active_player_p3:
  bra return_player_3
;================================================

;================================================
get_player_count:
  move.b ($546a,A5), D0

get_player_count_D0:
  moveq  #$0, D1
  
  btst   #$0, D0
  beq    check_count_p2
  
  addq   #$1, D1
  
check_count_p2:
  btst   #$1, D0
  beq    check_count_p3
  
  addq   #$1, D1

check_count_p3:
  btst   #$2, D0
  beq    get_player_count_exit
  
  addq   #$1, D1

get_player_count_exit:
  rts
;================================================

;================================================
hijack_minor_enemy_group_targeting_check_common:
  beq hijack_minor_enemy_group_targeting_fail_exit
	
  cmp.b #$1, D0
  bne hjack_minor_enemy_group_targeting_check_p2

  move.l #$00FF115C, D0
  rts
  
hjack_minor_enemy_group_targeting_check_p2:
  cmp.b #$2, D0
  bne hjack_minor_enemy_group_targeting_p3

  move.l #$00FF1164, D0
  rts
  
hjack_minor_enemy_group_targeting_p3:

  move.l #$00FFF900, D0
  rts
  
hijack_minor_enemy_group_targeting_fail_exit:
  moveq #$0, D0
  rts
;================================================

;================================================
hijack_minor_enemy_group_targeting_check:
  bsr hijack_minor_enemy_group_targeting_check_common
  bne hijack_minor_enemy_group_targeting_exit

  jmp $27EA2

hijack_minor_enemy_group_targeting_exit:
  jmp $027E52
;================================================

;================================================
hijack_minor_enemy_group_targeting_check_2:
  bsr hijack_minor_enemy_group_targeting_check_common
  move.l D0, D1
  bne hijack_minor_enemy_group_targeting_exit_2

  jmp $27CDC

hijack_minor_enemy_group_targeting_exit_2:
  jmp $027CD0
;================================================

;====================================================================
hijack_p2_generate_group_data:
  tst.w   (-$6eac,A5)
  beq     hijack_p2_generate_group_data_p3

  lea     (p2_main_mem,A5), A2
  lea     (-$6e9c,A5), A3 ; P2 level script data?
  jsr     $2800a
  
hijack_p2_generate_group_data_p3:
  tst.b   (p3_main_mem,A5)
  bne     hijack_p2_generate_group_data_p3_continue

  move.w  ($412,A5), D0 ; Level scroll x
  addi.w  #$140, D0
  move.w  D0, (p3_x_pos,A5)

  move.w  ($416,A5), D0 ; Level scroll y
  addi.w  #$30, D0
  move.w  D0, (p3_y_pos,A5)
  move.w  D0, (p3_y_pos_origin,A5)

hijack_p2_generate_group_data_p3_continue:
  tst.w   (-$6eac,A5)
  beq     hijack_p2_generate_group_data_exit

  lea     (p3_main_mem, A5), A2
  lea     (p3_enemy_grouping_data, A5), A3
  jsr     $2800a

hijack_p2_generate_group_data_exit:
  rts
;====================================================================

;====================================================================
hijack_p2_init_group_data:
  move.w  D0, (-$6e9c,A5) ; p2 group data
  move.w  D0, (-$6e9a,A5)
  move.w  D0, (p3_enemy_grouping_data,A5)
  jmp $003E04
;====================================================================

;================================================
hijack_edi_initialize:
  bsr boss_health_init_common
  move.w D1, D0
  
  jmp $045F74
;================================================

;================================================
hijack_abigail_initialize:
  bsr boss_health_init_common
  move.w D1, D0
  add.w #$C8, D0
  
  jmp $04BE50
;================================================

;================================================
hijack_abigail_edi_targeting:
  move.l  A0, -(A7)
 
  bsr   get_player_count
  tst.b D1
  beq   hijack_abigail_edi_targeting_exit
  
  cmp.b #$1, D1
  bne   hijack_abigail_edi_targeting_more_than_two_active
  
  bsr   get_active_player
  bsr   hijack_abigail_edi_targeting_assign_player 
  bra   hijack_abigail_edi_targeting_exit
  
hijack_abigail_edi_targeting_more_than_two_active:
  subq.w  #1, ($82,A6)
  bne     hijack_abigail_edi_targeting_do_position_check

  move.w  #$f0, ($82,A6)

  bsr   choose_random_player
  bsr   hijack_abigail_edi_targeting_assign_player   
  bra   hijack_abigail_edi_targeting_exit
  
hijack_abigail_edi_targeting_do_position_check:  
  bsr   abigail_edi_targeting_position_check

hijack_abigail_edi_targeting_exit:
  movea.l (A7)+, A0
  rts

hijack_abigail_edi_targeting_assign_player:
  move.w  ($6,A0), ($86,A6)
  move.w  ($E,A0), ($88,A6)
  move.b  D0, ($93,A6)
  rts
;================================================
 

;================================================  
abigail_edi_targeting_position_check_try_player:
  tst.b   (A0)
  beq     abigail_edi_targeting_position_check_try_player_exit_fail
  
  move.w  ($6,A0), D0
  jsr     $046ca4 ; Check x pos
  beq     abigail_edi_targeting_position_check_try_player_exit_fail

  move.w  ($e,A0), D0
  jsr     $046cba ; Check y origin
  beq     abigail_edi_targeting_position_check_try_player_exit_fail
  
  moveq   #$1, D0
  rts 

abigail_edi_targeting_position_check_try_player_exit_fail:
  moveq   #$0, D0
  rts
;================================================  

;================================================  
abigail_edi_targeting_position_check:
  clr.b   ($84,A6)
  
  bsr return_player_1
  bsr abigail_edi_targeting_position_check_try_player
  beq abigail_edi_targeting_position_check_p2

  bset    #$0, ($84,A6)

abigail_edi_targeting_position_check_p2:
  bsr return_player_2
  bsr abigail_edi_targeting_position_check_try_player
  beq abigail_edi_targeting_position_check_p3

  bset    #$1, ($84,A6)

abigail_edi_targeting_position_check_p3:
  bsr return_player_3
  bsr abigail_edi_targeting_position_check_try_player
  beq abigail_edi_targeting_position_check_continue

  bset    #$2, ($84,A6)
  
abigail_edi_targeting_position_check_continue:
  move.b  ($84,A6), D0
  beq     abigail_edi_targeting_position_check_exit

  move.b  #$b4, ($99,A6)
  
  bsr     choose_random_player_D0
  bra     hijack_abigail_edi_targeting_assign_player
  
abigail_edi_targeting_position_check_exit:
  rts
;================================================

;================================================
hijack_abigail_edi_reassign_target
  tst.b   ($93,A6)
  bne     hijack_abigail_edi_reassign_target_check_p2

  jmp $046C38
 
hijack_abigail_edi_reassign_target_check_p2:
  cmp.b  #$1, ($93,A6)
  bne    hijack_abigail_edi_reassign_target_p3

  jmp $046C24

hijack_abigail_edi_reassign_target_p3
  move.w  ($66EE,A5), ($86,A6)
  move.w  ($66F6,A5), ($88,A6)
  move.b  #$2, ($93,A6) ; Assign player 3
  rts
;================================================

;================================================
hijack_abigail_active_player_check:
  bsr boss_active_player_check
  beq hijack_abigail_active_player_check_exit
  
  jmp $04c192

hijack_abigail_active_player_check_exit:
  jmp $04C208
;================================================

;================================================
hijack_edi_active_player_check:
  bsr boss_active_player_check
  beq hijack_edi_active_player_check_exit
  
  jmp $046250

hijack_edi_active_player_check_exit:
  jmp $046296
;================================================

;================================================
boss_active_player_check:
  tst.b   ($93,A6) ; Check active player
  beq     boss_active_player_check_p1

  cmp.b   #$1, ($93,A6)
  bne     boss_active_player_check_p3
  
  move.b  (p2_main_mem,A5), D0 
  rts
  
boss_active_player_check_p3
  move.b  (p3_main_mem,A5), D0 
  rts
  
boss_active_player_check_p1:
  move.b  (p1_main_mem,A5), D0 
  rts
;================================================

;================================================
boss_check_active_player_89:
  tst.b   ($93,A6)
  beq     boss_check_active_player_89_p1

  cmp.b   #$1, ($93,A6)
  bne     boss_check_active_player_89_p3
 
  move.b  ($6b1,A5), D0  ; p2 $89
  rts

boss_check_active_player_89_p3:
  move.b  ($6771,A5), D0 ; p3 $89
  rts
  
boss_check_active_player_89_p1:
  move.b  ($5f1,A5), D0 ; p1 $89
  rts
;================================================

;================================================
hijack_rolento_initialize:
  jsr $04afd8 ; Even tho this initializes rolentos health table, it does other stuff, please don't delete

  bsr boss_health_init_common

  move.w  D1, ($1c,A6)
  move.w  D1, ($1a,A6)
  move.w  D1, ($18,A6)
  
  jsr $04a55c
  
  jmp $048A9E
;================================================

;================================================
hijack_rolento_damage_table_calc
   bsr rolento_get_player_count
   cmpi.b #$1, D0
   beq hijack_rolento_damage_table_calc_exit
   
   moveq #$2, D0
   
hijack_rolento_damage_table_calc_exit:
   add.w D0, D0
   jmp $04AFE8
;================================================

;================================================
hijack_rolento_choose_random_player:
  bsr get_player_count
  cmpi.b #$1, D1
  beq hijack_rolento_choose_random_player_one_active
  
  bsr choose_random_player
  tst.b D0
  beq hijack_rolento_choose_random_player_p1
  
  move.l D0, D3
  lsl.w #$1, D3 ; p2/p3 fix the id
  tst.b D3
  rts
  
hijack_rolento_choose_random_player_p1:
  moveq #$1, D3
  rts

hijack_rolento_choose_random_player_one_active:
  jmp $04A882
;================================================

;================================================
hijack_rolento_prox_then_random:
  lea     (p1_main_mem,A5), A0
  jsr     $04adbe
  bne     hijack_rolento_prox_then_random_exit

  lea     (p2_main_mem,A5), A0
  jsr     $04adbe
  bne     hijack_rolento_prox_then_random_exit

  lea     (p3_main_mem,A5), A0
  jsr     $04adbe
  
hijack_rolento_prox_then_random_exit:
  rts
;================================================

;================================================
hijack_rolento_double_proximity_check:
  lea     (p1_main_mem,A5), A0
  jsr     $04ad12
  bne     hijack_rolento_double_proximity_check_exit

  lea     (p2_main_mem,A5), A0
  jsr     $04ad12
  bne     hijack_rolento_double_proximity_check_exit

  lea     (p3_main_mem,A5), A0
  jsr     $04ad12

hijack_rolento_double_proximity_check_exit:
  rts
;================================================

;================================================
hijack_rolento_nuckin_futz_check:
  bsr rolento_get_player_count
  
  jmp $049DEC
  
;-------------------------------------------------

hijack_rolento_nuckin_futz_check_2:
  bsr rolento_get_player_count
  
  jmp $049E84

;-------------------------------------------------

rolento_get_player_count:
  move.l  D1, -(A7)

  bsr get_player_count
  move.l  D1, D0
  
  move.l (A7)+, D1

  rts
;================================================

;================================================
hijack_enemy_health_calc:
  move.l  D0, -(A7)
  move.w  D1, -(A7)
  
  bsr get_player_count
  cmp.b #$3, D1
  bne hijack_enemy_health_calc_exit
  
  move.w (A7)+, D1

  move.w  D1, D0
  lsl.w   #$1, D0
  add.w   D1, D0
  lsr.w   #$1, D0

  move.w  D0, -(A7)
  
hijack_enemy_health_calc_exit:  
  move.w (A7)+, D1

  move.w  D1, ($1c,A6)
  move.w  D1, ($18,A6)
  move.w  D1, ($1a,A6)
  
  move.l (A7)+, D0
  jmp    $002F8C
;================================================

;================================================
; Bred
;================================================
;------------------------------------------------
hijack_bred_pick_active_player:
  bsr minor_enemy_pick_active

  jmp $022AD6
;------------------------------------------------

;------------------------------------------------
hijack_bred_pick_active_player_2:
  bsr minor_enemy_pick_active

  jmp $022B2E
;------------------------------------------------

;------------------------------------------------
hijack_bred_prox_check:
  lea     (p1_main_mem,A5), A0
  jsr     $279ce
  bne     hijack_bred_prox_check_end

  lea     (p2_main_mem,A5), A0
  jsr     $279ce
  bne     hijack_bred_prox_check_end

  lea     (p3_main_mem,A5), A0
  jsr     $279ce
  
hijack_bred_prox_check_end:
  rts
;------------------------------------------------
;================================================

;================================================
; Two P
;================================================
;------------------------------------------------
hijack_two_p_pick_active_player:
  bsr minor_enemy_pick_active

  jmp $028BC6
;------------------------------------------------

;------------------------------------------------
hijack_two_p_pick_active_player_2:
  bsr minor_enemy_pick_active

  jmp $028C08
;------------------------------------------------
;================================================

;================================================
; Axl
hijack_axl_pick_active_player:
  bsr minor_enemy_pick_active

  jmp $02ADB8

hijack_axl_pick_active_player_2:
  bsr minor_enemy_pick_active

  jmp $02AE04
;================================================

;================================================
; Hollywood
hijack_hollywood_proximity:
  lea     (p1_main_mem,A5), A0
  jsr     $36a6a
  bne     hijack_hollywood_proximity_exit

  lea     (p2_main_mem,A5), A0  
  jsr     $36a6a
  bne     hijack_hollywood_proximity_exit

  lea     (p3_main_mem,A5), A0  
  jsr     $36a6a

hijack_hollywood_proximity_exit:
  rts
;================================================

;================================================
; Roxy
hijack_roxy_proximity:
  lea     (p2_main_mem,A5), A0
  tst.b   ($0,A0)
  beq     hijack_roxy_proximity_p3

  jsr     $38af6 ; Roxy proximity test
  bne     hijack_roxy_proximity_p3
  
  jmp $038AE4
  
hijack_roxy_proximity_p3:
  lea     (p3_main_mem,A5), A0
  tst.b   ($0,A0)
  beq     hijack_roxy_proximity_exit

  jsr     $38af6 ; Roxy proximity test
  bne     hijack_roxy_proximity_exit
  
  jmp $038AE4
  
hijack_roxy_proximity_exit:
  rts

;------------------------------------------------

hijack_roxy_proximity_2:
   move.l  A3, -(A7)
   move.l  D3, -(A7)

   movea.l #$0003A5D2, A3 
   
   bsr boss_ai_targeting_proximity_start
   
   move.l (A7)+, D3
   movea.l (A7)+, A3

   tst.b D0
   
   rts

;------------------------------------------------
   
hijack_roxy_proximity_3:
   move.l  A3, -(A7)
   move.l  D3, -(A7)

   movea.l #$0003A648, A3 
   
   bsr boss_ai_targeting_proximity_start
   
   move.l (A7)+, D3
   movea.l (A7)+, A3

   tst.b D0
   
   rts
;================================================

;================================================
minor_enemy_pick_active:
  lea     (p3_main_mem,A5), A4
  moveq   #$4, D0

  tst.b   (A4)
  bne     minor_enemy_pick_active_end

  lea     (p2_main_mem,A5), A4
  moveq   #$2, D0

  tst.b   (A4)
  bne     minor_enemy_pick_active_end
  
  lea     (p2_main_mem,A5), A4
  moveq   #$1, D0

minor_enemy_pick_active_end:
  rts
;================================================
  
;================================================
; Belgar is a turd
;================================================

;------------------------------------------------
hijack_belgar_initialize:
  bsr boss_health_init_common
  move.w D1, D0
  lsl.w   #$1, D0 ; Multiply by 2!
  
  jmp $04EA30
;------------------------------------------------

;------------------------------------------------
hijack_belgar_update_player_position:
  bsr belgar_update_player_position
  jmp $04F076
;------------------------------------------------

;------------------------------------------------
hijack_belgar_update_a6_a8:
  tst.b   ($93,A6) ; Currently targeted player
  beq     hijack_belgar_update_a6_a8_p1

  cmpi.b  #$1, ($93,A6)
  beq     hijack_belgar_update_a6_a8_p2
  
  move.w  (p3_x_pos,A5), ($a6,A6)  ; $06, xpos
  move.w  (p3_y_pos_origin,A5), ($a8,A6)
  bra hijack_belgar_update_a6_a8_exit

hijack_belgar_update_a6_a8_p1:
  move.w  (p1_x_pos,A5), ($a6,A6)  ; $06, xpos
  move.w  (p1_y_pos_origin,A5), ($a8,A6)
  bra hijack_belgar_update_a6_a8_exit

hijack_belgar_update_a6_a8_p2:
  move.w  (p2_x_pos,A5), ($a6,A6)  ; $06, xpos
  move.w  (p2_y_pos_origin,A5), ($a8,A6)

hijack_belgar_update_a6_a8_exit:
  jmp $04F364
;------------------------------------------------

;------------------------------------------------
hijack_belgar_update_a8:
  tst.b   ($93,A6) ; Currently targeted player
  beq     hijack_belgar_update_a8_p1

  cmpi.b  #$1, ($93,A6)
  beq     hijack_belgar_update_a8_p2
  
  move.w  (p3_y_pos_origin,A5), ($a8,A6)  
  bra hijack_belgar_update_a8_exit

hijack_belgar_update_a8_p1:
  move.w  (p1_y_pos_origin,A5), ($a8,A6) 
  bra hijack_belgar_update_a8_exit

hijack_belgar_update_a8_p2:
  move.w  (p2_y_pos_origin,A5), ($a8,A6) 

hijack_belgar_update_a8_exit:
  jmp $04F6D4
;------------------------------------------------

;------------------------------------------------
belgar_update_player_position:
  tst.b   ($93,A6) ; Check currently targeted
  bne     belgar_update_player_position_p2

  bsr     belgar_target_p1
  rts

belgar_update_player_position_p2:
  cmpi.b  #$1, ($93,A6) ; Currently targeted
  bne     belgar_update_player_position_p3

  bsr     belgar_target_p2
  rts

belgar_update_player_position_p3:
  bsr     belgar_target_p3
  rts
;------------------------------------------------

;------------------------------------------------
hijack_belgar_target_other_player:
  tst.b   ($93,A6) ; Check currently targeted
  beq     hijack_belgar_target_other_player_p1

  cmpi.b #$1, ($93,A6) ; Currently targeted
  beq hijack_belgar_target_other_player_p2
  
  tst.b   (p3_main_mem,A5)
  beq     belgar_choose_active

  rts

hijack_belgar_target_other_player_p2:
  tst.b   (p2_main_mem,A5)
  beq     belgar_choose_active

  rts

hijack_belgar_target_other_player_p1:
  tst.b   (p1_main_mem,A5)
  beq     belgar_choose_active

  rts
;------------------------------------------------

;------------------------------------------------
hijack_belgar_active_or_y_origin_prox_check:
   move.l  A3, -(A7)
   movea.l #belgar_y_origin_prox_check, A3 
   bsr belgar_active_or_prox_check
   movea.l (A7)+, A3
   jmp $04F314
;------------------------------------------------

;------------------------------------------------
hijack_belgar_active_or_y_origin_prox_check_2:
   move.l  A3, -(A7)
   movea.l #belgar_y_origin_prox_check, A3 
   bsr belgar_active_or_prox_check
   movea.l (A7)+, A3
   jmp $04f6a6
;------------------------------------------------

;------------------------------------------------
hijack_belgar_active_or_x_prox_check:
   move.l  A3, -(A7)
   movea.l #belgar_x_prox_check, A3 
   bsr belgar_active_or_prox_check
   movea.l (A7)+, A3
   rts
;------------------------------------------------

;------------------------------------------------
hijack_belgar_active_or_C9_check:
   bsr get_player_count
   cmpi.b #$1, D1
   bne hijack_belgar_active_or_C9_check_do_C9
   
   bra belgar_choose_active

hijack_belgar_active_or_C9_check_do_C9:
   tst.b  (p1_main_mem_C9,A5) ; $C9 
   bne     belgar_target_p2

   tst.b  (p2_main_mem_C9,A5) ; $C9 
   bne     belgar_target_p3

   tst.b  (p3_main_mem_C9,A5) ; $C9 
   bne     belgar_target_p1

   bra hijack_belgar_active_or_x_prox_check
;------------------------------------------------

;------------------------------------------------
belgar_active_or_prox_check:
   bsr get_player_count
   cmpi.b #$1, D1
   bne belgar_active_or_prox_check_continue

   bsr belgar_choose_active
   bra hijack_belgar_active_or_prox_check_exit_no_push

belgar_active_or_prox_check_continue:
   move.l  A0, -(A7)
   move.l  D2, -(A7)
   move.l  D3, -(A7)
      
   bsr boss_ai_targeting_proximity_start
   
   tst.b D3
   beq belgar_active_or_prox_check_p1
 
   cmpi.b #$1, D3
   beq belgar_active_or_prox_check_p2

   bsr belgar_target_p3
   bra belgar_active_or_prox_check_exit
 
belgar_active_or_prox_check_p1:
   bsr belgar_target_p1
   bra belgar_active_or_prox_check_exit

belgar_active_or_prox_check_p2:
   bsr belgar_target_p2   
   
belgar_active_or_prox_check_exit:
   move.l (A7)+, D3
   move.l (A7)+, D2
   movea.l (A7)+, A0

hijack_belgar_active_or_prox_check_exit_no_push:
   rts
;------------------------------------------------

;------------------------------------------------
; Generic rewrite of $04F2F0
belgar_y_origin_prox_check:
  move.w  ($E,A0), D1
  sub.w   ($A,A6), D1
  bpl     belgar_prox_check_exit
  
  neg.w   D1

belgar_prox_check_exit:
  rts
;------------------------------------------------

;------------------------------------------------
; Generic rewrite of $04FCD4
belgar_x_prox_check:
  move.w  ($6,A0), D1
  sub.w   ($6,A6), D1
  bpl     belgar_x_prox_check_exit
  
  neg.w   D1

belgar_x_prox_check_exit:
  rts
;------------------------------------------------

;------------------------------------------------
hijack_belgar_active_or_random:
  bsr get_player_count
  cmpi.b #$1, D1
  beq hijack_belgar_active_or_random_active_check

  bsr belgar_choose_random
  bra hijack_belgar_active_or_random_exit

hijack_belgar_active_or_random_active_check:
  bsr belgar_choose_active
  
hijack_belgar_active_or_random_exit:
  jmp $04F314
;------------------------------------------------

;------------------------------------------------
hijack_belgar_prox_check:
  tst.b (p3_main_mem,A5)
  beq hijack_belgar_prox_check_p2

  move.w  (p3_x_pos,A5), D0 ; $06, xpos
  move.w  (p3_y_pos_origin,A5), D1 ; $0E, Y pos origin...

  jsr     $4fb26
  bne     hijack_belgar_prox_check_success
  
hijack_belgar_prox_check_p2:
  tst.b (p2_main_mem,A5)
  beq hijack_belgar_prox_check_p1

  move.w  (p2_x_pos,A5), D0 ; $06, xpos
  move.w  (p2_y_pos_origin,A5), D1 ; $0E, Y pos origin...

  jsr     $4fb26
  bne     hijack_belgar_prox_check_success

hijack_belgar_prox_check_p1:
  tst.b (p1_main_mem,A5)
  beq hijack_belgar_prox_check_fail

  move.w  (p1_x_pos,A5), D0 ; $06, xpos
  move.w  (p1_y_pos_origin,A5), D1 ; $0E, Y pos origin...

  jsr     $4fb26
  bne     hijack_belgar_prox_check_success

hijack_belgar_prox_check_fail:
  jmp $04FB46

hijack_belgar_prox_check_success:
  jmp $04FB42
;------------------------------------------------

;------------------------------------------------
belgar_choose_active:
  btst    #$0, ($546a,A5)
  beq     belgar_choose_active_p2

  bsr     belgar_target_p1
  rts

belgar_choose_active_p2:
  btst    #$1, ($546a,A5)
  beq     belgar_choose_active_p3

  bsr     belgar_target_p2
  rts

belgar_choose_active_p3:
  bsr     belgar_target_p3
  rts
;------------------------------------------------

;------------------------------------------------
belgar_choose_random:
   move.l  A0, -(A7)
   move.l  D0, -(A7)
   move.l  D1, -(A7)

   bsr choose_random_player

   tst.b D0
   bne belgar_choose_random_p2
   
   bsr belgar_target_p1
   bra belgar_choose_random_exit
   
belgar_choose_random_p2:
   cmpi.b #$1, D0
   bne belgar_choose_random_p3

   bsr belgar_target_p2
   bra belgar_choose_random_exit

belgar_choose_random_p3:
   bsr belgar_target_p3
   
belgar_choose_random_exit:
   move.l (A7)+, D1
   move.l (A7)+, D0
   movea.l (A7)+, A0
   rts
;------------------------------------------------

;------------------------------------------------
belgar_target_p1:
  jmp $04FD02

belgar_target_p2:
  jmp $04FCEE
  
belgar_target_p3:
  move.b  #$2, ($93,A6)
  move.w  (p3_x_pos,A5), ($86,A6) ; $06, xpos
  move.w  (p3_y_pos_origin,A5), ($88,A6) ; $0E, Y pos origin...
  rts
;------------------------------------------------

; BELGARRRRRRR
;================================================
