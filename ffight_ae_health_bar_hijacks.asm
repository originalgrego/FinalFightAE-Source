;====================================================
hijack_draw_lives_click_in_gameplay:
  movea.l A6, A4
  tst.b ($13,A4) ; Check player id
  beq hijack_draw_lives_click_in_gameplay_p1
  
  cmp.b #$1, ($13,A4)
  beq hijack_draw_lives_click_in_gameplay_p2

  lea     $90968C.l, A1 ; P3
  jmp     $001e36

hijack_draw_lives_click_in_gameplay_p1:
  lea     $90878c.l, A1
  jmp     $001e36

hijack_draw_lives_click_in_gameplay_p2:
  lea     $908F0C.l, A1
  jmp     $001e36
;====================================================

;====================================================
hijack_p2_health_bar_full:
   btst.b  #$1, ($13,A4)
   beq health_bar_check_p2

   bra p3_health_bar   
 
health_bar_check_p2:
   lea $908F0C.l, A1
   jsr $001e36 ; Draw p2 lives

   jmp $001ED2
;====================================================

;================================================
scale_health_for_health_bar_draw:
  move.w  ($1c,A4), D3 ; Load entity max health
  beq     entity_health_load_empty_max_health

  lsr.w   #$1, D3
 
  move.w  ($1c,A4), D2
  lsr.w   #$3, D2

  add.w   D2, D3

  move.w  ($1c,A4), D2
  lsr.w   #$4, D2

  add.w   D2, D3

  move.w  ($18,A4), D1 ; Load entity health
  beq     entity_health_load_empty_health
  bmi     entity_health_load_empty_health
  lsr.w   #$1, D1
  
  move.w  ($18,A4), D2
  lsr.w   #$3, D2
  
  add.w   D2, D1

  move.w  ($18,A4), D2
  lsr.w   #$4, D2
  
  add.w   D2, D1
  
  jmp $001F4C

entity_health_load_empty_max_health:
  jmp $00201a
  
entity_health_load_empty_health:
  jmp $001fec 
;================================================

hijack_p1_draw_health_icon:
	move.w	(-$6DA4,A5),D0
	moveq	#0,D1
	moveq	#0,D2
	moveq	#0,D4
	move.b	($7FE3,A5),D1	; player 1 palette selection
	move.b	($57C,A5),D2	; player 1 character

	jsr 	$1d78
	
	jmp		$1EBA

;====================================================
hijack_p2_draw_health_bar:
   btst.b  #$1, ($13,A4)
   beq p2_draw_health_bar
   
   bra p3_draw_health_bar

p2_draw_health_bar:
   lea     $908D10.l, A0
   move.w  (-$6da6,A5), D6   ; Load a palette that is ignored lol
   bra draw_health_bar_continue
;====================================================

;====================================================
hijack_p2_draw_health_icon
   btst.b  #$1, ($13,A4)
   beq p2_draw_health_icon
   
   bra p3_draw_health_icon
   
p2_draw_health_icon:
   lea     $908D10.l, A1
   move.w  (-$6da4,A5), D0
   moveq	#0,D1
   moveq	#0,D2
   moveq	#0,D4
   move.b	($7FE4,A5),D1	; player 2 palette selection
   move.b	($63C,A5),D2	; player 2 character
   move.b	#1,D4			; player 2 ID

   jmp $001EEA
;====================================================
 
;====================================================   
p3_health_bar:
  lea     $90968C.l, A1
  jsr     $001e36 ; Draw p3 lives
  
  moveq   #$0, D0
  move.b  ($14,A4), D0
  add.b   D0, D0
  add.b   D0, D0
  add.l   #$001F1A, D0
  movea.l D0, A0
  movea.l (A0), A0
  
p3_draw_health_icon:
  lea     $909490.l, A1
  moveq   #$0, D0
   moveq	#0,D1
   moveq	#0,D2
	moveq	#0,D4
	move.b	#2,D4
   move.b	($7FE5,A5),D1	; player 3 palette selection
   move.b	($66FC,A5),D2	; player 3 character
  jsr     hijack_player_namebar ; Draw p3 icon
  
p3_draw_health_bar:
  lea     $909490.l, A0
  move.w  ($18,A4), D6 ; Derp, does nothing, d6 hardcoded for player to 181
  move.w  #$0001, D6 ; Derp

draw_health_bar_continue:
  beq p3_draw_bad_health_bar
  
  jmp $001F2A
  
p3_draw_bad_health_bar:
  jmp $001f26
;====================================================
 
