;================================================
hijack_player_2_hitbox_init:
  lea     ($53a2, A5), A0
  jsr     $0097e2

  bsr p3_init_hitboxes

  rts
;================================================
  
;================================================
; Player 3 hitbox init
p3_init_hitboxes:
  move.w  #$15, ($736a,A5)
  move.l  #$fff36a, ($736c,A5)
  clr.l   ($5308,A5)
  clr.l   ($530c,A5)
  move.w  #$14, D7
  lea     ($736a, A5), A0
  jsr     $0097e2

  move.w  #$15, ($73a2,A5)
  move.l  #$fff36a, ($73a4,A5)
  move.w  #$14, D7
  lea     ($73a2, A5), A0
  jsr     $0097e2
  
  rts
;================================================
   
;================================================
hijack_player_2_init_char_select:
  btst    #$1, ($7f,A5)
  beq     hijack_player_2_init_char_select_check_p3
  
  jsr     $009f9c

hijack_player_2_init_char_select_check_p3:
  btst    #$2, ($7f,A5)
  beq     hijack_player_2_init_char_select_exit

  bsr p3_init_char_select

hijack_player_2_init_char_select_exit:  
  rts
;================================================
  
;================================================
p3_init_char_select:
  bsr p3_init_more
  
  lea (p3_main_mem,A5), A4
  jsr $00a2ba ; Clear ram
  
  move.b  ($85,A5), ($80,A4)
  move.b  #$1, ($0,A4) ; Initialize player
  move.b  #$2, ($13,A4)
  move.b  #$82, ($2F,A4)  ; palette assignment 

  movea.l ($b6,A5), A1
  move.w  (A1), ($92,A4) 
  
  bsr p3_a032
  
  rts
;================================================

;================================================  
handle_two_player_init:
	lea 	(p2_main_mem,A5), A4
    jsr 	$009F7C
	move.b  #$1, ($13,A4)
	move.b	#$81, ($2F,A4) ; palette assignment
;	jsr		hijack_charsel_copypalette
	rts
;================================================  
	
;================================================  
handle_player_three_init:
	lea 		(p3_main_mem,A5), A4
	jsr 		$009F7C
	move.b  	#$2, ($13,A4)	
	move.b  	#$82, ($2F,A4)  ; palette assignment 
;	jsr			hijack_charsel_copypalette
	rts
;================================================  
   
;================================================
player_3_main_init:
   lea     (p3_main_mem,A5), A4
   move.l  ($84,A4), -(A7)
   move.b  ($81,A4), -(A7)
   move.b  ($90,A4), -(A7)
   move.w  ($92,A4), -(A7)

   bsr 		p3_init_more
   bsr 		handle_player_three_init

   move.w  (A7)+, ($92,A4)
   move.b  (A7)+, ($90,A4)
   move.b  (A7)+, ($81,A4)
   jsr     $00a0fe
   
   bsr     p3_a032

   jsr     $00A084 ; Go here instead of a070, the player address is already loaded in a4... 
   jsr     $00a106

   move.l  (A7)+, ($84,A4)
   
   jmp 		$00A17C
;================================================

;================================================
; Player 3 version of a032, called by a070
p3_a032:
;   lea     ($4df4,A5), A3
;   lea     (-$4d00,A5), A2
   lea     ($4dee,A5), A3
   lea     (-$4e80,A5), A2
   jsr     $00a042
   rts
;================================================

;================================================
p3_init_level_start:
  bsr     p3_a032
  
  btst    #$2, ($7f,A5)
  beq     p3_init_level_start_exit

  lea     (p3_main_mem,A5), A4
  jmp     $00a084

p3_init_level_start_exit:
  rts
;================================================

;================================================
hijack_clear_player_2_ram_char_select:
  bsr p3_init_more
  
  lea (p3_main_mem,A5), A4
  jsr $00a2ba ; Clear player ram

  movea.l ($b6,A5), A1
  move.w  (A1), ($92,A4)

  ; Do p2 stuff  
  jsr $009fec

  lea (p2_main_mem,A5), A4
  jsr $00a2ba ; Clear player ram

  jmp $009F50
;================================================

;================================================
p3_init_more:
   clr.l   (p3_main_target_queue_data,A5) ; Clear main target queue data
   move.b  #$2, (p3_main_target_queue_data_play_id,A5)
   clr.w   (p3_main_target_queue_data_play_mem_ref,A5)

   clr.w   D0
   move.w  D0, (p3_target_queue_head_offset, A5) ; Clear target queue head/tail
   move.w  D0, (p3_target_queue_tail_offset, A5)

   move.l  #$1f, D0
   moveq   #$0, D1
   lea     (p3_target_queue_offset,A5), A0 ; Load target queue for clearing

p3_init_more_loop:
   move.l  D1, (A0)+
   dbra    D0, p3_init_more_loop
   rts
;================================================
  
;================================================
hijack_init_players_level_start
  jsr     $00a05c
  jsr     $00a070
  bsr     p3_init_level_start
  rts  
;================================================
  
;================================================
hijack_player_2_init_2_demo:
  btst    #$1, ($7f,A5)
  beq     hijack_player_2_init_2_demo_p3
  jsr     $009fec

  lea     (p2_main_mem,A5), A4
  jsr     $00a398

hijack_player_2_init_2_demo_p3:
  btst    #$2, ($7f,A5)
  beq     hijack_player_2_init_2_demo_exit
  bsr     p3_init_more

  lea     (p3_main_mem,A5), A4 
  jmp     $00a398

hijack_player_2_init_2_demo_exit:
  rts  
;================================================

hijack_player_1_init_idvar:
	move.b	#0,($13,A4)		; player ID 
	move.b	#$80,($2F,A4)		; palette ID
;	jsr		hijack_charsel_copypalette
	jmp 	$009F92

;================================================
