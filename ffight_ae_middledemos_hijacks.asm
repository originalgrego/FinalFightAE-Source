; ============================================
xmiddledemos_playerassign:
	move.w	#p3_main_mem, D1	; 3p ram as leader
	move.w	#p2_main_mem, D2	; 2p ram as follower1
	
	tst.b	(A5,D1.w)		; check if leader is active
	beq		xmiddledemos_playerassign_leaderinactive
	
	addi	#$13, D1	; increment leader address to player number ID
	move.b	($13,A6), D4	; Load current player's player number ID
	move.b	(A5,D1.w), D5
	cmp.b	D4, D5
	bne		xmiddledemos_playerassign_notleader ; branch if leader active and this player != leader
	
	move.b	#0, ($91,a6)	; This player is the leader!
	rts	
	
	
xmiddledemos_playerassign_leaderinactive:	; Leader is dead, but you and at least one other player are still alive.
	tst.b	(A5,D2.w)		; Check if follower1 is available.
	beq xmiddledemos_playerassign_leaderinactive_newleader	; If leader and follower1 are both inactive, current player is leader by default.
	addi	#$13, D2	; increment follower1 address to player number ID
	move.b	($13,A6), D4	; Load current player's player number ID
	move.b  (A5,D2.w), D5
	cmp.b	D4, D5
	bne xmiddledemos_playerassign_leaderinactive_isfollower
	
xmiddledemos_playerassign_leaderinactive_newleader:
	move.b #00, ($91,a6)
	rts
	
xmiddledemos_playerassign_leaderinactive_isfollower:
	move.b #$FF, ($91,a6)
	rts
	
xmiddledemos_playerassign_notleader:	; Leader is alive, but you ain't him.
	move.b #$FF, ($91,a6)
	rts
; ============================================

xvscroll_type1_2_2_4_2_playervpos:
	move.l  ($80,A6), D0
	add.l   D0, ($572,A5)
	add.l   D0, ($576,A5)
	add.l   D0, ($632,A5)
	add.l   D0, ($636,A5)
	add.l   D0, ($66F2,A5)
	add.l   D0, ($66F6,A5)
	add.l   D0, ($a,A6)
	lsr.l   #7, D0
	sub.l   D0, ($572,A5)
	sub.l   D0, ($576,A5)
	sub.l   D0, ($632,A5)
	sub.l   D0, ($636,A5)
	sub.l   D0, ($66F2,A5)
	sub.l   D0, ($66F6,A5)
	sub.l   D0, ($a,A6)
	rts
; ============================================	

xmiddledemos_4_6:
	tst.b   ($a6,A6)
	beq     xmiddledemos_4_6_elevstop
	jsr     $cc72
	jsr     $cc42
	tst.b   ($a6,A6)
	bne     xmiddledemos_4_6_return	
	move.b  #$0, ($2e,A6)
	jmp     $c47a.l	; player_start_or_stop_walking
	
xmiddledemos_4_6_elevstop:
	bsr		xmiddledemos_solocheck
	beq     xmiddledemos_4_6_issolo
	tst.b   ($91,A6)
	beq     xmiddledemos_4_6_isleader
xmiddledemos_4_6_issolo:
	jsr     $cc1a
	bne     xmiddledemos_4_6_return
	move.b  #$1, ($56b2,A5)
	move.b  #$1, (-$6dfe,A5)
	bra     xmiddledemos_4_6_nextstate
	
xmiddledemos_4_6_isleader:
	tst.b   (-$6dfe,A5)
	beq     xmiddledemos_4_6_return
	clr.b   (-$6dfe,A5)
	
xmiddledemos_4_6_nextstate:	
	move.b  #$8, ($4,A6)
	
xmiddledemos_4_6_return:
	rts
	

	
; ============================================	

xmiddledemos_4_C:
	tst.b   ($a6,A6)
	beq     xmiddledemos_4_C_donewalking
	jsr     $3146.w	; demo_player_movement
	jsr     $3b02.w ; entity_play_anim
	move.l  ($a,A6), ($e,A6)
	move.w  ($6,A6), D0
	subi.w  #$6b0, D0
	cmpi.w  #$b8, D0
	bcs     xmiddledemos_4_C_return
	clr.b   ($a6,A6)
	jsr     $c47a.l ;player_start_or_stop_walking
	
xmiddledemos_4_C_donewalking:
	bsr		xmiddledemos_solocheck
	beq		xmiddledemos_4_C_issolo
	tst.b   ($91,A6)
	beq     xmiddledemos_4_C_isleader
xmiddledemos_4_C_issolo:
	jsr     $cc1a
	bne     xmiddledemos_4_C_return
	move.b  #$1, ($56b2,A5)
	move.b  #$1, (-$6dfe,A5)
	bra     xmiddledemos_4_C_nextstate
	
xmiddledemos_4_C_isleader:
	tst.b   (-$6dfe,A5)
	beq     xmiddledemos_4_C_return
	clr.b   (-$6dfe,A5)
	
xmiddledemos_4_C_nextstate:
	move.b  #$e, ($4,A6)
	
xmiddledemos_4_C_return:
	rts
	
; ============================================	
; A hacky attempt at fixing the Uptown elevator demo if only one player is playing
; Returns 0 if player is the only one alive, else returns 1

xmiddledemos_solocheck
	moveq	#0, D0
	move.b	($13,A6), D0
	asl		#$2, D0
	lea		(tbl_xmiddledemo_otherplayers), A0
	adda.w	D0, A0
	move.w	(A0), D1
	adda.w	#$02, A0
	move.w	(A0), D2
	tst.b	(A5,D1.w)
	bne		xmiddledemos_notsolo
	tst.b	(A5,D2.w)
	bne		xmiddledemos_notsolo
	moveq	#0, D0
	rts
	
xmiddledemos_notsolo:
	moveq	#1, D0
	rts
	

tbl_xmiddledemo_otherplayers:
	dc.w	$628, $66E8, $568, $66E8, $568, $628