;====================================================
hijack_item_target_queue_check:
   btst.b  #$1, ($13,A6)
   beq item_target_check_p2

   bra p3_target_queue
   
item_target_check_p2:
   btst.b  #$0, ($13,A6)
   beq item_target_p1

   bra p2_target_queue
   
item_target_p1:
   bra p1_target_queue
;====================================================
   
;====================================================
hijack_smash_hit_item_target_check_impl:
   btst.b  #$1, ($13,A1)
   beq smash_hit_item_check_p2

   bra p3_target_queue
   
smash_hit_item_check_p2:
   btst.b  #$0, ($13,A1)
   beq smash_hit_item_p1

   bra p2_target_queue
   
smash_hit_item_p1:
   bra p1_target_queue
;====================================================

;====================================================
hijack_throw_enemy_target_check:
   btst.b  #$1, ($13,A0)
   beq throw_enemy_target_check_p2

   bra p3_target_queue
   
throw_enemy_target_check_p2:
   btst.b  #$0, ($13,A0)
   beq throw_enemy_target_p1

   bra p2_target_queue
   
throw_enemy_target_p1:
   bra p1_target_queue
;====================================================

;====================================================
hijack_after_enemy_throw_target_check:
   btst.b  #$1, ($69,A6)
   beq after_enemy_throw_target_check_p2

   bra p3_target_queue
   
after_enemy_throw_target_check_p2:
   btst.b  #$0, ($69,A6)
   beq after_enemy_throw_target_p1

   bra p2_target_queue
   
after_enemy_throw_target_p1:
   bra p1_target_queue
;====================================================

;====================================================
p3_target_queue:
   tst.b   ($122,A5)
   bne     p3_target_queue_exit

   lea     (p3_target_queue_offset,A5), A0 ; Load p3 target queue
   move.w  (p3_target_queue_tail_offset,A5), D1 ; Load p3 target queue head/tail
   
   move.w  A3, (A0,D1.w)
   move.w  ($18,A3), ($2,A0,D1.w)
   move.w  ($1a,A3), ($4,A0,D1.w)
   move.w  ($1c,A3), ($6,A0,D1.w)

   addq.w  #8, D1
   andi.w  #$7f, D1
   move.w  D1, (p3_target_queue_tail_offset,A5)
   
p3_target_queue_exit:
   rts
;====================================================
   
;====================================================
p2_target_queue:   
   jmp $0028CA
;====================================================

;====================================================
p1_target_queue:
   jmp $00289A
;====================================================

;====================================================
handle_a1_pvp_target_queue:
   btst.b  #$1, ($13,A1)
   beq check_p2_pvp_queue

   bsr p3_target_queue
   rts

check_p2_pvp_queue:
   btst.b  #$0, ($13,A1)
   beq p1_pvp_queue

   bsr p2_target_queue
   rts

p1_pvp_queue:
   bsr p1_target_queue
   rts   
;====================================================


;====================================================
hijack_pvp_target_queue:
   bsr handle_a1_pvp_target_queue
   exg A1, A3

   bsr handle_a1_pvp_target_queue
   exg A1, A3

   rts
;====================================================

;====================================================
p3_sim_and_draw_target_queue:
   lea     (p3_main_target_queue_data, A5), A6 ; Main target queue memory
   jsr     $05b456

   tst.b   (A6)
   beq     p3_sim_and_draw_target_queue_continue
   bpl     p3_sim_and_draw_target_queue_goto_handler

p3_sim_and_draw_target_queue_continue:
   lea     (p3_target_queue_offset,A5), A4
   move.w  (p3_target_queue_head_offset,A5), D7
   cmp.w   (p3_target_queue_tail_offset,A5), D7
   beq     p3_sim_and_draw_target_queue_exit

   moveq   #$0, D0
   move.w  (A4,D7.w), D0
   beq     p3_sim_and_draw_target_queue_exit

   lea     (A4,D7.w), A4
   move.w  #$0, (A4)+
   addq.w  #8, D7
   andi.w  #$7f, D7
   move.w  D7, (p3_target_queue_head_offset,A5)
   
p3_sim_and_draw_target_queue_load_target_location:
   move.l  #$909498, D1 ; Load target life bar location
   jmp     $05b2f0 ; Calculate main target queue data

p3_sim_and_draw_target_queue_exit:
   tst.b   (A6)
   bne     p3_sim_and_draw_target_queue_goto_handler

   bra p3_check_item_throw_or_boss

p3_sim_and_draw_target_queue_goto_handler:
   jmp $05b368
;====================================================


;====================================================
p3_check_item_throw_or_boss:
   tst.b   (p3_main_mem,A5)
   beq p3_check_item_throw_or_boss_exit

