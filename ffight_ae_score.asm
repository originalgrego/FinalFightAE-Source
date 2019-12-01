 org $004D5E
   jmp hijack_level_init

 org $001A9E
   jmp hijack_score_calc
      
 org $0019E8
   jmp hijack_score_updates

 org 0x001AB6
   lea $908F8C.l, A2 ; p2 score position

 org $001AC2
   andi.w  #$3f, D1 ; Take off player 2/3 bit if there

; Bonus
 org $002114
   jmp hijack_bonus_score_draw

 org $00211E
   movea.l #$908514, A0 ; P1 bonus score position

 org $002136
   movea.l #$908C94, A0 ; P2 bonus score position

 org $01FF86
   jmp hijack_bonus_perfect_select_player
      
 org $0050B8 ; Don't subtract 1 from player id....
   nop
   nop
   
 org $0050E2
   jmp hijack_determine_bonus_stage_winner

 org $01FD54
   jmp bonus_draw_winner_text
   
 org $01FD86 
   jmp bonus_hide_winner_text
   
 org $01FDA4
   jmp bonus_draw_winner_text

 org $01FDB6
   jmp bonus_draw_winner_score
   
 org $01FEB4
   jmp hijack_hide_all_winner_text
   
 org $01FDDA
   jmp hijack_winner_score_countdown

 org $01FDFA  
   movea.l #$908524, A0 ; P1 winner score countdown position

 org $01FE1E
   movea.l #$908CA4, A0 ; P2 winner score countdown position

 org $01FE5E ; Don't redecide winner after adding up winner bonus points
   bra $01FE74

 org $01FC62
   jmp hijack_draw_final_bonus_scores_check_winner

 org $01FCB4 ; Don't draw the 1p indicator when drawing final bonus scores
   nop
   nop

 org $01FCE0 ; Don't draw the 2p indicator when drawing final bonus scores
   nop
   nop
   
 org $01FCB8
   movea.l #$908514, A0 ; P1 final bonus score position

 org $01FCCA
   movea.l #$908714, A0 ; P1 final bonus score position 2

 org $01FCE4
   movea.l #$908C94, A0 ; P2 final bonus score position

 org $01FCF6
   movea.l #$908E94, A0 ; P2 final bonus score position 2
   
 org $0200C0
   jmp hijack_bonus_time_points
   
; Bonus

; Car
 org $004F8A
   jmp hijack_bonus_stage_win_condition_checks

 org $054352
   jmp hijack_car_assign_points

 org $054524
   jmp hijack_car_assign_points

 org $0546C2
   jmp hijack_car_assign_points

 org $054346
   jmp hijack_add_destroyed_bonus_item_count ; Car left

 org $054518
   jmp hijack_add_destroyed_bonus_item_count ; Car right

 org $0546B6
   jmp hijack_add_destroyed_bonus_item_count ; Car front
; Car

; Glass
 org $004FFA
   jmp hijack_bonus_stage_win_condition_checks

 org $0530C4
   jmp hijack_glass_assign_points
   
 org $05304A
   jmp hijack_glass_assign_points
   
 org $053106
   jmp hijack_add_destroyed_bonus_item_count
; Glass
      
; Items, hit detection, etc

 org $009C26
   jmp score_assign_player_a6 ; Item pickup

 org $0066A2
   jmp score_assign_all_players
   
 org $006A54
   jmp score_assign_player_a0
   
 org $007B66
   jmp score_assign_player_a0
 
 org $00CF14
   jmp score_assign_player_a6
   
 org $00D142
   jmp score_assign_player_a6

 org $00D3A2
   jmp score_assign_player_a6

 org $00D81C
   jmp score_assign_player_a6
 
 org $00E942
   jmp score_assign_player_a6

 org $03CEAE
   jmp score_assign_enemy ; Hollywood's molotov


; Items, hit detection, etc
 
; Enemies

 org $021F56
   jmp check_score_assign_enemy_81 ; Bred and subtypes
   
 org $0282C0
   jmp check_score_assign_enemy_81 ; J and subtype

 org $02A4A6
   jmp check_score_assign_enemy_81 ; Axel and subtype   
   
 org $02CE58
   jmp check_score_assign_enemy_b0 ; Andores

 org $0327CA ; Oriber and subtypes, need to nop out the assign all players points check, handled later
   nop
   nop
   nop
   
 org $0327DA
   jmp check_score_assign_enemy_a3 ; Oriber and subtypes
   
 org $036346
   jmp score_assign_enemy ; Hollywood and subtype
  
 org $03A18E ; Roxy and Poison, need to nop out the assign all players points check, handled later
   nop
   nop
   nop
     
 org $03A19E
   jmp check_score_assign_enemy_a2 ; Roxy and Poison
   
; Enemies

; Bosses
  
 org $03ECD0
   jmp score_assign_enemy_no_minus_check ; Damned
  
 org $0426A6
   jmp score_assign_enemy_no_minus_check ; Sodom
   
 org $04777A
   jmp score_assign_enemy_no_minus_check ; Edi E

 org $04A0A2
   jmp score_assign_enemy ; Rolento

 org $04D4F6
   jsr score_assign_enemy_no_minus_check ; Abigail
   jmp $1b3e4.l ; Copied from $04D504

 org $04FA10
   jsr score_assign_enemy_no_minus_check ; Belgar
   jmp $bda.w ; Copied from $04FA1E

; Bosses

; Breakable Objects

 org $05170A
   jmp score_assign_enemy_no_minus_check ; Doors
 
 org $051978
   jsr score_assign_enemy ; Metal Barrel
   bra $051988

 org $0520BE
   jmp score_assign_enemy_no_minus_check ; Unknown, method handled minus before this

 org $052390
   jmp score_assign_enemy_no_minus_check ; Wood Crate

 org $05254C
   jmp score_assign_enemy_no_minus_check ; Trash Can

 org $0527CE
   jmp score_assign_enemy_no_minus_check ; Wood Barrel

 org $052A98
   jmp score_assign_enemy_no_minus_check ; Tires

 org $052E1E
   jmp score_assign_enemy_no_minus_check ; Telephone Booth

 org $05396C
   jmp score_assign_enemy_no_minus_check ; Metal Barrels 2

 org $0552B6
   jmp score_assign_enemy_no_minus_check ; Belgars Chair

 org $05971C
   jmp score_assign_enemy_no_minus_check ; Unknown 2
; Breakable Objects
