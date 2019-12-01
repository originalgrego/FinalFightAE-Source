;================================================
hijack_pvp_collision_check:
  moveq #$0, D0

  or.w    ($530a,A5), D0
  or.w    ($5372,A5), D0
  or.w    ($7372,A5), D0

  beq     hijack_pvp_collision_check_exit

  move.w  ($5c2,A5), D0
  sne     D0

  move.w  ($682,A5), D1
  sne     D1

  eor.b   D0, D1
  
  move.w  ($6742,A5), D1
  sne     D0
  
  eor.b   D0, D1

  bne     hijack_pvp_collision_check_exit

  jmp     pvp_collision_detect
  
hijack_pvp_collision_check_exit:
  jmp $0077a0
;================================================

;================================================
pvp_collision_detect: ; Need to add some handling here for p3, he's reusing p2's value #$80 for score keeping
   ; P1/P2
   lea     (p1_main_mem,A5), A1
   lea     (p2_main_mem,A5), A3
   lea     ($5302,A5), A0
   
   jsr     $0077a2
   bne     pvp_collision_detect_p2_p1
   
   moveq   #$0, D6 ; Player 1
   bsr     pvp_collision_detect_check_success
   beq     pvp_collision_detect_p2_p1
   
   jsr     $0077ec
   
pvp_collision_detect_p2_p1:
   lea     (p2_main_mem,A5), A1
   lea     (p1_main_mem,A5), A3
   lea     ($536a,A5), A0

   jsr     $0077a2
   bne     pvp_collision_detect_p1_p3
   
   move.l   #$80, D6 ; Player 2
   bsr     pvp_collision_detect_check_success
   beq     pvp_collision_detect_p1_p3
   
   jsr     $0077ec

pvp_collision_detect_p1_p3:
   lea     (p1_main_mem,A5), A1
   lea     (p3_main_mem,A5), A3
   lea     ($5302,A5), A0

   jsr     $0077a2
   bne     pvp_collision_detect_p3_p1
   
   moveq   #$0, D6 ; Player 1
   bsr     pvp_collision_detect_check_success
   beq     pvp_collision_detect_p3_p1
   
   jsr     $0077ec

pvp_collision_detect_p3_p1:
   lea     (p3_main_mem,A5), A1
   lea     (p1_main_mem,A5), A3
   lea     ($736a,A5), A0

   jsr     $0077a2
   bne     pvp_collision_detect_p2_p3
   
   move.l   #$C0, D6 ; Player 3
   bsr     pvp_collision_detect_check_success
   beq     pvp_collision_detect_p2_p3
   
   jsr     $0077ec

pvp_collision_detect_p2_p3:
   lea     (p2_main_mem,A5), A1
   lea     (p3_main_mem,A5), A3
   lea     ($536a,A5), A0

   jsr     $0077a2
   bne     pvp_collision_detect_p3_p2
   
   move.l   #$80, D6 ; Player 2
   bsr     pvp_collision_detect_check_success
   beq     pvp_collision_detect_p3_p2
   
   jsr     $0077ec
   
pvp_collision_detect_p3_p2:
   lea     (p3_main_mem,A5), A1
   lea     (p2_main_mem,A5), A3
   lea     ($736a,A5), A0

   jsr     $0077a2
   bne     pvp_collision_detect_exit
   
   move.l   #$C0, D6 ; Player 3
   bsr     pvp_collision_detect_check_success
   beq     pvp_collision_detect_exit
   
   jsr     $0077ec

pvp_collision_detect_exit:   
   rts
;================================================

;================================================
pvp_collision_detect_check_success:
  move.w  ($74,A1), (-$6e28,A5)
  move.w  ($76,A1), (-$6e24,A5)
  jsr     $007888

  move.w  ($74,A1), (-$6e28,A5)
  move.w  ($76,A1), (-$6e24,A5)
  jmp     $0078f4 ; Targeting logic
;================================================

;================================================
hijack_generate_player_2_hitbox_data:
   lea     (p2_main_mem,A5), A0
   lea     ($536a,A5), A1
   lea     ($53a2,A5), A2
   jsr      $00338a

   ; Create player 3 hitbox data yo
   lea     (p3_main_mem,A5), A0
   lea     ($736a,A5), A1 
   lea     ($73a2,A5), A2
   jmp      $00338a
