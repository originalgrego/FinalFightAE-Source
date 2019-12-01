xoutrodemos_playerassign:
	moveq	#0,d1
	move.b  ($BE,a5), d1	; load level ID
	add.b   d1, d1
	lea     (tbl_xoutrodemos_playerassign_lvl,PC), a0
	move.w  (a0,d1.w), d1
	lea     (a0,d1.w), a0
	moveq	#0,d1
	move.b  ($bf,a5), d1
	move.b	(a0,d1.w), d1
	add.b	d1, d1
	lea		(jtbl_xoutrodemos_playerassign_assigntbl), a0
	move.w	(a0,d1.w), d1
	jsr		jtbl_xoutrodemos_playerassign_assigntbl(pc,d1.w)
	
	lea		(A5,D1.w), A1
	tst.b	(A1)		; check if leader is active
	beq		xoutrodemos_playerassign_leaderinactive
	
	addi	#$13, D1	; increment leader address to player number ID
	move.b	($13,A6), D4	; Load current player's player number ID
	move.b	(A5,D1.w), D5
	cmp.b	D4, D5
	bne		xoutrodemos_playerassign_notleader ; branch if leader active and this player != leader
	
	move.b	#0, ($91,a6)	; This player is the leader!
	rts	
	
	
xoutrodemos_playerassign_leaderinactive:	; Leader is dead, but you and at least one other player are still alive.
	tst.b	(A5,D2.w)		; Check if follower1 is available.
	beq xoutrodemo_playerassign_leaderinactive_newleader	; If leader and follower1 are both inactive, current player is leader by default.
	addi	#$13, D2	; increment follower1 address to player number ID
	move.b	($13,A6), D4	; Load current player's player number ID
	move.b  (A5,D2.w), D5
	cmp.b	D4, D5
	bne xoutrodemo_playerassign_leaderinactive_isfollower
	
xoutrodemo_playerassign_leaderinactive_newleader:
	move.b #00, ($91,a6)
	rts
	
xoutrodemo_playerassign_leaderinactive_isfollower:
	move.b #$FF, ($91,a6)
	rts
	
xoutrodemos_playerassign_notleader:	; Leader is alive, but you ain't him.
	move.b #$FF, ($91,a6)
	rts
	
	
tbl_xoutrodemos_playerassign_lvl:
	dc.w	tbl_xoutrodemos_playerassign_lvl_slums-tbl_xoutrodemos_playerassign_lvl
	dc.w	tbl_xoutrodemos_playerassign_lvl_subway-tbl_xoutrodemos_playerassign_lvl
	dc.w	tbl_xoutrodemos_playerassign_lvl_wside-tbl_xoutrodemos_playerassign_lvl
	dc.w	tbl_xoutrodemos_playerassign_lvl_indust-tbl_xoutrodemos_playerassign_lvl
	dc.w	tbl_xoutrodemos_playerassign_lvl_bayarea-tbl_xoutrodemos_playerassign_lvl
	dc.w	tbl_xoutrodemos_playerassign_lvl_uptown-tbl_xoutrodemos_playerassign_lvl
	dc.w	tbl_xoutrodemos_playerassign_lvl_bonus1-tbl_xoutrodemos_playerassign_lvl
	dc.w	tbl_xoutrodemos_playerassign_lvl_bonus2-tbl_xoutrodemos_playerassign_lvl
	
tbl_xoutrodemos_playerassign_lvl_slums:
	dc.b	$00, $01, $02
tbl_xoutrodemos_playerassign_lvl_subway:
	dc.b	$02, $01, $02, $00
tbl_xoutrodemos_playerassign_lvl_wside:
	dc.b	$00, $01, $02
tbl_xoutrodemos_playerassign_lvl_indust:
	dc.b	$01, $00
tbl_xoutrodemos_playerassign_lvl_bayarea:
	dc.b	$02
tbl_xoutrodemos_playerassign_lvl_uptown:
	dc.b	$02, $01, $00
tbl_xoutrodemos_playerassign_lvl_bonus1:
	dc.b	$00
tbl_xoutrodemos_playerassign_lvl_bonus2:
	dc.b	$00
	
jtbl_xoutrodemos_playerassign_assigntbl:
	dc.w	jtbl_xoutrodemos_playerassign_assigntbl_1p-jtbl_xoutrodemos_playerassign_assigntbl
	dc.w	jtbl_xoutrodemos_playerassign_assigntbl_2p-jtbl_xoutrodemos_playerassign_assigntbl
	dc.w	jtbl_xoutrodemos_playerassign_assigntbl_3p-jtbl_xoutrodemos_playerassign_assigntbl
	
jtbl_xoutrodemos_playerassign_assigntbl_1p:
	move.w	#p1_main_mem, D1	; 1p ram as leader
	move.w	#p3_main_mem, D2	; 3p ram as follower1
	rts
jtbl_xoutrodemos_playerassign_assigntbl_2p:
	move.w	#p2_main_mem, D1	; 2p ram as leader
	move.w	#p1_main_mem, D2	; 1p ram as follower1
	rts
jtbl_xoutrodemos_playerassign_assigntbl_3p:
	move.w	#p3_main_mem, D1	; 3p ram as leader
	move.w	#p2_main_mem, D2	; 2p ram as follower1
	rts