p3_check_item_throw_or_boss_continue:
   tst.b   ($672A,A5) ; 42
   beq p3_check_item_boss_check    

p3_check_item_throw_or_boss_last:
   move.w  ($672C,A5), D0 ;44  
   movea.w D0, A4
   lea     ($18,A4), A4
   bra     p3_sim_and_draw_target_queue_load_target_location

p3_check_item_boss_check:
   move.w  ($12e,A5), D0 ; Boss check
   beq     p3_check_item_throw_or_boss_exit

   movea.w D0, A4
   lea     ($18,A4), A4
   clr.w   ($3c,A6)
   bra     p3_sim_and_draw_target_queue_load_target_location

p3_check_item_throw_or_boss_exit:
  rts   
;====================================================

;====================================================
hijack_p12_score_and_target_selector:
   jsr $05B1F4
   jsr $05B272
   bra p3_sim_and_draw_target_queue
;====================================================

;====================================================
hijack_player_check_target_queue_handler:
   btst.b  #$1, ($88,A6)
   beq check_p2_target_queue_handler

   lea (p3_main_mem,A5), A0
   bra hijack_player_check_target_queue_handler_exit

check_p2_target_queue_handler:
   btst.b  #$0, ($88,A6)
   beq p1_target_queue_handler
   
   lea (p2_main_mem,A5), A0
   bra hijack_player_check_target_queue_handler_exit
   
p1_target_queue_handler:
   lea (p1_main_mem,A5), A0

hijack_player_check_target_queue_handler_exit:
   jmp $05B376
;====================================================

;====================================================
hijack_character_portrait_calc 
   tst.b   ($12,A6)
   beq character_portrait_is_player

   move.b  ($13,A6), D0 ; Load player/entity id
   add.b   D0, D0
   bra character_portrait_calc_exit
 
character_portrait_is_player:
   move.b #$0, D0

character_portrait_calc_exit:
   move.w  (A0,D0.w), D1
   jmp $05B604
;====================================================

hijack_player_namebar:
	adda.w	#2,A0		; increment A0 (this player's portrait/namebar data pointer) because we don't care about the portrait attribute byte anymore
	
	movea.l	#pal_scroll1_statusbar_portraits,A2	; this table is in charsel_hijacks
	move.l	D2,D3
	asl.l	#3,D3
	sub.b	D2,D3		; character ID * 7
	add.b	D3,D1		; add palette selection byte
	asl.l	#5,D1		; * 32
	adda.w	D1,A2
	
	movea.l	#tbl_playerportrait_scroll1_vram_palette_pointers,A3
	move.l	D4,D3
	asl.l	#2,D3
	adda.w	D3,A3
	movea.l	(A3),A3	; offset for portrait palette vram dest
	
	move.b	#7,D3
hijack_player_namebar_portrait_palette_write_loop:		; write portrait palette to vram
	move.l	(A2)+,(A3)+
	dbra	D3, hijack_player_namebar_portrait_palette_write_loop
	
	movea.l #tbl_playerportrait_attributes,A3
	move.l 	D4,D3
	asl.l	#1,D3
	adda.w	D3,A3
	move.w	(A3),D0		; attribute for this player's portrait

    tst.b   ($53a9,A5)
    beq     hijack_player_namebar_drawtiles
    
    lea     ($2000,A1), A1		; increment SCROLL1 dest
	
hijack_player_namebar_drawtiles:
    lea     (-$104,A1), A1
    move.w  (A0)+, (A1)+
    move.w  D0, (A1)+
    move.w  (A0)+, (A1)+
    move.w  D0, (A1)+
    lea     ($78,A1), A1
    move.w  (A0)+, (A1)+
    move.w  D0, (A1)+
    move.w  (A0)+, (A1)+
    move.w  D0, (A1)+
    lea     ($78,A1), A1
    move.w  (A0)+, D0
    move.w  (A0)+, (A1)+
    move.w  D0, (A1)+
    lea     ($7c,A1), A1
    move.w  (A0)+, (A1)+
    move.w  D0, (A1)+
    lea     ($7c,A1), A1
    move.w  (A0)+, (A1)+
    move.w  D0, (A1)+
    lea     ($7c,A1), A1
    move.w  (A0)+, (A1)+
    move.w  D0, (A1)+
    rts
	
tbl_playerportrait_scroll1_vram_palette_pointers:
	dc.l	$914740, $914780, $9147C0
	
tbl_playerportrait_attributes:
	dc.w	$1A, $1C, $1E
	
;====================================================
	
	
	
	
	
	