;================================================

;================================================
hijack_player_2_update_hitbox_data:
   
   move.w  #$15, ($536a,A5)
   move.l  #$ffd36a, ($536c,A5)
   move.w  #$15, ($53a2,A5)
   move.l  #$ffd3a2, ($53a4,A5)

 ; Player 3 vs enemy hit detect  
   lea     (p3_main_mem,A5), A1
   lea     ($736a,A5), A6

   move.w  #$15, D7
   sub.w   ($736a,A5), D7
   beq     evp3_hit_detect

   move.w  ($74,A1), (-$6e28,A5)
   move.w  ($76,A1), (-$6e24,A5)
   tst.l   ($70,A1)
   beq     evp3_hit_detect

   move.w  #$C0, D6 ; P3 uses the top two bits for score assignment (p1-00, p2-80)
   subq.w  #1, D7

pve3_loop:
   movea.w -(A6), A3

   jsr     $007050

   move.w  #$0, (A6)
   dbra    D7, pve3_loop

; Enemy vs Player 3 hit detect
evp3_hit_detect:
   lea     (p3_main_mem,A5), A3
   lea     ($73a2,A5), A6

   move.w  #$15, D7
   sub.w   ($73a2,A5), D7
   beq     evp3_exit

   tst.l   ($78,A3)
   beq     evp3_exit

   move.w  #$C0, D6 ; P3 uses the top two bits for score assignment
   subq.w  #1, D7

evp3_loop:
   movea.w -(A6), A1
   move.w  ($74,A1), (-$6e28,A5)
   move.w  ($76,A1), (-$6e24,A5)
   jsr     $007526

   move.w  #$0, (A6)
   dbra    D7, evp3_loop
   
evp3_exit:
   move.w  #$15, ($736a,A5)
   move.l  #$fff36a, ($736c,A5)
   move.w  #$15, ($73a2,A5)
   move.l  #$fff3a2, ($73a4,A5)

   jmp $00704E
;================================================

;================================================
hijack_pvp_pushing:
   move.l  A3, -(A7)
   move.l  A4, -(A7)
   
   lea (p1_main_mem,A5), A3
   lea (p2_main_mem,A5), A4
   
   bsr pvp_pushing
   
   lea (p1_main_mem,A5), A3
   lea (p3_main_mem,A5), A4
   
   bsr pvp_pushing

   lea (p2_main_mem,A5), A3
   lea (p3_main_mem,A5), A4

   bsr pvp_pushing

   movea.l (A7)+, A4
   movea.l (A7)+, A3

   rts

; Pvp collision detection, generic version of 008ED8 using a3/a4 for the player 1/2
pvp_pushing:
  clr.b   ($8F,A3) ; 8F
  clr.b   ($8F,A4) ; 8F
  clr.b   ($A8,A3) ; A8
  clr.b   ($A8,A4) ; A8

  move.b  ($14,A3), ($8D,A4) ; p1 $14 to p2 $8D 
  move.b  ($14,A4), ($8D,A3) ; p2 $14 to p1 $8D

  move.b  (A3), D0 
  and.b   (A4), D0
  beq     pvp_pushing_exit ; If both players arent active

  cmpi.b  #$2, ($02,A3) ; $02
  bne     pvp_pushing_exit ; If player 1 isnt in game play state

  cmpi.b  #$2, ($02,A4) ; $02
  bne     pvp_pushing_exit ; If player 2 isnt in game play state

  move.w  ($0A,A3), D0 ; 0A
  cmp.w   ($0E,A3), D0 ; 0E
  bne     pvp_pushing_exit ; If player 1 hasn't left the origin

  move.w  ($0A,A4), D0 ; 0A
  cmp.w   ($0E,A4), D0 ; 0E
  bne     pvp_pushing_exit ; If player 2 hasn't left the origin

  tst.w   ($5A,A3) ; 5A
  sne     D0 

  tst.w   ($5A,A4) ; 5A
  sne     D1

  eor.b   D0, D1
  bne     pvp_pushing_exit ; If both of them are pushing each other?

  bsr     pvp_pushing_determine_push ; Actually do some pushing

