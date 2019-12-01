;============================
p1_main_mem = $568

p1_x_pos = $56e

p1_y_pos_origin = $576

p1_main_mem_C9 = $5f1

p1_bonus_score_start = $568a
p1_bonus_score_after = $568e

p1_bonus_items_destroyed = $5692
;============================

;============================
p2_main_mem = $628

p2_x_pos = $62e

p2_y_pos_origin = $636

p2_main_mem_C9 = $6b1

p2_bonus_score_start = $568e
p2_bonus_score_after = $5692

p2_bonus_items_destroyed = $5693
;============================

;============================
p3_main_mem = $66e8

p3_x_pos = $66ee
p3_y_pos = $66F2

p3_y_pos_origin = $66F6

p3_main_mem_C9 = $67B1

p3_score_start = $676C
p3_score_after = $6770

p3_main_target_queue_data = $7740
p3_main_target_queue_data_play_id = $77C8
p3_main_target_queue_data_play_mem_ref = $777C

p3_target_queue_head_offset = $7680
p3_target_queue_tail_offset = $7682
p3_target_queue_offset = $7690

p3_start_button_fifo = $7f30

p3_bonus_score_start = $7f00
p3_bonus_score_start_2 = $7f02
p3_bonus_score_after = $7f04

p3_bonus_items_destroyed = $7f04

p3_enemy_grouping_data = $7900
;============================

top_score = $a0 ; ($a0, A5) or $80a0

game_paused = $7fDF

playerpalette_selection_pending_1p = $ffffffE0
playerpalette_selection_pending_2p = $ffffffE1
playerpalette_selection_pending_3p = $ffffffE2

playerpalette_selection_current_1p = $ffffffE3
playerpalette_selection_current_2p = $ffffffE4
playerpalette_selection_current_3p = $ffffffE5

temp_var_0 = $fffffff0
temp_var_1 = $fffffff4
temp_var_2 = $fffffff8
temp_var_3 = $fffffffc

 include "ffight_ae_input.asm"
 include "ffight_ae_init_player.asm"
 include "ffight_ae_sim.asm"
 include "ffight_ae_hit_detect.asm"
 include "ffight_ae_ai_targeting.asm"
 include "ffight_ae_scroll.asm"
 include "ffight_ae_introdemos.asm"
 include "ffight_ae_middledemos.asm"
 include "ffight_ae_outrodemos.asm"
 include "ffight_ae_string_scripts.asm"
 include "ffight_ae_top_entity.asm"
 include "ffight_ae_uncensored_intro.asm"
 include "ffight_ae_health_bar.asm"
 include "ffight_ae_charsel.asm"
 include "ffight_ae_dynamite_scene.asm"
 include "ffight_ae_score.asm"
 include "ffight_ae_graffiti_credits.asm"
 include "ffight_ae_title_screen.asm"
 include "ffight_ae_level_script.asm"
 include "ffight_ae_playericons.asm"

;=================================================
 ; INTRO
 ; Remove three barrels from intro
 org $06EC14
   dc.w $0030
 
 ; Reinserting the object that handles palette masking
 org $06ec44 
   dc.w $0000, $0518, $00B8, $0801, $0300, $0000, $0000 
;=================================================

 org 0x004E5E
   jmp hijack_check_players_alive

; Draw the player!?!?!
 org 0x008C44 
   jmp hijack_player_2_draw

; Calculate player status
 org 0x061D5E 
   jmp hijack_calc_player_status
   
 org 0x053F48
   jmp fix_bonus_crash
  
;================================================
; Game timer
 org 0x005562
   movea.l #$909070, A0 ; Move the time to the bottom of the screen
   
 org 0x00120E ; Dont draw the word time...
   nop
   nop
   
 org 0x004E70
   jmp hijack_end_of_level
   
 org 0x00523E
   jmp hijack_gameplay_timeout_handler
;================================================
  
;================================================
; Initial entry
 org $0151E4
  jmp hijack_initial_entry_start_draw_pos

 org $0152AE
  jmp hijack_initial_entry_hide_initial

 org $0152D0
  jmp hijack_initial_entry_show_initial

 org $0151EE  
  move.w  #$4, D5 ; Reduce number of characters when initial entry is drawn

 org $0151B0
  jmp hijack_inital_entry_erase
;================================================

; Disable warning screen
 org $000C68
  nop
  nop

 org 0x068166
 incbin "strings_binaries\final_fight_strings_p1_p2.bin" ; Overwrite main string table
  
 org 0x0d5838 ; empty space
 
 include "ffight_ae_input_hijacks.asm"
 include "ffight_ae_init_player_hijacks.asm"
 include "ffight_ae_sim_hijacks.asm"
 include "ffight_ae_hit_detect_hijacks.asm"
 include "ffight_ae_string_scripts_hijacks.asm"
 include "ffight_ae_top_entity_hijacks.asm"
 include "ffight_ae_health_bar_hijacks.asm"
 include "ffight_ae_ai_targeting_hijacks.asm"
 include "ffight_ae_scroll_hijacks.asm"
 include "ffight_ae_introdemos_hijacks.asm"
 include "ffight_ae_middledemos_hijacks.asm"
 include "ffight_ae_outrodemos_hijacks.asm"
 include "ffight_ae_charsel_hijacks.asm"
 include "ffight_ae_dynamite_scene_hijacks.asm"
 include "ffight_ae_score_hijacks.asm"
 include "ffight_ae_title_screen_hijacks.asm"
 include "ffight_ae_level_script_hijacks.asm"
 include "ffight_ae_playericons_hijacks.asm"
 
