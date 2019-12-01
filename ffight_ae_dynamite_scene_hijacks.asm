;==========================================================
hijack_dynamite_scene_check_player_active:  
  tst.b   (p1_main_mem,A5)
  bne     hijack_dynamite_scene_check_player_active_success

  tst.b   (p2_main_mem,A5)
  bne     hijack_dynamite_scene_check_player_active_success

  tst.b   (p3_main_mem,A5)
  bne     hijack_dynamite_scene_check_player_active_success
  
  jmp $05DAFC
  
hijack_dynamite_scene_check_player_active_success:
  jmp $05db40
;==========================================================

;==========================================================
hijack_dynamite_scene_clear_player_status_bit:
  clr.b   (-$6a0a,A5) ; P1's draw handler address
  clr.b   (-$69da,A5) ; P2's draw handler address
  clr.b   (-$69aa,A5) ; P3's draw handler address

  jmp $05DD80
;==========================================================

;==========================================================
hijack_dynamite_scene_initialize_player_draw_handler:
  btst    #$2, ($46,A6) ; Check status bit for p3
  beq     hijack_dynamite_scene_initialize_player_draw_handler_exit

  tst.b   (p3_main_mem,A5) ; Check p3
  bne     hijack_dynamite_scene_initialize_player_draw_handler_exit

  lea     (p3_main_mem,A5), A1
  lea     (-$69aa,A5), A2 ; P3's draw handler address
  jsr     $05ddc6 ; Init handler
  
hijack_dynamite_scene_initialize_player_draw_handler_exit:
  rts
;==========================================================

;==========================================================
hijack_dynamite_scene_call_draw_handlers
  lea     (-$6a0a,A5), A4 ; p1
  jsr     $05e1e4
  lea     (-$69da,A5), A4 ; p2
  jsr     $05e1e4
  lea     (-$69aa,A5), A4 ; p3
  jmp     $05e1e4
;==========================================================

;==========================================================
hijack_dynamite_scene_set_x_position:
   move.w  D0, -(A7)
  
   move.b  ($13,A2), D0
   beq hijack_dynamite_scene_set_x_position_p1
   
   btst #$0, D0
   beq hijack_dynamite_scene_set_x_position_p3
   
   move.w  #$70, ($6,A2) ; X position
   move.w  #$a0, ($20,A2) ; Head x position
   bra hijack_dynamite_scene_set_x_position_exit
   
hijack_dynamite_scene_set_x_position_p3:
   move.w  #$100, ($6,A2) ; X position
   move.w  #$130, ($20,A2) ; Head x position
   bra hijack_dynamite_scene_set_x_position_exit
      
hijack_dynamite_scene_set_x_position_p1:
   move.w  #$fff0, ($6,A2) ; X position
   move.w  #$20, ($20,A2) ; Head x position

   move.b  ($14,A2), D0
   cmp.b   #$2, D0; Check haggar
   bne  hijack_dynamite_scene_set_x_position_exit
   
   subi.w #$10, ($20,A2) ; Fix p1 haggar head position

hijack_dynamite_scene_set_x_position_exit:
   move.w (A7)+, D0  
   add.b   D0, D0
   jmp $05DE00
;==========================================================

;==========================================================
hijack_dynamite_scene_knife_check: 
  cmpi.w  #$4, (-$6dba,A5) ; Check p2
  bne hijack_dynamite_scene_knife_check_p3

  move.b  #$1, ($1d,A6)
  
hijack_dynamite_scene_knife_check_p3:
  cmpi.w  #$4, ($7482,A5) ; Check p3
  bne hijack_dynamite_scene_knife_check_exit

  move.b  #$1, ($1d,A6)

hijack_dynamite_scene_knife_check_exit:
  rts
;==========================================================

;==========================================================
hijack_dynamite_scene_get_attributes:
	moveq	#0, D1
	move.b  ($13,A1), D1
	move.b	tbl_dynamite_attributes_baseaddr(PC,D1.w), D1
	add.b	D0, D1		; offset with character selection
	move.w  D1, ($1c,A2)
