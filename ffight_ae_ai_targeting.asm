;================================================
 ; Calculate ai target
 org 0x028084
   jmp hijack_ai_targeting
   
ai_target_player_3:
   lea     (p3_main_mem,A5), A0
   move.w  #$4, D0
   rts
      
 org $027BF6
   jmp hijack_shuffle_check_active_player

 org $027C04
   jmp hijack_shuffle_check_player_8E

 org $027C20
   jmp hijack_shuffle_try_next_player

 org $027AC6
   jmp hijack_minor_enemy_targeting
;================================================

;================================================
; Group targeting
 org 0x027E44
    jmp hijack_minor_enemy_group_targeting_check

 org 0x027CC6
    jmp hijack_minor_enemy_group_targeting_check_2

 org $027FD6
  jmp hijack_p2_generate_group_data

 org $003DFC
  jmp hijack_p2_init_group_data
;================================================

;================================================
 ; Boss targeting
 org 0x040A6A
   jmp hijack_boss_ai_targeting
;================================================
  
   
;================================================
; Damnd
 org 0x03D40A
   jmp hijack_damnd_initialize

 org 0x03D4CE
   jmp hijack_damnd_choose_initial_player
   
 org 0x03D592
   jmp hijack_damnd_player_status_jmp
   
 org 0x0408D6
   jmp boss_choose_random_player
   
 ; Damnd targeting 
 org 0x0406DC
   jmp hijack_damnd_targeting_2

 org 0x040756
   jmp hijack_damnd_targeting_3
;================================================

;================================================
; Sodom
;================================================
 org 0x040D3E
   jmp $040D82 ; Ignore player status check
   
 org 0x040DF6
   jsr $040E7A ; Always use multiplayer targeting logic
   jmp $040E04   

 org 0x040C64
   jmp hijack_sodom_initialize

 org 0x042AEE
   jmp boss_choose_random_player

; Sodom targeting
 org 0x042742
   jmp hijack_sodom_targeting_1

 org 0x0427BC
   jmp hijack_sodom_targeting_2
;================================================

;================================================
; Abigail
 org 0x04BE40
   jmp hijack_abigail_initialize
   
 org 0x04BEB2
   rts  ; Do not try to assign from health tables...

 org 0x046BE0
   jmp hijack_abigail_edi_targeting
   
 org 0x046C9C
   jmp hijack_abigail_edi_reassign_target

 org 0x04C17A
   jmp hijack_abigail_active_player_check
 
 org 0x04CA46
   jmp boss_check_active_player_89
;================================================

;================================================
; Edi E
 org 0x045F64
   jmp hijack_edi_initialize

 org 0x045FDC
   rts  ; Do not try to assign from health tables...
   
 org 0x04623C
   jmp hijack_edi_active_player_check
   
 org 0x046BAE
   jmp boss_check_active_player_89
;================================================

;================================================
;Rolento
 org 0x048A92
   jmp hijack_rolento_initialize

 org $04AFE0
   jmp hijack_rolento_damage_table_calc

 org $04A85A
   jmp hijack_rolento_choose_random_player
   
 org $049DE6
   jmp hijack_rolento_nuckin_futz_check
   
 org $049E7C
   jmp hijack_rolento_nuckin_futz_check_2
   
 org $04AD02
   jmp hijack_rolento_double_proximity_check

 org $04ADAE
   jmp hijack_rolento_prox_then_random
   
 org $049e20
   dc.w $0064, $0064, $008C, $00B4 ; Rolento health values for 1-3 player to go nuckin futz mode
;================================================

;================================================
 ; Andore targeting
 org 0x02E5C4
   jmp hijack_andore_targeting

 org 0x02E5A4
   jmp hijack_andore_switch_player
   
 org $02DDFE
   jmp hijack_andore_butt_slam_prox

 org $02D124
   jmp hijack_andore_prox_check_other
;================================================

;================================================
 ; Bred, pick active player
 org 0x022AC6 
   jmp hijack_bred_pick_active_player

 ; Bred, pick active player
 org 0x022B1E
   jmp hijack_bred_pick_active_player_2

 ; Bred proximity check, I believe this is what causes waiting enemies to attack
 org 0x0279C0
   jmp hijack_bred_prox_check
;================================================

;================================================
 ;  Two.p, Pick active 
 org 0x028BB6
   jmp hijack_two_p_pick_active_player

 ;  Two.p, Pick active 
 org 0x028BF8
   jmp hijack_two_p_pick_active_player_2
;================================================

;================================================
; Axl active player check
 org 0x02ADA8
   jmp hijack_axl_pick_active_player

; Axl active player check
 org 0x02ADF4
   jmp hijack_axl_pick_active_player_2
;================================================

;================================================
 ; G. Oriber proximity test
 org $032BC8
   jmp hijack_g_oriber_targeting

 ; G. Oriber proximity test
 org $032C3E
   jmp hijack_g_oriber_targeting_2
;================================================

;================================================
 ; Roxy proximity test
 org 0x03A610
   jmp hijack_roxy_proximity_3

 ; Roxy proximity test
 org 0x03A59A
   jmp hijack_roxy_proximity_2

 ; Roxy proximity test
 org 0x038AD4
   jmp hijack_roxy_proximity
;================================================

;================================================
 ; Hollywood, proximity test
 org 0x036A5A
   jmp hijack_hollywood_proximity
;================================================

;================================================
 org $0514E0
   jmp hijack_andore_boss_proximity
;================================================


;================================================
 org 0x00302E
   jmp hijack_major_enemy_hit_tageting
;===========================================

;===========================================
 org 0x002F80
  jmp hijack_enemy_health_calc
;===========================================

;===========================================
; BELGAR
 org $04EA20
   jmp hijack_belgar_initialize
   
 org $04EAB6 ; Do not assign belgars health from table
   nop
   nop

 org $04F058
   jmp hijack_belgar_update_player_position

 org $04F346
   jmp hijack_belgar_update_a6_a8

 org $04F6C2
   jmp hijack_belgar_update_a8

 org $04F0EE
   jmp hijack_belgar_target_other_player

 org $04F2B8
   jmp hijack_belgar_active_or_random

 org $04FB08
   jmp hijack_belgar_prox_check

 org $04FC9C
   jmp hijack_belgar_active_or_C9_check

 org $04FCBE
   jmp hijack_belgar_active_or_x_prox_check

 org $04F2DA
   jmp hijack_belgar_active_or_y_origin_prox_check

 org $04F670
   jmp hijack_belgar_active_or_y_origin_prox_check_2

 org $04FC6E
   jmp boss_check_active_player_89
;===========================================
