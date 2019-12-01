;=======================================================
xcharsel_compare_1p2p:	; Allows players to use the same character
	moveq	#$0, D1
	rts
;=======================================================
	
hijack_charsel_falling_setpalette:
	move.l	($20,A6), D0
	cmpi.l	#$00003FD2, D0	; test if player is on fire (Guy, Cody)
	beq		hijack_charsel_falling_setpalette_set
	cmpi.l	#$00003FDE, D0	; test if player is on fire (Haggar)
	bne		hijack_charsel_falling_setpalette_dontset
	
hijack_charsel_falling_setpalette_set:
	move.b	#$9C, ($2F,A6)
hijack_charsel_falling_setpalette_dontset:
	; original code
	move.b  ($3e,A6), ($2e,A6)
    move.b  ($3e,A6), ($36,A6)
	jmp		$AE22
;=======================================================
	
hijack_charsel_falling_resetpalette:
	move.b	#$80, D0
	add.b	($13,A6), D0
	move.b	D0, ($2F,A6)
	; original code
	jsr     $3070.w
	move.w  #$10, D0
	jmp		$AEFA

;=======================================================
	
hijack_charsel_fallingdead_setpalette:
	move.l	($20,A6), D0
	cmpi.l	#$00003FD2, D0	; test if player is on fire (Guy, Cody)
	beq		hijack_charsel_fallingdead_setpalette_set
	cmpi.l	#$00003FDE, D0	; test if player is on fire (Haggar)
	bne		hijack_charsel_fallingdead_setpalette_dontset
	
hijack_charsel_fallingdead_setpalette_set:
	move.b	#$9C, ($2F,A6)
hijack_charsel_fallingdead_setpalette_dontset:
	; original code
	move.b  ($3e,A6), ($2e,A6)
    move.b  ($3e,A6), ($36,A6)
	jmp		$B0CA
;=======================================================
hijack_charsel_fallingdead_resetpalette:
	move.b	#$80, D0
	add.b	($13,A6), D0
	move.b	D0, ($2F,A6)
	; original code
	jsr     $3070.w
	move.w  #$10, D0
	jmp		$B19E

;=======================================================
hijack_charsel_ending_colors:   ; Corrects player palettes at ROUND 6 CLEAR screen with all 3 player characters and Jessica
	bsr charsel_copy_player_palettes
	;original code
	addq.b  #2, ($2,A6)	
    move.w  #$3283, ($6,A6)
	jmp		$20FB4
	
;=======================================================

hijack_charsel_ending_colors_2:	; Corrects player palettes as Cody and Guy walk away
	bsr charsel_copy_player_palettes
	;original code
	move.b  #$1, ($0,A4)
	move.b  #$36, ($13,A4)
	jmp		$187F0
	
;=======================================================
charsel_copy_player_palettes:
	lea		$C0000,A2
	lea		$914000,A3
	move.b	#$18,D0
charsel_copy_player_palettes_loop:
	move.l	(A2)+,(A3)+
	dbra	D0, charsel_copy_player_palettes_loop
	rts
	
;=======================================================
	
hijack_charsel_ending_colors_3:
	move.b	#$1, ($63B,A5)			; After being beaten up by Guy in the ending, Cody switches to being controled by Player 2.
	move.b  #$1, ($0,A4)            ; However, his player ID byte is not set correctly and his palette is set to Guy's.
	move.b  #$35, ($13,A4)	        ; This fix sets 2P's player ID correctly after being initialized by the ending script.
	jmp		$189D6                  


;=======================================================

hijack_charsel_loadpalettes:
	jsr		$64504	; level_load_palettes, as normal
	movea.l	#$914800,A0
	movea.l (tbl_charsel_portrait_palettes_addr),a1
	moveq	#$00,d0
	move.b	#$2F,d0		; palette long count
	moveq	#$00,d1
	move.b	#$02,d1		; player count
	
hijack_charsel_loadpalettes_loop:
	move.l	(A1)+,(A0)+
	dbf		d0,hijack_charsel_loadpalettes_loop
	
	movea.l (tbl_charsel_portrait_palettes_addr),a1
	move.w	#$002F,d0
	dbf		d1,hijack_charsel_loadpalettes_loop
	
	jmp		$5C3B4		; return from hijack
	
;=======================================================
	; A1 = palette data source
	; A0 = palette data dest
	; D0 = palette data long counter

charsel_portraitpalette_write:
	moveq 	#$00,d0
	move.b	#$2F,d0
	
charsel_portraitpalette_write_loop:
	move.l	(A1)+,(A0)+
	dbf		d0,charsel_portraitpalette_write_loop
	rts
	
;=======================================================

hijack_char_select_handler:
	; update palettes if a new selection has been made
	moveq	#$00,d1
	moveq	#00,d0
	moveq	#00,d3
	move.b	#$02,d1		; player count
	
charsel_updatepals_loop:
	lea		(playerpalette_selection_current_1p).l,a0
	adda.w	d1, a0
	move.b	(a0), d3
	move.w	d1,d0
	add.w	d0,d0
	add.w	d0,d0
	move.l	#tbl_portraits_palettes_vram_addr,d4
	add.w	d0, d4
	movea.l	d4, a0		; vram palette dest
	move.l  (a0),a0
	add.w	d3,d3
	add.w	d3,d3
	move.l #tbl_charsel_portrait_palettes_addr,d4			; palselection*4 for palette source
	add.w	d3, d4
	movea.l	d4, a1
	movea.l	(a1),a1
	
	bsr 	charsel_portraitpalette_write
	dbra	d1, charsel_updatepals_loop
	


  jsr     $05c47e ; Check player 1
  jsr     $05c4f6 ; Check player 2
 
  btst    #$2, ($c,A6)
  bne     hijack_char_select_handler_continue
  
  tst.b   ($82,A5) ; Game active
  beq     hijack_char_select_handler_continue

  jsr     p3_check_click_in
  bcc     hijack_char_select_handler_continue

  addq.w  #1, ($5470,A5)