; Exit for collision, collision didnt happen
pvp_pushing_exit:
   lea     ($8F,A3), A1 ; 8F
   jsr     $008f4a

   lea     ($8F,A4), A1 ; 8F
   jmp     $008f4a

; Determine type of player collision
pvp_pushing_determine_push:
  jsr     $00903a
  bcs     pvp_pushing_handle_push ; If carry set... thats a good thing?

  rts

pvp_pushing_handle_push:
  cmpi.w  #$4, D6
  bhi     pvp_pushing_handle_push_b1
  bra     pvp_pushing_push_x ; Handle x collision

pvp_pushing_handle_push_b1:
  cmpi.w  #$2, D7
  bhi     pvp_pushing_handle_push_b2
  bra     pvp_pushing_push_y ; Handle y collision

pvp_pushing_handle_push_b2:
  cmp.w   D6, D7
  bcs     pvp_pushing_push_y ; Handle y collision

; Player collision X
pvp_pushing_push_x:
  swap    D6
  lsr.l   #1, D6

  move.w  ($06,A3), D0 ; 06
  cmp.w   ($06,A4), D0 ; 06
  bls     pvp_pushing_push_x_b1

  bset    #$1, ($8F,A3) ; 8F
  bset    #$0, ($8F,A4) ; 8F
  ori.b   #$2, ($A8,A3) ; A8
  ori.b   #$1, ($A8,A4) ; A8
  add.l   D6, ($06,A3) ; 06
  sub.l   D6, ($06,A4) ; 06
  rts

pvp_pushing_push_x_b1:
  bset    #$0, ($8F,A3) ; 8F
  bset    #$1, ($8F,A4) ; 8F
  ori.b   #$1, ($A8,A3) ; A8
  ori.b   #$2, ($A8,A4) ; A8
  sub.l   D6, ($06,A3) ; 06
  add.l   D6, ($06,A4) ; 06
  rts

; Player collisions Y
pvp_pushing_push_y:
  swap    D7
  lsr.l   #1, D7

  move.w  ($0E,A3), D0 ; 0E
  cmp.w   ($0E,A4), D0 ; 0E
  bls     pvp_pushing_push_y_b1

  bset    #$2, ($8F,A3) ; 8F
  bset    #$3, ($8F,A4) ; 8F
  ori.b   #$4, ($A8,A3) ; A8
  ori.b   #$6, ($A8,A4) ; A8
  add.l   D7, ($0E,A3) ; 0E
  add.l   D7, ($0A,A3) ; 0A
  sub.l   D7, ($0E,A4) ; 0E
  sub.l   D7, ($0A,A4) ; 0A
  rts

pvp_pushing_push_y_b1:
  bset    #$3, ($8F,A3) ; 8F
  bset    #$2, ($8F,A4) ; 8F
  ori.b   #$6, ($A8,A3) ; A8
  ori.b   #$4, ($A8,A4) ; A8
  sub.l   D7, ($0E,A3) ; 0E
  sub.l   D7, ($0A,A3) ; 0A
  add.l   D7, ($0E,A4) ; 0E
  add.l   D7, ($0A,A4) ; 0A
  rts
;================================================

;================================================
storeAndLoadA1Address macro
   move.l A1, temp_var_0 ; Store new index
   movea.l (A1), A1       ; Load address at index
   endm
;================================================

;================================================
storeAndLoadA3Address macro
   move.l A3, temp_var_1 ; Store new index
   movea.l (A3), A3       ; Load address at index
   endm
;================================================

;================================================
prepA1AddressAndCounterHitDetect macro location,count
  movea.l #location, A1
  storeAndLoadA1Address
  move.w  #count, D6
  endm
;================================================

;================================================
prepA3AddressAndCounterHitDetect macro location,count
  movea.l #location, A3
  storeAndLoadA3Address
  move.w  #count, D6
  endm
;================================================

;================================================
test_players_weapon_hit_detect_prep_A1:
  prepA1AddressAndCounterHitDetect player_mem_loc_table, $2 ; Try all three players
  rts