;================================================
hijack_player_2_draw:
   lea     (p2_main_mem,A5), A6
   jsr     $008d86
   jsr     $008c80
   
   lea     ($536a,A5), A4
   jsr     $008d32

   lea     (p3_main_mem,A5), A6
   jsr     $008d86
   jsr     $008c80   

   lea     ($736a,A5), A4
   jsr     $008d32
   
   jmp $008C58
;================================================
   
;================================================
hijack_00A464:

   lea     (p2_main_mem,A5), A4
   jsr     $a46e
 
   lea     (p3_main_mem,A5), A4
   jsr     $a46e

   jmp $00A46C
;================================================
     
;================================================
hijack_00BD36:
   lea     (p2_main_mem,A5), A0
   move.w  #$0, D1 
   jsr     $00bd6e
   bne     exit_hijack_00BD36
 
   lea     (p3_main_mem,A5), A0
   move.w  #$0, D1 
   jsr     $00bd6e
   bne     exit_hijack_00BD36

   jmp $00BD44
   
exit_hijack_00BD36:
	jmp $00BD6C
;================================================
 
;================================================
hijack_check_players_alive:
   move.b  (p1_main_mem,A5), D0 ; Players alive check
   or.b    (p2_main_mem,A5), D0
   or.b    (p3_main_mem,A5), D0

   jmp $004E66
;================================================

;================================================
hijack_calc_player_status:
   move.b  (p1_main_mem,A5), D0
   andi.b  #$1, D0
   
   move.b  (p2_main_mem,A5), D1
   andi.b  #$1, D1
   lsl.b   #1, D1

   add.b   D1, D0

   move.b  (p3_main_mem,A5), D1
   andi.b  #$1, D1
   lsl.b   #2, D1

   add.b   D1, D0

   jmp $061D6A
;================================================
 
;================================================
hijack_end_of_level:
   addq.b  #1, ($bf,A5) ; Increment sub level id
   jsr     $5476 ; Get end of level sub level id, placed in d0
  
   move.l D0, -(A7) ; Save d0

   movea.l #$908F70, A1 ; Timer position
   move.w  #$4, D4
   move.w  D4, temp_var_0
   jsr clear_scroll_1
   
   move.l (A7)+, D0 ; Restore d0

   jmp $004E78
;================================================

;================================================
hijack_gameplay_timeout_handler:
  lea (p2_main_mem,A5), A0
  jsr $525a ; Check if player should be killed on time out

  lea (p3_main_mem,A5), A0
  jsr $525a ; Check if player should be killed on time out

  jmp $005246
;================================================
 
;================================================
fix_bonus_crash:
  move.b  ($546a,A5), D0
  and.b   #$3, D0
  add.w   D0, D0
  jmp $053F4E
;================================================


;================================================
; Initial entry
hijack_initial_entry_start_draw_pos:
  bsr initial_entry_start_pos_calc
  jmp $0151EE

;---------------------------------------------

hijack_initial_entry_show_initial:
  bsr initial_entry_pos_calc
  jmp $0152DA

;---------------------------------------------

hijack_initial_entry_hide_initial:
  bsr initial_entry_pos_calc
  jmp $0152B8

;---------------------------------------------

initial_entry_start_pos_calc:
  moveq #$0, D1
  move.b ($0,A6), D1 ; Load player id
  lsl.w #2, D1
  movea.l initial_entry_start_pos_table(pc,d1.w), A0
  rts

;---------------------------------------------
  
initial_entry_pos_calc:
  moveq #$0, D1
  move.b ($0,A6), D1 ; Load player id
  lsl.w #2, D1
  movea.l initial_entry_pos_table(pc,d1.w), A0
  rts

;---------------------------------------------

hijack_inital_entry_erase:
  bsr initial_entry_start_pos_calc
  
  movea.l A0, A1

  move.w  #$3, D4

  move.w  #$7, temp_var_0
  
  jsr clear_scroll_1  
 
  rts
;================================================

initial_entry_start_pos_table:
 dc.l $0090858C, $00908D0C, $0090948C

initial_entry_pos_table:
 dc.l $00908594, $00908D14, $00909494

player_mem_loc_table:
player_mem_loc_iterator_start_p1:
 dc.l $FFFF8568 
player_mem_loc_iterator_start_p2:
 dc.l $FFFF8628 
player_mem_loc_iterator_start_p3:
 dc.l $FFFFE6E8 
 dc.l $FFFF8568 

enemy_mem_loc_table:
 dc.l $FFFF86e8
 dc.l $FFFF87A8
 dc.l $FFFF8868
 dc.l $FFFF8928
 dc.l $FFFF89E8
 dc.l $FFFF8AA8
 dc.l $FFFF8B68
 dc.l $FFFF8C28
 dc.l $FFFF8CE8
 dc.l $FFFF8DA8
 dc.l $FFFF8E68
 dc.l $FFFF8F28
 dc.l $FFFF8FE8
 
boss_mem_loc_table:
 dc.l $FFFF9528
 dc.l $FFFF95E8
 dc.l $FFFF96A8
 dc.l $FFFF9768
 dc.l $FFFF9828
 dc.l $FFFF98E8
 dc.l $FFFF99A8
 dc.l $FFFF9A68
 
p3_border_data:
 incbin "charsel_border_data\p3_border_data.bin"
 
new_string_indexes:
 incbin "strings_binaries\string_indexes_p1_p2.bin"
 incbin "strings_binaries\string_indexes_p1_p3.bin"
 
 org 0x0FFC00
 incbin "strings_binaries\final_fight_strings_p3.bin"