hijack_char_select_handler_game_started:
  jsr p3_init_more
  jsr handle_player_three_init
  jsr p3_a032
  bset    #$2, ($c,A6) ; Add player 3 to active char sel players
  bset    #$2, ($0,A6) ; Add player 3 to active char sel players
  bset    #$2, ($7f,A5) ; Add player 3 as active player
  move.w  #$ffff, ($a,A6)
  move.w  #$2, D7 ; Player id
  lea     ($1C,A6), A1
  lea     ($10,A6), A2
  move.w  #$2, ($0,A1) ; Set to cody
  jmp     $05c6d6 ; Draw player border
  
hijack_char_select_handler_continue:
  btst    #$2, ($0,A6)
  beq     hijack_char_select_handler_exit

  move.w  #$2, D7
  lea     (p3_main_mem,A5), A4 
  lea     ($1C,A6), A1
  lea     ($10,A6), A2
  jsr     $05c56e

hijack_char_select_handler_exit:
  jmp 	 $05C428
;=======================================================

;=======================================================
hijack_p1_char_select_check_click_in:
  btst    #$0, ($c,A6) ; Check if player 1 active
  bne     hijack_p1_char_select_check_click_in_exit

  jsr     hijack_p1_top_entity_continue_check_p1_continue
  bcc     hijack_p1_char_select_check_click_in_exit

  jmp $05C48E

hijack_p1_char_select_check_click_in_exit:
  jmp $05c4d6
;=======================================================

;=======================================================
hijack_border_palette:
  tst.b D7
  beq hijack_border_palette_p1

  cmp.b #$1, D7
  bne hijack_border_palette_p3
  
  move.w  #$7, D6 ; player 2
  rts
  
hijack_border_palette_p3:
  move.w  #$1, D6
  rts
 
hijack_border_palette_p1:
  move.w  #$1E, D6
  rts
;=======================================================

;=======================================================
hijack_border_data_pointer_calc:
  tst.b D7
  beq hijack_border_data_pointer_calc_p1
 
  cmp.b #$1, D7
  bne hijack_border_data_pointer_calc_p3
  
  move.l #$05C7A6, A3
  bra hijack_border_data_pointer_calc_exit
  
hijack_border_data_pointer_calc_p3:
  lea p3_border_data.l, A3
  bra hijack_border_data_pointer_calc_exit

hijack_border_data_pointer_calc_p1:
  move.l #$05C736, A3

hijack_border_data_pointer_calc_exit:
  move.w d7,d1
  add.w d1,d1
  add.w d1,d1
  movea.l tbl_border_pos(pc,D1.w), A2	; this will lock the border position based on player, not character
  jmp $05C6F0
  
tbl_border_pos:
	dc.l	$908594, $908C94, $909394
;=======================================================

;=======================================================
hijack_char_sel_assign_player:
  btst #$1, ($c,A6) ; Check if player 2 was active
  beq hijack_char_sel_assign_player_check_p3

  jsr $05C468
  
hijack_char_sel_assign_player_check_p3:

  btst #$2, ($c,A6) ; Check if player 3 was active
  beq hijack_char_sel_assign_player_exit

  move.w  ($1C,A6), D0 
  lsr.b   #1, D0
  move.b  D0, ($6769,A5)

  lea     (p3_main_mem,A5), A4 ; Init player 3
  jsr     $00a0fe

hijack_char_sel_assign_player_exit:
  rts
;=======================================================

;=======================================================
hijack_char_sel_start_check:
  tst.b ($13,A4) ; Check player
  beq hijack_char_sel_start_check_p1

  cmp.b #$1, ($13,A4)
  bne hijack_char_sel_start_check_p3
  
  jsr $295e.w ; Check start
  jmp $05C640 ; 2p
  
hijack_char_sel_start_check_p1:
  jsr $295e.w ; Check start
  jmp $05c650 ; 1p
  
hijack_char_sel_start_check_p3:
   jsr     p3_check_press_start
   beq     hijack_char_sel_start_check_p3_exit
 
hijack_char_sel_start_check_p3_continue:
   move.l  A2, -(A7)
   jsr     $2cae.w ; Subtract credit? Play sound?
   movea.l (A7)+, A2
   jmp     $005c626 ; Char selected
   
hijack_char_sel_start_check_p3_exit: 
   rts
;=======================================================

xcharsel_clearportraits:
	jsr 0x61D56 ; gamestate6_level
	movea.l (A7)+, A6 ; retrieve charsel RAM addr
	
; SCROLL 2 start addr for clearing: 0x90F000
; SCROLL 2 end addr for clearing: 0x90FFFF
	lea		$90F000, A1
	moveq	#$0, D2
	move.w	#$200, D2	; number of passes to clear SCROLL2
xcharsel_clearportraits_scroll2_loop:
	move.l	#$30000000, (A1)+
	dbra	D2, xcharsel_clearportraits_scroll2_loop
	
	lea		$913800, A1
	moveq	#$0, D2
	move.b	#$6C, D2	; number of passes to clear SCROLL3
xcharsel_clearportraits_scroll3_loop:
	move.l	#$09800000, (A1)+
	dbra	D2, xcharsel_clearportraits_scroll3_loop

	jmp 0x5C3BE 
;========================================================
; end of xcharsel_clearportraits
;========================================================

	
hijack_border_draw_portraits:
	move.w 	d7,d0				; get current player ID
	add.w 	d0,d0
	add.w 	d0,d0
	cmpi.w	#$08,d0
	bne hijack_border_draw_portraits_not3p
	
	lea		$FF1530,a1
	move.w	(a1),d1
	add.w	d1,d1
	bra 	hijack_border_draw_portraits_getoffsets
	
hijack_border_draw_portraits_not3p:
	move.w	d0,d1				; preserve player ID in d0, but use in d1 to get chararacter selection
	add.w	d1,d1
	add.w	#$10,d1
	move.w	(a6,d1.w),d1	; get current player's character selection
	add.w	d1,d1
hijack_border_draw_portraits_getoffsets:
	movea.l	tbl_portraits_scroll2_vram_addr(pc,d0.w), A0
	movea.l	tbl_portraits_scroll2_tile_addr(pc,d1.w), A1
	moveq	#$00,d2
	move.b	(tbl_portraits_scroll2_attributemod,pc,d7), d2			; portrait attribute modifier
	moveq	#$00,d3
	move.b	#$06,d3				; column tile count
	moveq	#$00,d4
	move.b	#$05,d4				; column count
	
