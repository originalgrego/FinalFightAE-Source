
;========================================================
; This sucks but we need the space, move some random shit to no mans land
; This is not safe at all
 org 0x00142E
  jmp move_00142E
  
draw_string_p23:
  jmp draw_string_p23_handler
  
; Do not attempt to use space after this... will cause incorrect code to be executed
;========================================================
  
;========================================================
 org 0x009faa
  jmp draw_string_p23_handler
  
 org 0x0014B4
  jmp hijack_draw_string_script
  
 org 0x0017CE
  jmp hijack_hide_string_script
;========================================================
  
;========================================================
; Select player countdown/portrait hijacks, probably should be in top entity file
 org 0x0164BC
   jmp hijack_p2_select_player_countdown
    
; org 0x0163C2
;	jmp hijack_ingame_charsel_portrait_draw
;========================================================

;========================================================
 org 0x0161EA
   jmp hijack_show_p2_additional_credits_message

 org 0x01622C
   jmp hijack_hide_p2_additional_credits_message
;========================================================

;========================================================
 org 0x015F38
   jmp hijack_p2_continue_countdown
;========================================================
 
;========================================================
 org 0x015C4E
   jmp hijack_p1_select_player_countdown


;========================================================

;========================================================
 org 0x0156C4
   jmp hijack_p1_continue_countdown
;========================================================

;========================================================
; Title screen insert coin/push start text changes
 org 0x66ACC
  dc.b $15, $19
  
 org 0x66ACF
  dc.b "PUSH 1P 2P OR 3P START", $00, $00
  
 ; Always show the same message, p1/p2/p3 start
 org 0x05D874
   move.w  #$28, D0 

 org 0x05D89C
   move.w  #$28, D0

 org 0x05D8A8
   move.w  #$28, D0
;========================================================

;========================================================
; P1 one more coin message 
 org 0x66ed9
  dc.b $09, $03
 
 org 0x66edc
  dc.b "ONE MORE    "
  dc.b $5C, $09, $04, $00
  dc.b "      COIN  "
  dc.b $00
;========================================================

;========================================================
; P2 one more coin message - Index 27
 org 0x66a9a
  dc.b $18, $03
 
 org 0x66a9d
  dc.b "ONE MORE    "
  dc.b $5C, $18, $04, $00
  dc.b "      COIN  "
  dc.b $00
;========================================================

;========================================================
; P3 one more coin message 
 org 0x66f0b
  dc.b $27, $03
 
 org 0x66f0f
  dc.b "ONE MORE    "
  dc.b $5C, $27, $04, $00
  dc.b "      COIN  "
  dc.b $00
;========================================================

 org 0x0CA270	; Replaces original VRAM data for ingame charsel portraits. This allows the attribute bytes to be offset easily.
	incbin	strings_binaries/ingame_charsel_portrait_data_guy.bin
	incbin	strings_binaries/ingame_charsel_portrait_data_cody.bin
	incbin	strings_binaries/ingame_charsel_portrait_data_haggar.bin