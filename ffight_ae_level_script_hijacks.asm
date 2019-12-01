;====================================================================
hijack_level_script_two_player_check:
  move.l  D1, -(A7)

  jsr get_player_count
  move.l  D1, D0
  
  move.l (A7)+, D1
  
  cmpi.b #$1, D0
  beq hijack_level_script_two_player_check_single_player
  
  jmp $0062D8 ; More than one player
  
hijack_level_script_two_player_check_single_player:
  jmp $0062DC
;====================================================================