hijack_border_draw_portraits_scroll2_loop:
	move.w	(A1)+, (A0)+	 			
	move.w	(A1), (A0)			; player portrait tile & attribute
	add.w	D2,(A0)+				; add attribute modifier
	lea		$02(A1),A1			
	dbf		D3,hijack_border_draw_portraits_scroll2_loop
	
	adda.w	#$0024,A0				; increment vram dest for next column
	move.w	#$0006,D3				; reset column tile count
	dbf		D4,hijack_border_draw_portraits_scroll2_loop

	jsr		hijack_charsel_drawname
	jsr		hijack_charsel_drawstats
	jsr		hijack_charsel_drawbg
	
	movea.l	(A7)+, A3 				; original end of charsel_border
	movea.l (A7)+, A2
	rts
	
;========================================================
; end of hijack_border_draw_portraits
;========================================================

;========================================================
	
; SCROLL2 1P portrait addr: $90F08C
; SCROLL2 2P portrait addr: $90F24C
; SCROLL2 3P portrait addr: $90F40C
; SCROLL2 Portrait column length: 7
; SCROLL2 Portrait column count: 6
; SCROLL2 Portrait column offset: 0x40

; SCROLL3 1P bg addr: $913824
; SCROLL3 2P bg addr: $913884
; SCROLL3 3P bg addr: $913904
; SCROLL3 Portrait column length: 4
; SCROLL3 Portrait column count: 3 (Guy & Haggar) 4 (Cody)
; SCROLL3 Portrait column offset: 0x20

;###
;### Data tables for hijack_charsel_drawportrait
;###



tbl_portraits_scroll2_vram_addr:
	dc.l	$90F08C, $90F24C, $90F40C
	
tbl_portraits_palettes_vram_addr:
	dc.l	$914800, $9148C0, $914980
	
tbl_portraits_scroll2_tile_addr:
	dc.l	tbl_scroll2_tiles_guy, tbl_scroll2_tiles_cody, tbl_scroll2_tiles_haggar
	
tbl_portraits_scroll2_attributemod:
	dc.b	$00, $06, $0C, $00
	
tbl_charsel_portrait_palettes_addr:
	dc.l pal_charsel_00, pal_charsel_01, pal_charsel_02, pal_charsel_03, pal_charsel_04, pal_charsel_05, pal_charsel_06
	


tbl_scroll2_tiles_guy:
	dc.w $3000, $0000, $3000, $0000, $3F78, $0000, $3F66, $0000, $3F6E, $0000, $3F76, $0000, $3000, $0000, $3000, $0000, $3000, $0000, $3F79, $0000, $3F67, $0000, $3F6F, $0000, $3F77, $0000, $3F7F, $0000, $3F60, $0000, $3F68, $0000, $3F70, $0000, $3F80, $0000, $3F88, $0000, $3F90, $0000, $3F98, $0000, $3F61, $0000, $3F69, $0000, $3F71, $0000, $3F81, $0000, $3F89, $0000, $3F91, $0000, $3F99, $0000, $3F62, $0000, $3F6A, $0000, $3F7A, $0000, $3F82, $0000, $3F8A, $0000, $3F92, $0000, $3F9A, $0000, $3000, $0000, $3000, $0000, $3F7B, $0000, $3F83, $0000, $3F8B, $0000, $3F93, $0000, $3000, $0000
	
tbl_scroll2_tiles_cody:
	dc.w	$3000, $0001, $3000, $0001, $3F7C, $0001, $3F84, $0001, $3F8C, $0001, $3F94, $0002, $3F9C, $0002, $3F63, $0001, $3F6B, $0001, $3F73, $0001, $3F85, $0001, $3F8D, $0001, $3F95, $0002, $3F9D, $0002, $3F64, $0001, $3F6C, $0005, $3F74, $0005, $3F86, $0001, $3F8E, $0001, $3F96, $0001, $3F9E, $0002, $3F65, $0001, $3F6D, $0001, $3F75, $0001, $3F87, $0001, $3F8F, $0001, $3F97, $0003, $3F9F, $0002, $3000, $0001, $3000, $0001, $3F7D, $0001, $3FA0, $0001, $3FA8, $0001, $3FB0, $0002, $3FB8, $0002, $3000, $0001, $3000, $0001, $3000, $0001, $3FA1, $0002, $3FA9, $0002, $3FB1, $0001, $3000, $0001
	
tbl_scroll2_tiles_haggar:
	dc.w	$3000, $0004, $3000, $0004, $3FBF, $0004, $3FA2, $0004, $3FAA, $0004, $3FB2, $0004, $3FBA, $0004, $3F7E, $0004, $3C02, $0004, $3C05, $0004, $3FA3, $0004, $3FAB, $0004, $3FB3, $0004, $3FBB, $0004, $3C00, $0004, $3C03, $0004, $3C06, $0004, $3FA4, $0004, $3FAC, $0004, $3FB4, $0004, $3FBC, $0004, $3C01, $0004, $3C04, $0004, $3C07, $0004, $3FA5, $0004, $3FAD, $0004, $3FB5, $0004, $3FBD, $0004, $3000, $0004, $3000, $0004, $3F9B, $0004, $3FA6, $0004, $3FAE, $0004, $3FB6, $0004, $3FBE, $0004, $3000, $0004, $3000, $0004, $3FB9, $0004, $3FA7, $0004, $3FAF, $0004, $3FB7, $0004, $3000, $0004
	
tbl_scroll3_tiles_1p:
	dc.w	$09D0, $0000, $09D4, $0000, $09D8, $0000, $09DC, $0000, $09D1, $0000, $09D5, $0000, $09D8, $0000, $09DC, $0000, $09D2, $0000, $09D6, $0000, $09D8, $0000, $09DC, $0000
	
tbl_scroll3_tiles_2p:
	dc.w	$09D3, $0000, $09D7, $0000, $09D9, $0000, $09DD, $0000, $09D0, $0000, $09D4, $0000, $09D8, $0000, $09DC, $0000, $09D1, $0000, $09D5, $0000, $09D8, $0000, $09DC, $0000, $09DB, $0000, $09DF, $0000, $09DA, $0000, $09DE, $0000
	
