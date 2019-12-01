;==============================
; Player namebar/portraits draw	
; org 0x001D78
;	jmp hijack_namebar_draw_player

;==============================
; Set player OBJ palettes on click-in
 org 0x00A0FE
	jmp hijack_charsel_commit_selection
	

;-------------------------------------------------------
; Fix player's on-fire color conflicting with custom palettes (1/2)
 org 0xAE16
	jmp hijack_charsel_falling_setpalette

;-------------------------------------------------------
; Fix player's on-fire color conflicting with custom palettes (2/2)
 org 0xAEF2
	jmp hijack_charsel_falling_resetpalette


;-------------------------------------------------------
; Fix player's on-fire color conflicting with custom palettes (1/2)
 org 0xB0BE
	jmp hijack_charsel_fallingdead_setpalette

;-------------------------------------------------------
; Fix player's on-fire color conflicting with custom palettes (2/2)
 org 0xB196
	jmp hijack_charsel_fallingdead_resetpalette

;-------------------------------------------------------
	
;==============================
; Ingame charsel 1P joypad reads (for added color selection)
 org 0x015AA8
	jmp hijack_ingame_charsel_1p_readjoy
	
;==============================
; Ingame charsel 2P joypad reads (for added color selection)
 org 0x016316
	jmp hijack_ingame_charsel_2p_readjoy

;==============================
; Fixes player colors for ending demo
 org 0x20FAA
	jmp hijack_charsel_ending_colors
	
 org 0x187e8
	jmp hijack_charsel_ending_colors_2
	
 org 0x189CA
	jmp hijack_charsel_ending_colors_3
	
;==============================
; Character Select Screen	
 org 0x05C5D0
	jmp xcharsel_compare_1p2p
	   
;-------------------------------------------------------	   
; load new portrait palettes

 org 0x5C3AE
	jmp hijack_charsel_loadpalettes
	   
;-------------------------------------------------------
; clear SCROLL2 and SCROLL3 to blank the backgrounds and portraits
 org 0x5C3B6
;	jmp xcharsel_clearportraits
	
 org 0xC93C8
	dc.b $0, $0
 org 0xC97B8
	dc.b $0, $0
	   
;-------------------------------------------------------
; disable default weight/height text draw

 org 0x5C3BE
	NOP
	NOP
	NOP
	NOP
	   
;-------------------------------------------------------
; disable default character names text draw

 org 0x5C3CE
	NOP
	NOP
	NOP
	NOP
	     
;-------------------------------------------------------
 org 0x05C420
    jmp hijack_char_select_handler
	   
;-------------------------------------------------------
 org 0x05C57C
	jmp hijack_charsel_inputcheck_joystick

;-------------------------------------------------------

 org 0x05C47E
    jmp hijack_p1_char_select_check_click_in

;-------------------------------------------------------
 org 0x05C6C8
   jmp hijack_border_palette
      
;-------------------------------------------------------
 org 0x05C6DC
   jmp hijack_border_data_pointer_calc
      
;-------------------------------------------------------

 org 0x5C71C
	jmp hijack_border_draw_portraits
	 
;-------------------------------------------------------
 org 0x05C45E
   jmp hijack_char_sel_assign_player
      
;-------------------------------------------------------

 org 0x05C58E	; disable old portrait clear subroutine that was causing issues with new charsel setup
	NOP
	NOP
	
;-------------------------------------------------------

 org 0x05C5B2	; disable old portrait clear subroutine that was causing issues with new charsel setup
	NOP
	NOP
	
;-------------------------------------------------------
 org 0x05C636
   jmp hijack_char_sel_start_check
      
;-------------------------------------------------------

 org 0x06450C
	jmp hijack_load_level_palettes

;-------------------------------------------------------

 org 0x015B30	; 1p portrait draw
	jmp hijack_ingame_charsel_portraitdraw

 org 0x015B96	; 1p portrait clear
	jmp hijack_ingame_charsel_portraitclear

 org 0x01639E	; 2p portrait draw
	jmp hijack_ingame_charsel_portraitdraw
	
 org 0x016404	; 2p portrait clear
	jmp hijack_ingame_charsel_portraitclear

;-------------------------------------------------------
; Override color for the attract mode bio screen portraits

 org 0xC5E00
	incbin palettes/pal_charsel_00_b.bin
	
;-------------------------------------------------------
; New red palette for 1P charsel border color
 org 0xC3BC0
	incbin palettes/pal_charsel_border_1p.bin
	
;-------------------------------------------------------
; Fix for elevator/ingame charsel palette conflict.
; Overwrites unused FBI Crest palette ($0D) with elevator's palette.
 org 0x0C29A0
	incbin palettes/pal_rolento_elevator.bin

; Modified SCROLL1 data for Rolento's elevator. Color attributes changed to $0D
 org 0x0CA7E0
	incbin bgmaps/scroll1_rolento_elevator_new.bin