;================================================

;================================================
test_players_weapon_hit_detect_prep_A3:
  prepA3AddressAndCounterHitDetect player_mem_loc_table, $2 ; Try all three players
  rts
;================================================

;================================================
test_enemies_weapon_hit_detect_prep:
  prepA3AddressAndCounterHitDetect enemy_mem_loc_table, $c ; Try all normal enemies
  rts
;================================================

;================================================
test_bosses_weapon_hit_detect_prep:
  prepA3AddressAndCounterHitDetect boss_mem_loc_table, $7 ; Try all normal enemies
  rts
;================================================

;================================================
hijack_enemy_weapon_hit_detect:
  bsr test_players_weapon_hit_detect_prep_A1
  jmp $0067d6
;================================================

;================================================
hijack_enemy_weapon_hit_detect_2:
  bsr test_players_weapon_hit_detect_prep_A3
  jmp $006956
;================================================

;================================================
weapon_target_other_players_hit_detect_prep_A1:
   btst #$1, ($13,A0)
   beq  target_other_players_check_p2
   
   movea.l #player_mem_loc_iterator_start_p1, A1
   bra target_other_players_exit

target_other_players_check_p2:
   btst #$0, ($13,A0)
   beq  target_other_players_p1
   
   movea.l #player_mem_loc_iterator_start_p3, A1
   bra target_other_players_exit
   
target_other_players_p1:
   movea.l #player_mem_loc_iterator_start_p2, A1

target_other_players_exit:
   storeAndLoadA1Address
   move.w  #$1, D6 ; Check the other two players
   rts
;================================================

;================================================
weapon_target_other_players_hit_detect_prep_A3:
   btst #$1, ($13,A0)
   beq  target_other_players_check_p2_A3
   
   movea.l #player_mem_loc_iterator_start_p1, A3
   bra target_other_players_A3_exit

target_other_players_check_p2_A3:
   btst #$0, ($13,A0)
   beq  target_other_players_p1_A3
   
   movea.l #player_mem_loc_iterator_start_p3, A3
   bra target_other_players_A3_exit
   
target_other_players_p1_A3:
   movea.l #player_mem_loc_iterator_start_p2, A3

target_other_players_A3_exit:
   storeAndLoadA3Address
   move.w  #$1, D6 ; Check the other two players
   rts
;================================================

;================================================
hijack_weapon_target_other_players_hit_detect:
   bsr weapon_target_other_players_hit_detect_prep_A1
   jmp $0067d6
;================================================

;================================================
hijack_player_thrown_weapon_hit_detect:
   bsr weapon_target_other_players_hit_detect_prep_A3
   jsr $006956
   bne player_thrown_weapon_check_exit
   
   bsr test_enemies_weapon_hit_detect_prep
   jsr $006956
   bne player_thrown_weapon_check_exit
   
   bsr test_bosses_weapon_hit_detect_prep
   jsr $006956

player_thrown_weapon_check_exit:
   rts
;================================================

;================================================
hijack_boss_thrown_weapon_hit_detect:
   bsr test_players_weapon_hit_detect_prep_A3
   jsr $006956
   bne boss_thrown_weapon_check_exit
   
   bsr test_enemies_weapon_hit_detect_prep
   jsr $006956
   bne boss_thrown_weapon_check_exit

   moveq #$0, D0
   
boss_thrown_weapon_check_exit:
   rts
;================================================

;================================================
hijack_weapon_target_iterator:
   movea.l temp_var_0, A1 ; Get last index
   lea ($04,A1), A1   ; Increment index a long word
   storeAndLoadA1Address

   dbra D6, hijack_weapon_target_iterator_continue
   jmp $0066d6

hijack_weapon_target_iterator_continue:
   jmp $0067d6
;================================================

;================================================
hijack_weapon_target_iterator_2:
   movea.l temp_var_1, A3 ; Get last index
   lea ($04,A3), A3   ; Increment index a long word
   storeAndLoadA3Address

   dbra D6, hijack_weapon_target_iterator_2_continue
   jmp $0066d6

hijack_weapon_target_iterator_2_continue:
   jmp $006956
;================================================