tbl_scroll3_tiles_3p:
	dc.w	$09D2, $0000, $09D6, $0000, $09D8, $0000, $09DC, $0000, $09D0, $0000, $09D4, $0000, $09D8, $0000, $09DC, $0000, $09D1, $0000, $09D5, $0000, $09D8, $0000, $09DC, $0000

;========================================================
;	SCROLL 1 namebars for charsel. 14 columns, 2 tiles per column

;	90858C = Start of 1P namebar
;	908C8C = Start of 2P namebar
;	90938C = Start of 3P namebar

hijack_charsel_drawname:
	
	movea.l	tbl_charsel_names_src(pc,d1.w), A0
	movea.l	tbl_charsel_names_dest(pc,d0.w), A1
	move.w	#$018E, D2	; SCROLL1 text attribute
	move.w	#$0D, D3	; column count
	
hijack_charsel_drawname_loop:
	move.w	(A0)+, (A1)
	move.w	D2,	($2, A1)
	move.w	(A0)+, ($4, A1)
	move.w	D2, ($6, A1)
	adda.w	#$80, A1
	dbf		D3, hijack_charsel_drawname_loop

	rts
	
;========================================================
;###
;### Data tables for hijack_charsel_drawname
;###

tbl_charsel_names_src:
	dc.l	tbl_charsel_names_guy, tbl_charsel_names_cody, tbl_charsel_names_haggar

tbl_charsel_names_dest:
	dc.l	$90858C, $908C8C, $90938C

tbl_charsel_names_guy:
	dc.w	$4420, $4420
	dc.w	$4420, $4420
	dc.w	$4420, $4420
	dc.w	$4420, $4420
	dc.w	$448C, $449C	; G 1
	dc.w	$448D, $449D	; G 2
	dc.w	$44C8, $44D8	; U 1
	dc.w	$44C9, $44D9	; U 2
	dc.w	$44E0, $44F0	; Y 1
	dc.w	$44E1, $44F1	; Y 2
	dc.w	$4420, $4420
	dc.w	$4420, $4420
	dc.w	$4420, $4420
	dc.w	$4420, $4420
			
tbl_charsel_names_cody:
	dc.w	$4420, $4420
	dc.w	$4420, $4420
	dc.w	$4420, $4420
	dc.w	$4484, $4494	; C 1
	dc.w	$4485, $4495	; C 2
	dc.w	$44AC, $44BC	; O 1
	dc.w	$44AD, $44BD	; O 2
	dc.w	$4486, $4496	; D 1
	dc.w	$4487, $4497	; D 2
	dc.w	$44E0, $44F0	; Y 1
	dc.w	$44E1, $44F1	; Y 2
	dc.w	$4420, $4420
	dc.w	$4420, $4420
	dc.w	$4420, $4420
	
tbl_charsel_names_haggar:
	dc.w	$4420, $4420
	dc.w	$448E, $449E	; H 1
	dc.w	$448F, $449F	; H 2
	dc.w	$4480, $4490	; A 1
	dc.w	$4481, $4491	; A 2
	dc.w	$448C, $449C	; G 1
	dc.w	$448D, $449D	; G 2
	dc.w	$448C, $449C	; G 1
	dc.w	$448D, $449D	; G 2
	dc.w	$4480, $4490	; A 1
	dc.w	$4481, $4491	; A 2
	dc.w	$44C2, $44D2	; R 1
	dc.w	$44C3, $44D3	; R 2
	dc.w	$4420, $4420

;========================================================
;	SCROLL 1 stats for charsel. 14 columns, 2 tiles per column

;	90858C = Start of 1P stats
;	908C8C = Start of 2P stats
;	90938C = Start of 3P stats

hijack_charsel_drawstats:
	
	movea.l	tbl_charsel_stats_src(pc,d1.w), A0
	movea.l	tbl_charsel_stats_dest(pc,d0.w), A1
	move.w	#$018E, D2	; SCROLL1 text attribute
	move.w	#$0D, D3	; column count
	
hijack_charsel_drawstats_loop:
	move.w	(A0)+, (A1)
	move.w	D2,	($2, A1)
	move.w	(A0)+, ($8, A1)
	move.w	D2, ($A, A1)
	adda.w	#$80, A1
	dbf		D3, hijack_charsel_drawstats_loop

	rts
	
;========================================================
;###
;### Data tables for hijack_charsel_drawstats
;###

tbl_charsel_stats_src:
	dc.l	tbl_charsel_stats_guy, tbl_charsel_stats_cody, tbl_charsel_stats_haggar
	
tbl_charsel_stats_dest:
	dc.l	$9085DC, $908CDC, $9093DC
	
tbl_charsel_stats_guy:
	dc.w	$4420, $4420	; . .
	dc.w	$453B, $4457	; H W
	dc.w	$453C, $453C	; eight 1
	dc.w	$453D, $453D	; eight 2
	dc.w	$453E, $453E	; eight 3
	dc.w	$453F, $453F	; eight 4
	dc.w	$4460, $4460	; . .
	dc.w	$4460, $4460	; . .
	dc.w	$4460, $4401	; . 1
	dc.w	$4405, $4405	; 5 5
	dc.w	$447B, $4408	; ' 8
	dc.w	$4409, $445D	; 9 lb
	dc.w	$445C, $4440	; " s.
	dc.w	$4420, $4420	; . .
	
tbl_charsel_stats_cody:
	dc.w	$4420, $4420	; . .
	dc.w	$453B, $4457	; H W
	dc.w	$453C, $453C	; eight 1
	dc.w	$453D, $453D	; eight 2
	dc.w	$453E, $453E	; eight 3
	dc.w	$453F, $453F	; eight 4
	dc.w	$4460, $4460	; . .
	dc.w	$4460, $4460	; . .
	dc.w	$4460, $4401	; . 1
	dc.w	$4406, $4408	; 6 8
	dc.w	$447B, $4407	; ' 7
	dc.w	$4400, $445D	; 0 lb
	dc.w	$445C, $4440	; " s.
	dc.w	$4420, $4420	; . .
	
