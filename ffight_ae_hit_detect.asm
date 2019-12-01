
;====================================================
; Hijack generate player 2 hitbox data
 org 0x00337A 
   jmp hijack_generate_player_2_hitbox_data
;====================================================

;====================================================
; PLAYER VS PLAYER HIT DETECTION!!!!

 org 0x007728
   jmp hijack_pvp_collision_check

 org 0x00777C
   rts
;====================================================

 org 0x007032
   jmp hijack_player_2_update_hitbox_data


   
;====================================================
 org 0x008ED8
   jmp hijack_pvp_pushing
   
 org 0x009040
   move.b  ($14,A3), D0 ; 14
 org 0x00904E
   move.b  ($14,A4), D0 ; 14

 org 0x009062
   move.w  ($0E,A3), D2 ; 0E
 org 0x009066
   move.w  ($0E,A4), D3 ; 0E

 org 0x009088
   move.w  ($06,A3), D2 ; 06
 org 0x00908C
   move.w  ($06,A4), D3 ; 06
;====================================================
   
;====================================================
; Weapon handling
;====================================================
   
 org 0x0067B4 
   jmp hijack_enemy_weapon_hit_detect

 org 0x0067C0
   jmp hijack_weapon_target_other_players_hit_detect

 org 0x006820
   jmp hijack_weapon_target_iterator
  
 org 0x0068D6  
   jmp hijack_enemy_weapon_hit_detect_2
  
 org 0x0068E2
   jmp hijack_player_thrown_weapon_hit_detect
   
 org 0x006918
   jmp hijack_boss_thrown_weapon_hit_detect

 org 0x006938
   jmp hijack_boss_thrown_weapon_hit_detect
   
 org 0x0069A4
   jmp hijack_weapon_target_iterator_2
;====================================================

  
