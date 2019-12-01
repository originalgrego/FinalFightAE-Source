 org 0x001D78
	jmp hijack_player_namebar	

 org 0x001E20
   jmp hijack_draw_lives_click_in_gameplay

 org 0x001EC8
   jmp hijack_p2_health_bar_full
 
 org 0x001E96
   lea $90878c.l, A1 ; p1 extra life position
 
 org 0x001E86
   rts ; Don't draw the equal sign
   
 org 0x001EB2
	jmp hijack_p1_draw_health_icon
 
 org 0x001EEE
   jmp hijack_p2_draw_health_bar
   
 org 0x001EE0
   jmp hijack_p2_draw_health_icon
 
 ; Fix p3's character portrait
 org 0x05B5FA
   jmp hijack_character_portrait_calc 
   
;================================================
; Scale health bars
 org 0x001F34
   move.w  #$B, D5  
   
 org 0x001FFA
   move.w  #$B, D0
   
 org 0x001F38
   jmp scale_health_for_health_bar_draw
;================================================
  
   
 org 0x002884
   jmp hijack_item_target_queue_check
   
 org 0x002896
   bra hijack_smash_hit_item_target_check

;====================================================
 org 0x002900
   jmp hijack_pvp_target_queue
  
hijack_smash_hit_item_target_check:
   jmp hijack_smash_hit_item_target_check_impl

   ; Free space to 00295D
;====================================================

 org 0x002870
   jmp hijack_throw_enemy_target_check

 org 0x00287C
   jmp hijack_after_enemy_throw_target_check
   
 org 0x05B1E8
   jmp hijack_p12_score_and_target_selector

 org 0x05B2B0
   move.l  #$908D18, D1 ; P2 target health bar position

 org 0x05B474  
   move.w  #$c, D5 ; Only erase $c bar sections
;=============================================
 org 0x05B368
    jmp hijack_player_check_target_queue_handler