tbl_charsel_stats_haggar:
	dc.w	$4420, $4420	; . .
	dc.w	$453B, $4457	; H W
	dc.w	$453C, $453C	; eight 1
	dc.w	$453D, $453D	; eight 2
	dc.w	$453E, $453E	; eight 3
	dc.w	$453F, $453F	; eight 4
	dc.w	$4460, $4460	; . .
	dc.w	$4460, $4460	; . .
	dc.w	$4460, $4402	; . 2
	dc.w	$4406, $4409	; 6 9
	dc.w	$447B, $4407	; ' 7
	dc.w	$4408, $445D	; 8 lb
	dc.w	$445C, $4440	; " s.
	dc.w	$4420, $4420	; . .

; UNCORRECTED ORIGINALS
;tbl_charsel_stats_guy:
;	dc.w	$4420, $4420	; . .
;	dc.w	$453B, $447B	; H W
;	dc.w	$453C, $453C	; eight 1
;	dc.w	$453D, $453D	; eight 2
;	dc.w	$453E, $453E	; eight 3
;	dc.w	$453F, $453F	; eight 4
;	dc.w	$4460, $4460	; . .
;	dc.w	$4460, $4460	; . .
;	dc.w	$4405, $4460	; 5 .
;	dc.w	$4460, $4401	; . 1
;	dc.w	$4408, $4405	; 8 5
;	dc.w	$4407, $4408	; 7 8
;	dc.w	$445C, $445D	; ft. lb.
;	dc.w	$4420, $4420	; . .
;	
;tbl_charsel_stats_cody:
;	dc.w	$4420, $4420	; . .
;	dc.w	$453B, $447B	; H W
;	dc.w	$453C, $453C	; eight 1
;	dc.w	$453D, $453D	; eight 2
;	dc.w	$453E, $453E	; eight 3
;	dc.w	$453F, $453F	; eight 4
;	dc.w	$4460, $4460	; . .
;	dc.w	$4460, $4460	; . .
;	dc.w	$4405, $4460	; 5 .
;	dc.w	$4460, $4401	; . 1
;	dc.w	$4409, $4408	; 9 8
;	dc.w	$4407, $4407	; 7 7
;	dc.w	$445C, $445D	; ft. lb.
;	dc.w	$4420, $4420	; . .
;	
;tbl_charsel_stats_haggar:
;	dc.w	$4420, $4420	; . .
;	dc.w	$453B, $447B	; H W
;	dc.w	$453C, $453C	; eight 1
;	dc.w	$453D, $453D	; eight 2
;	dc.w	$453E, $453E	; eight 3
;	dc.w	$453F, $453F	; eight 4
;	dc.w	$4460, $4460	; . .
;	dc.w	$4460, $4460	; . .
;	dc.w	$4406, $4460	; 6 .
;	dc.w	$4460, $4402	; . 2
;	dc.w	$4406, $4409	; 6 9
;	dc.w	$4404, $4407	; 4 7
;	dc.w	$445C, $445D	; ft. lb.
;	dc.w	$4420, $4420	; . .
	
	
;========================================================
;	SCROLL 3 backgrounds for charsel.
;	4 tiles per column
;	1P and 3P have 3 columns, 2P has 4
;	SCROLL3 vertical strides have 0x20 distance

;	913824 = Start of 1P bg
;	913884 = Start of 2P bg
;	913904 = Start of 3P bg

hijack_charsel_drawbg:
	
	movea.l	tbl_charsel_bg_src(pc,d0.w), A0
	movea.l	tbl_charsel_bg_dest(pc,d0.w), A1
;	move.w	#$0000, D2	; bg attribute
	
	cmpi.w	#4, D0
	beq		hijack_charsel_drawbg_is2p
	move.w	#$02, D3	; 1P and 3P column count
	bra		hijack_charsel_drawbg_loop
	
hijack_charsel_drawbg_is2p:
	move.w	#$03, D3	; 2P column count
	
hijack_charsel_drawbg_loop:
	move.w	(A0)+, (A1)
	move.w	#0,	($2, A1)
	move.w	(A0)+, ($4, A1)
	move.w	#0, ($6, A1)
	move.w	(A0)+, ($8, A1)
	move.w	#0, ($A, A1)
	move.w	(A0)+, ($C, A1)
	move.w	#0, ($E, A1)
	adda.w	#$20, A1
	dbf		D3, hijack_charsel_drawbg_loop

	rts
	
;========================================================
;###
;### Data tables for hijack_charsel_drawbg
;###

tbl_charsel_bg_src:
	dc.l	tbl_charsel_bg_1p, tbl_charsel_bg_2p, tbl_charsel_bg_3p

tbl_charsel_bg_dest:
	dc.l	$913824, $913884, $913904

tbl_charsel_bg_1p:
	dc.w	$9D0, $9D4, $9D8, $9DC
	dc.w	$9D1, $9D5, $9D8, $9DC
	dc.w	$9D2, $9D6, $9D8, $9DC

tbl_charsel_bg_2p:
	dc.w	$9D3, $9D7, $9D9, $9DD
	dc.w	$9D0, $9D4, $9D8, $9DC
    dc.w	$9D1, $9D5, $9D8, $9DC
	dc.w	$9DB, $9DF, $9DA, $9DE
	
tbl_charsel_bg_3p:
	dc.w	$9D2, $9D6, $9D8, $9DC
	dc.w	$9D0, $9D4, $9D8, $9DC
	dc.w	$9D1, $9D5, $9D8, $9DC

;	
;====================
;=== NEW PALETTES ===
;====================

; for in-game sprite palettes
hijack_load_level_palettes:
	jsr		$645B2
	jsr		$645F6
	jsr		$6463a
	
	jsr		load_player_sprite_palettes
	
	rts

;========================================================
	
load_player_sprite_palettes:
	move.w	#p1_main_mem,d0
	move.b	(A5,d0.w),d1
	tst.b	d1			; test 1p status
	beq 	load_player_sprite_palettes_test2p
	moveq	#$00,d2
	bsr		hijack_load_level_palettes_draw
	
load_player_sprite_palettes_test2p:
	move.w	#p2_main_mem,d0
	move.b	(A5,d0.w),d1
	tst.b	d1			; test 2p status
	beq 	load_player_sprite_palettes_test3p
	
	moveq	#$01, d2
	bsr		hijack_load_level_palettes_draw
	
