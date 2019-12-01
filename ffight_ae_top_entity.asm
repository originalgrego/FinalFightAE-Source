 org 0x004CDE
   jmp hijack_player_2_add_top_entity
      
 org 0x015D4E
   jmp hijack_player_2_init_top_entity
   
 org 0x009372
   jmp hijack_player_2_remove_top_entity
   
 org 0x0011E4
   jmp hijack_player_2_remove_top_entity_main_screen
   
 org 0x018250
   jmp hijack_player_2_remove_top_entity_main_screen_demo
   
 org 0x015D86
   rts
   
 org 0x015D92
   jmp hijack_player_2_top_entity_init_player

 org 0x0160DE
   jmp hijack_p2_initialize_health_and_score

 org $0165A6
   jmp hijack_clear_player_active_bit_on_game_end

;======================================================   
; Hijack player 2 top entity calls to draw string
;======================================================   
 ; Clear all lines before showing continue
 org 0x015DCC
   jsr $1434.w 

 ; Draw bonus score
 org 0x0160F4
   jmp $1434.w 

 ; Show start/coin/freeplay
 org 0x0161FE
   jmp $1434.w 
   
 org 0x016206
   jmp $1434.w 

 org 0x01620E
   jmp $1434.w 

 ; Hide start/coin/freeplay
 org 0x016240
   jmp $1434.w 

 org 0x016248
   jmp $1434.w 

 org 0x016250
   jmp $1434.w 
   
 ; Show select player
 org 0x016292
   jsr $1434.w 
 
 ; Hide select player
 org 0x0162EC
   jsr $1434.w 
   
 ; Show continue
 org 0x015E50
   jsr $1434.w 

 ; Hide continue
 org 0x01651A
   jsr $1434.w 

 ; Hide continue again...
 org 0x015E94
   jsr $1434.w 
   
 ; Show game over
 org 0x016528
   jsr $1434.w 

 ; Hide game over
 org 0x016584
   jsr $1434.w 
;======================================================   

 org 0x002E1E
   jmp hijack_player_top_entity_click_in_branch
   
 org 0x002D8C
   jmp hijack_player_top_entity_click_in_branch_2

 org 0x002D9E
   jmp hijack_p1_top_entity_continue_check

 org 0x002E30
   jmp hijack_p1_top_entity_click_in_check

 org 0x01646A
   jmp hijack_p2_continue_start_button_check
   
 org 0x016538
   jmp hijack_p2_top_entity_disable_player

   
;======================================================   
; Unrestrict character selection p2/3
 org 0x01632E
   bra $16350

 org 0x016346
   bra $16350
;======================================================   



   
 
 