; attribute is primed, now copy the palette for this player's color selection
	move.l	A0, D6
	move.l	A1, D7			; preserve these addr registers
; palette src
	move.b  ($13,A1), D1	; get player ID again
	lea		(playerpalette_selection_current_1p).l, A1
	adda.w	D1, A1
	move.b	(A1), D1
	add.b	D1, D1
	add.b	D1, D1
	movea.l	tbl_dynamite_newpalettes_addr_src(pc,d1.w), A1
; palette dest
	movea.l	D7, A0
	move.b  ($13,A0), D1	; get player ID again
	add.b	D1, D1
	add.b	D1, D1
	movea.l	tbl_dynamite_newpalettes_addr_dest(pc,d1.w), A0
; now copy the palette
	move.w	#$1F, D1
hijack_dynamite_scene_copypalette_loop:
	move.l	(A1)+, (A0)+
	dbra	D1, hijack_dynamite_scene_copypalette_loop
	
	movea.l	D6, A0
	movea.l	D7, A1
	add.b	D0, D0
	jmp		0x05DDEC


tbl_dynamite_attributes_baseaddr:
	dc.b	$13, $17, $1B, $00
	
tbl_dynamite_newpalettes_addr_dest:
	dc.l	$914A60, $914AE0, $914B60

tbl_dynamite_newpalettes_addr_src:
	dc.l	dynamite_newpalettes_0, dynamite_newpalettes_1, dynamite_newpalettes_2, dynamite_newpalettes_3, dynamite_newpalettes_4, dynamite_newpalettes_5, dynamite_newpalettes_6
	
dynamite_newpalettes_0:
	incbin palettes/pal_dynamite_00.bin
dynamite_newpalettes_1:
	incbin palettes/pal_dynamite_01.bin
dynamite_newpalettes_2:
	incbin palettes/pal_dynamite_02.bin
dynamite_newpalettes_3:
	incbin palettes/pal_dynamite_03.bin
dynamite_newpalettes_4:
	incbin palettes/pal_dynamite_04.bin
dynamite_newpalettes_5:
	incbin palettes/pal_dynamite_05.bin
dynamite_newpalettes_6:
	incbin palettes/pal_dynamite_06.bin
	
;==========================================================

;==========================================================
hijack_dynamite_scene_drawportrait:
	clr.w   ($22,A4)
	clr.w   ($24,A4)
	move.b  #$2, ($2,A4)
	jsr     0x05E164	; dynamitescene_drawportrait
	
	moveq	#0, D0
	move.b	($14,A4), D0
	cmpi	#1, D0
	bne		hijack_dynamite_scene_drawportrait_return	; return if this is not Cody
	
; 10 colums of tiles
; 4 tiles per column for attribute mod

	movea.l	D1, A2		; retrieve vram dest addr
	addi.b	#2, D5		; Cody's new palette comes 2 after his default

	move.w	#9, D3		; column counter
	
hijack_dynamite_scene_drawportrait_loop_column:
	move.w	#3, D2		; tile counter
	
hijack_dynamite_scene_drawportrait_loop_tile:
	move.w  D5, ($2,A2)
	lea     ($4,A2), A2
	dbf		D2, hijack_dynamite_scene_drawportrait_loop_tile
	
	adda.w	#$30, A2
	dbf		D3, hijack_dynamite_scene_drawportrait_loop_column
	
hijack_dynamite_scene_drawportrait_return:
	rts

;==========================================================

;==========================================================
hijack_dynamite_scene_drawportrait_getlocation:
	jsr     $5e10e
	move.l	A0, D1		; D1 is unused during dynamitescene_drawportrait, now contains the vram dest so Cody's attributes can be modified after
	movea.l ($18,A4), A1
	jmp		$05E16A

;==========================================================