load_player_sprite_palettes_test3p:
	move.w	#p3_main_mem,d0
	move.b	(A5,d0.w),d1
	tst.b	d1			; test 3p status
	beq 	load_player_sprite_palettes_return
	
	moveq	#$02, d2
	bsr		hijack_load_level_palettes_draw
load_player_sprite_palettes_return:
	rts
	
;========================================================

hijack_load_level_palettes_draw:
	add.b	#$14,d0		
	move.b	(a5,d0.w),d1	; get character id from player ram
	add.b	d1,d1
	add.b	d1,d1
	movea.l	tbl_altcolors_sprites_addr(PC,d1),a1	
	lea		(playerpalette_selection_current_1p).l,a0
	adda.w	d2, a0
	moveq	#0,d1
	move.b	(a0),d1		; load current player's palette selection
	asl.l	#5,d1
	adda.w	d1,a1		; final address of player's palette data source
	move.b	d2,d1
	add.b	d1,d1
	add.b	d1,d1
	movea.l	tbl_player_obj_vram_addr(pc,d1.w), A0	; vram destination
	move.w	#7,d0
hijack_load_level_palettes_draw_loop:
	move.l	(A1)+,(A0)+
	dbra	d0,hijack_load_level_palettes_draw_loop
	
	rts

tbl_player_obj_vram_addr:
	dc.l	$914000, $914020, $914040
	
tbl_altcolors_sprites_addr:
	dc.l pal_sprite_guy, pal_sprite_cody, pal_sprite_haggar
;-------------------------------------------------------


;-------------------------------------------------------

; Register contents:
;	
;	A4 = current player RAM addr
;	A6 = charsel RAM addr

hijack_charsel_commit_selection:
;WIP	;	jsr		hijack_charsel_charcolor_testreserve	; Check if the color selection is already taken
	
	move.b 	($81,A4),($14,A4)
	jsr 	load_player_sprite_palettes
	jmp 	$A0CC
	
;-----------------------------------------
; Charsel character portrait palette sets
;-----------------------------------------
pal_charsel_00:
	incbin palettes/pal_charsel_00_b.bin
pal_charsel_01:
	incbin palettes/pal_charsel_01_b.bin
pal_charsel_02:
	incbin palettes/pal_charsel_02_b.bin
pal_charsel_03:
	incbin palettes/pal_charsel_03_c.bin
pal_charsel_04:
	incbin palettes/pal_charsel_04_c.bin
pal_charsel_05:
	incbin palettes/pal_charsel_05_b.bin
pal_charsel_06:
	incbin palettes/pal_charsel_06_b.bin
;-----------------------------------------
; Character OBJ palette sets
;-----------------------------------------
pal_sprite_guy:
	incbin palettes/pal_guy_sprite.bin
pal_sprite_cody:
	incbin palettes/pal_cody_sprite.bin
pal_sprite_haggar:
	incbin palettes/pal_haggar_sprite.bin
	
	


;-------------------------------------------------------

; Register contents
; 
; A4 = Current player RAM addr
; A6 = Charsel RAM addr

hijack_charsel_inputcheck_joystick
	move.b  ($83,A4), D0
    not.b   D0
    and.b   ($82,A4), D0	; get new button presses for this frame
	; new code begins here
	move.b	D0,D1
	andi.b	#$0C, D1		; test if U/D pressed
	beq		hijack_charsel_inputcheck_joystick_checklr ; check L/R if U/D not pressed
	bra		hijack_charsel_inputcheck_joystick_ud
hijack_charsel_inputcheck_joystick_checklr:
	jmp		$05C586
	
hijack_charsel_inputcheck_joystick_ud:
	btst	#$03, D0	; check if U pressed
	beq		hijack_charsel_inputcheck_joystick_d
	bsr		hijack_charsel_charcolor_inc
	jsr		$05C6C8		; draw_border
	rts
	
hijack_charsel_inputcheck_joystick_d:
	btst	#$02, D0	; check if D pressed
	bsr		hijack_charsel_charcolor_dec
	jsr		$05C6C8		; draw_border
	rts
	
hijack_charsel_charcolor_inc:
	movea.l	#playerpalette_selection_current_1p,A0
	add.w	d7,a0
	move.b	(a0),d0
	add.b	#$01,d0
	cmpi.b	#$7,d0		; check if max exceeded
	bne		hijack_charsel_charcolor_inc_write
	moveq	#$00,d0	
	
hijack_charsel_charcolor_inc_write:
	move.b	d0,(a0)
	rts
	
hijack_charsel_charcolor_dec:
	movea.l	#playerpalette_selection_current_1p,A0
	add.w	d7,a0
	move.b	(a0),d0
	subi.b	#$01,d0
	btst	#$7,d0		; check if negative (went below min)
	beq		hijack_charsel_charcolor_dec_write
	move.b	#$06,d0	
	
hijack_charsel_charcolor_dec_write:
	move.b	d0,(a0)
	rts
; WIP	;;======================================
; WIP	;;
; WIP	;;  HIJACK_CHARSEL_CHARCOLOR_TESTRESERVE
; WIP	;;
; WIP	;; Tests if the color selection for this character (prior to committing) is already selected by another player
; WIP	;; A4 contains the addr for the current player
; WIP	;
; WIP	;tbl_hijack_charsel_charcolor_testreserve_seladdr:	; charsel RAM player selection addrs
; WIP	;	dc.l	$FFFF1524, $FFFF152C, $FFFF1530
; WIP	;
; WIP	;hijack_charsel_charcolor_testreserve:	
; WIP	;	jsr		ingame_charsel_portraitdraw_playerid_get  ; Returns Player ID to D0
; WIP	;	movea.l	#playerpalette_selection_current_1p,A0
; WIP	;	adda.w	D0, A0
; WIP	;	move.l	D0, D1
; WIP	;	asl.w	#2, D1
; WIP	;	movea.l tbl_hijack_charsel_charcolor_testreserve_seladdr(PC,D1.w), A1
; WIP	;	move.w	(A1), D1
; WIP	;	asr.w	#1, D1	; halve the selected char's ID
; WIP	;	movea.l #playerpalette_reserve_guy, A1
; WIP	;	adda.w	D1, A1
	
	
	
	
;	moveq	#0, D1
;	move.b	D0, D1
	
	

;======================================

