;================================================
playerscroll_calc_min:
  move.w (A3), D2
  beq exit_min

  move.w ($06, A3), D2
  move.w ($7FF8, A5), D0
  cmp.w D2, D0
  bpl update_min

exit_min:  
  rts
  
update_min:
  move.w d2, ($7FF8, A5)
  rts
;================================================

;================================================
playerscroll_calc_max:
  move.w (A3), D2
  beq exit_max
  
  move.w ($06, A3), D2
  move.w ($7FFA, A5), D0
  cmp.w D2, D0
  bmi update_max
  
exit_max:
  rts
  
update_max:
  move.w d2, ($7FFA, A5)
  rts
;================================================

;================================================
hijack_playerscroll_0:
  move.w  #$7FFF, ($7FF8, A5)
  move.w  #$0, ($7FFA, A5)

  lea (p1_main_mem, A5), A3
  bsr playerscroll_calc_min
  bsr playerscroll_calc_max

  lea (p2_main_mem, A5), A3
  bsr playerscroll_calc_min
  bsr playerscroll_calc_max

  lea (p3_main_mem, A5), A3
  bsr playerscroll_calc_min
  bsr playerscroll_calc_max
  
playerscroll_0_multiplayer:
  moveq   #$0, D2 ; Clear d2

  move.w  ($7FFA, A5), D0 ; Max xpos 
  bmi     playerscroll_0_multiplayer_return

  sub.w   ($6,A6), D0 ; Subtract level xpos from max xpos 
  subi.w  #$d0, D0 ; Check if max in scrollzone 
  bls     playerscroll0_multiplayer_2ptest ; Branch if 1P is in deadzone 

  ori.b   #$1, D2 ; Set bit if 1p in scrollzone 

playerscroll0_multiplayer_2ptest:
  move.w  ($7FF8, A5), D1 ; Load min xpos 
  bmi     playerscroll_0_multiplayer_return

  sub.w   ($6,A6), D1 ; Subtract level xpos from 2p xpos 
  subi.w  #$d0, D1 ; Check if 2P in scrollzone 
  bls     playerscroll0_multiplayer_testresults ; playerscroll0_multiplayer_testresults ; Branch if 2P is in deadzone 

  ori.b   #$2, D2 ; Set bit if 2P in scrollzone 

playerscroll0_multiplayer_testresults:
  cmp.b   #$00, D2
  bne     playerscroll0_multiplayer_takeaction

  bra     playerscroll_0_multiplayer_return 

playerscroll0_multiplayer_takeaction:
  move.w  ($7FF8, A5), D1 ; Straggler's xpos 
  bmi     playerscroll_0_multiplayer_return 

  sub.w   ($6,A6), D1 ; Level's xpos 
  subi.w  #$40, D1 ; '@' 
  bcs     playerscroll_0_multiplayer_return ;  Return if straggler is too far to the left to scroll 

  cmpi.w  #$4, D0
  bcs     playerscroll0_multiplayer_applyscroll ;  Branch if Leader's scrollzone distance is less than 4 

  cmpi.w  #$4, D1
  bcs     playerscroll0_multiplayer_takeaction_straggler ;  Branch if Leader's scrollzone progress is 4 or greater, but straggler's is less than 4 

  move.w  #$4, D1 ; If both players are 4 pixels into scrollzone or further, set so only 4 pixels will be added to scroll 

playerscroll0_multiplayer_takeaction_straggler:
  move.w  D1, D0 ; Prioritize straggler's scrollzone distance so screen doesn't scroll too far. 

playerscroll0_multiplayer_applyscroll:
  move.w  ($6,A6), D2 ; Load level's xpos 
  add.w   D0, ($6,A6) ; Add prioritized scroll var to level xpos 
  move.w  ($2a,A6), D1
  cmp.w   ($6,A6), D1 ; Compare level's xpos to upper limit 
  bhi     playerscroll0_multiplayer_applyscroll_withinlimit ; Branch if within limit 

  move.w  ($2a,A6), ($6,A6) ; If scroll goes past limit, set limit as xpos 
  sub.w   D2, D1 ; Subtract old level xpos from limit 
  move.w  D1, ($26,A6)
  move.b  #$4, ($20,A6)
  rts

playerscroll0_multiplayer_applyscroll_withinlimit:
  move.w  D0, ($26,A6)
  move.b  #$4, ($20,A6)

playerscroll_0_multiplayer_return:
  rts
;================================================

;================================================
hijack_playerscroll_2:
  move.w  #$7FFF, ($7FF8, A5)
  move.w  #$0, ($7FFA, A5)

  lea (p1_main_mem, A5), A3
  bsr playerscroll_calc_min
  bsr playerscroll_calc_max

  lea (p2_main_mem, A5), A3
  bsr playerscroll_calc_min
  bsr playerscroll_calc_max

  lea (p3_main_mem, A5), A3
  bsr playerscroll_calc_min
  bsr playerscroll_calc_max
  
  move.w  ($7FF8, A5), D1 ; Min xpos 
  move.w  ($7FFA, A5), D0 ; Max xpos 
  
  jmp $062128
;================================================