hijack_namebar_draw_player:
	move.w	(A0)+, D1
	
;===========================
; NAMEBAR PORTRAIT PALETTES
;===========================

pal_scroll1_statusbar_portraits:
	incbin palettes/pal_scroll1_guyportrait_00.bin
	incbin palettes/pal_scroll1_guyportrait_01.bin
	incbin palettes/pal_scroll1_guyportrait_02.bin
	incbin palettes/pal_scroll1_guyportrait_03.bin
	incbin palettes/pal_scroll1_guyportrait_04.bin
	incbin palettes/pal_scroll1_guyportrait_05.bin
	incbin palettes/pal_scroll1_guyportrait_06.bin
	incbin palettes/pal_scroll1_codyportrait_00.bin
	incbin palettes/pal_scroll1_codyportrait_01.bin
	incbin palettes/pal_scroll1_codyportrait_02.bin
	incbin palettes/pal_scroll1_codyportrait_03.bin
	incbin palettes/pal_scroll1_codyportrait_04.bin
	incbin palettes/pal_scroll1_codyportrait_05.bin
	incbin palettes/pal_scroll1_codyportrait_06.bin
	incbin palettes/pal_scroll1_haggarportrait_00.bin
	incbin palettes/pal_scroll1_haggarportrait_01.bin
	incbin palettes/pal_scroll1_haggarportrait_02.bin
	incbin palettes/pal_scroll1_haggarportrait_03.bin
	incbin palettes/pal_scroll1_haggarportrait_04.bin
	incbin palettes/pal_scroll1_haggarportrait_05.bin
	incbin palettes/pal_scroll1_haggarportrait_06.bin

;===================================
; INGAME CHARSEL PORTRAIT PALETTES
;===================================
	
tbl_ingame_charsel_portrait_palettes_guy:
	incbin	palettes\pal_scroll1_ingame_charsel_guy_00.bin
	incbin	palettes\pal_scroll1_ingame_charsel_guy_01.bin
	incbin	palettes\pal_scroll1_ingame_charsel_guy_02.bin
	incbin	palettes\pal_scroll1_ingame_charsel_guy_03.bin
	incbin	palettes\pal_scroll1_ingame_charsel_guy_04.bin
	incbin	palettes\pal_scroll1_ingame_charsel_guy_05.bin
	incbin	palettes\pal_scroll1_ingame_charsel_guy_06.bin
			
tbl_ingame_charsel_portrait_palettes_cody:
	incbin	palettes\pal_scroll1_ingame_charsel_cody_00.bin
	incbin	palettes\pal_scroll1_ingame_charsel_cody_01.bin
	incbin	palettes\pal_scroll1_ingame_charsel_cody_02.bin
	incbin	palettes\pal_scroll1_ingame_charsel_cody_03.bin
	incbin	palettes\pal_scroll1_ingame_charsel_cody_04.bin
	incbin	palettes\pal_scroll1_ingame_charsel_cody_05.bin
	incbin	palettes\pal_scroll1_ingame_charsel_cody_06.bin
	
tbl_ingame_charsel_portrait_palettes_haggar:
	incbin	palettes\pal_scroll1_ingame_charsel_haggar_00.bin
	incbin	palettes\pal_scroll1_ingame_charsel_haggar_01.bin
	incbin	palettes\pal_scroll1_ingame_charsel_haggar_02.bin
	incbin	palettes\pal_scroll1_ingame_charsel_haggar_03.bin
	incbin	palettes\pal_scroll1_ingame_charsel_haggar_04.bin
	incbin	palettes\pal_scroll1_ingame_charsel_haggar_05.bin
	incbin	palettes\pal_scroll1_ingame_charsel_haggar_06.bin
	
;========================================================
; Draw character portrait, in game char select, all players
;========================================================

tbl_ingame_charsel_vramdest:
	dc.l	$90888C, $90900C, $90980C
	
tbl_ingame_charsel_portraitsrc:
	dc.l	$000CA270, $000CA300, $000CA390

hijack_ingame_charsel_portraitdraw:
	jsr		ingame_charsel_portraitdraw_playerid_get
	move.w	D0, D5
	add.w   D0, D0
	add.w   D0, D0
	movea.l tbl_ingame_charsel_vramdest(PC,D0.w), A1

	jsr		ingame_charsel_portraitdraw_palettes
	
	move.b	tbl_ingame_charsel_attribute(PC,D5.w), D1

	moveq   #$0, D0
	move.b  ($81,A4), D0	; player's character selection
	add.w   D0, D0
	add.w   D0, D0
	movea.l tbl_ingame_charsel_portraitsrc(PC,D0.w), A2
	
	
	
	; prep loops for 6x6 tile portrait draw
	move.w  #$5, D4			

ingame_charsel_portraitdraw_loop1:
	move.w  #$5, D5

ingame_charsel_portraitdraw_loop2:
	moveq   #$0, D0
	move.w  (A2)+, D0
	addi.w  #$4400, D0		; tile bank mod
	move.w  D0, (A1)
	move.w  (A2)+, D0
	add.w   D1, D0		; attribute mod
	ori.w	#$80, D0	; priority bit
	move.w  D0, ($2,A1)
	lea     ($80,A1), A1
	dbra    D5, ingame_charsel_portraitdraw_loop2
	
	lea     (-$2fc,A1), A1
	dbra    D4, ingame_charsel_portraitdraw_loop1
	
	rts
;========================================================

tbl_ingame_charsel_attribute:
	dc.b	$1A, $1C, $1E, $00


;========================================================
; Clear character portrait, in game char select, all players
;========================================================
tbl_ingame_charsel_clear_vramdest:
	dc.l	$0090888C, $0090900C, $0090980C


hijack_ingame_charsel_portraitclear:
	jsr		ingame_charsel_portraitdraw_playerid_get
	add.w   D0, D0
	add.w   D0, D0
	movea.l #tbl_ingame_charsel_clear_vramdest, A0
	adda.w	D0, A0
	movea.l (A0), A1
	
	move.w  #$5, D4

    move.w  D4, temp_var_0
	
	bsr clear_scroll_1
	
	rts


;========================================================
; A1 - start position
; D4 - number of rows minus one
; temp_var_0 - number of columns minus one
;--------------------------------------------------------
clear_scroll_1:
    move.l A1, temp_var_1 
	move.w  temp_var_0, D5

clear_scroll_1_loop2:
	move.w  #$4420, (A1)
	move.w  #$0, ($2,A1)
	
	lea     ($80,A1), A1
	dbra    D5, clear_scroll_1_loop2
	
	move.l temp_var_1, D0 ; Load start position
	addq.l #$4, D0 ; Move 1 row down
	move.l D0, temp_var_1 ; Store new start
	movea.l D0, A1 ; Load new start position in A1
	
	dbra    D4, clear_scroll_1
	
	rts
;========================================================

;========================================================
; Draws the palette and gets attribute offset for this player's portrait
; Has its own subroutine so that the PC relative tables in the portrait draw code wouldn't be pushed out of range.
tbl_ingame_charsel_paldest:
	dc.l	$00914740, $00914780, $009147C0
	
ingame_charsel_portraitdraw_palettes:
	move.w	D5, D0
	movea.l	#playerpalette_selection_current_1p, A0
	adda.w	D0,A0
	moveq	#0,D1
	move.b	(A0),D1		; player's color selection
	
	add.w   D0, D0
	add.w   D0, D0
	movea.l tbl_ingame_charsel_paldest(PC,D0.w), A0
	
	move.b  ($81,A4), D0	; player's character selection
	cmpi.w	#1, D0			; check if Cody
	beq 	ingame_charsel_portraitdraw_palettes_cody
	
	tst.w	D0
	bne		ingame_charsel_portraitdraw_palettes_haggar
	
	movea.l	#tbl_ingame_charsel_portrait_palettes_guy, A3
	bra		ingame_charsel_portraitdraw_palettes_guyhaggar_preploop
	
	
ingame_charsel_portraitdraw_palettes_haggar:
	movea.l	#tbl_ingame_charsel_portrait_palettes_haggar, A3
	bra		ingame_charsel_portraitdraw_palettes_guyhaggar_preploop
	
ingame_charsel_portraitdraw_palettes_cody:
	movea.l	#tbl_ingame_charsel_portrait_palettes_cody, A3
	asl		#6, D1  ; color selection * 64 (Cody's palettes are twice as long as the others)
	adda.w	D1, A3
	moveq	#0, D4
	move.b	#$F, D4	; 0x10 long writes to copy Cody's palettes
	;DEBUG! DELETE LATER!
	;movea.l	#pal_scroll1_statusbar_portraits, A3
	;DEBUG! DELETE LATER!
	bra		ingame_charsel_portraitdraw_palettes_loop
	
ingame_charsel_portraitdraw_palettes_guyhaggar_preploop:
	asl		#5, D1	; color selection * 32
	adda.w	D1, A3
	moveq	#0, D4
	move.b	#$7, D4		; 8 long writes to copy Guy/Haggar's palettes
	;DEBUG! DELETE LATER!
	;movea.l	#pal_scroll1_statusbar_portraits, A3
	;DEBUG! DELETE LATER!
ingame_charsel_portraitdraw_palettes_loop:
	move.l	(A3)+,(A0)+
	dbra	D4, ingame_charsel_portraitdraw_palettes_loop
	
	rts
	

	

	

;=====================================
ingame_charsel_portraitdraw_playerid_get:
	moveq	#0, D0
	
	move.w	A4, D0
	subi.w	#$8000, D0
	cmpi.w	#p1_main_mem, D0
	beq		hijack_ingame_charsel_portraitdraw_is1p
	
	cmpi.w	#p2_main_mem, D0
	beq		hijack_ingame_charsel_portraitdraw_is2p
	move.w	#2, D0	; is 3p
	bra		hijack_ingame_charsel_portraitdraw_playeridentified
	
hijack_ingame_charsel_portraitdraw_is2p:
	move.w	#1, D0
	bra		hijack_ingame_charsel_portraitdraw_playeridentified
	
hijack_ingame_charsel_portraitdraw_is1p:
	moveq	#0, D0
	
hijack_ingame_charsel_portraitdraw_playeridentified:
	rts

	
;======================================
hijack_ingame_charsel_1p_readjoy:
	move.w	#0, D7	; player 1 ID
	jsr 	hijack_ingame_charsel_allplayers_readjoy
	tst.w	D1
	beq		hijack_ingame_charsel_1p_noupdown

	rts
hijack_ingame_charsel_1p_noupdown:
	jmp		0x015AB2	; return to 1P joy read for left/right test
;======================================
	
;======================================
hijack_ingame_charsel_2p_readjoy:
	move.w	A4, D7
	cmpi.w	#$E6E8, D7
	bne		hijack_ingame_charsel_2p_readjoy_is2p

	move.w	#2, D7	; player 3 ID
	bra		hijack_ingame_charsel_2p_readjoy_begin
	
hijack_ingame_charsel_2p_readjoy_is2p:
	move.w	#1, D7	; player 2 ID
hijack_ingame_charsel_2p_readjoy_begin:
	jsr 	hijack_ingame_charsel_allplayers_readjoy
	tst.w	D1
	beq		hijack_ingame_charsel_2p_noupdown

	rts

hijack_ingame_charsel_2p_noupdown:
	jmp		0x016320	; return to 2P joy read for left/right test
	
;======================================
	
hijack_ingame_charsel_allplayers_readjoy:	; returns 1 to D1 if color changed, 0 if no color change
	move.b  ($83,A4), D0
	not.b   D0
    and.b   ($82,A4), D0
	move.w	D0, D2	; preserve input data
	btst	#3, D0	; test if UP pressed
	beq		hijack_ingame_charsel_allplayers_readjoy_testdown
	bsr		hijack_charsel_charcolor_inc
	move.w	#1, D1	; color changed!
	rts
hijack_ingame_charsel_allplayers_readjoy_testdown:
	btst	#2, D0	; test if DOWN pressed
	beq		hijack_ingame_charsel_allplayers_readjoy_return
	bsr		hijack_charsel_charcolor_dec
	move.w	#1, D1	; color changed!
	rts
hijack_ingame_charsel_allplayers_readjoy_return:
	move.w	D2, D0	; restore input data
	moveq	#0, D1	; no color change!
	rts
	
	
;=====================================


	
	