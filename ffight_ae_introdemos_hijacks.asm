xintrodemo_playerassign_leader1p:
	bsr		xintrodemo_cleartemp
	move.w	#p1_main_mem, D1	; 1p ram as leader
	move.w	#p3_main_mem, D2	; 3p ram as follower1
	move.w	#p2_main_mem, D3	; 2p ram as follower2
	bra	xintrodemo_playerassign_tstldr

xintrodemo_playerassign_leader2p:
	bsr		xintrodemo_cleartemp
	move.w	#p2_main_mem, D1	; 2p ram as leader
	move.w	#p1_main_mem, D2	; 1p ram as follower1
	move.w	#p3_main_mem, D3	; 3p ram as follower2
	bra	xintrodemo_playerassign_tstldr
	
xintrodemo_playerassign_leader3p:
	bsr		xintrodemo_cleartemp
	move.w	#p3_main_mem, D1	; 3p ram as leader
	move.w	#p2_main_mem, D2	; 2p ram as follower1
	move.w	#p1_main_mem, D3	; 1p ram as follower2
	bra	xintrodemo_playerassign_tstldr
	
xintrodemo_cleartemp:
	moveq	#$0, D1
	moveq	#$0, D2
	moveq	#$0, D3
	moveq	#$0, D4
	moveq	#$0, D5
	rts
	
xintrodemo_playerassign_tstldr:
	lea		(A5,D1.w), A1
	tst.b	(A1)		; check if leader is active
	beq	xintrodemo_playerassign_tstldr_inactive
	
	addi	#$13, D1	; increment leader address to player number ID
	move.b	($13,A6), D4	; Load current player's player number ID
	move.b	(A5,D1.w), D5
	cmp.b	D4, D5
	bne xintrodemo_playerassign_tstldr_notleader	; branch if leader active and this player != leader
	
	moveq	#$0, D1; This player is the leader!
	bra xintrodemo_playerassign_setposition
	
xintrodemo_playerassign_tstldr_inactive:	; Leader is dead, but you and at least one other player are still alive.
	tst.b	(A5,D2.w)		; Check if follower1 is available.
	beq xintrodemo_playerassign_tstldr_inactive_newleader
	addi	#$13, D2	; increment follower1 address to player number ID
	move.b	($13,A6), D4	; Load current player's player number ID
	move.b  (A5,D2.w), D5
	cmp.b	D4, D5
	bne	xintrodemo_playerassign_tstldr_inactive_isf2
	
xintrodemo_playerassign_tstldr_inactive_newleader:
	moveq	#$0, D1	; Leader and follower 1 are dead, but you are second in line. You are the new Leader.
	bra xintrodemo_playerassign_setposition
	
xintrodemo_playerassign_tstldr_inactive_isf2:
	move.w #$01, D1	; Leader is dead, but you are third in line. You are the new Follower1.
	bra xintrodemo_playerassign_setposition

xintrodemo_playerassign_tstldr_notleader:	; Leader is alive, but you ain't him.
	tst.b	(A5,D2.w)		; Check if follower1 is available.
	beq xintrodemo_playerassign_tstldr_notleader_isf1 ; Follower1 is dead, but you are third in line. You are the new Follower1.
	addi	#$13, D2	; increment follower1 address to player number ID
	move.b	($13,A6), D4	; Load current player's player number ID
	move.b  (A5,D2.w), D5
	cmp.b	D4, D5
	bne	xintrodemo_playerassign_tstldr_notleader_isf2
	
xintrodemo_playerassign_tstldr_notleader_isf1:
	move.w	#$1, D1	
	bra xintrodemo_playerassign_setposition

xintrodemo_playerassign_tstldr_notleader_isf2:
	move.w	#$2, D1	
	bra xintrodemo_playerassign_setposition
	
	
xintrodemo_playerassign_setposition:
	moveq   #$0, D0
	move.b  ($be,A5), D0	; load level ID
	add.b   D0, D0
	lea     (tbl_introdemo_playxy,PC), A0
	move.w  (A0,D0.w), D0
	lea     (A0,D0.w), A0
	moveq   #$0, D0
	move.b  ($bf,A5), D0
	add.b	D0, D0
	move.w	(A0,D0.w), D0
	lea		(A0,D0.W), A0
	tst.b   D1
	beq     xintrodemo_playerassign_setposition_commit
	
	cmpi.b	#$01, D1
	bne	xintrodemo_playerassign_setposition_isf2
	lea 	($4,A0), A0
	bra xintrodemo_playerassign_setposition_commit
	
xintrodemo_playerassign_setposition_isf2:
	lea 	($8,A0), A0
xintrodemo_playerassign_setposition_commit:
	move.w  (A0)+, D0
	add.w   D0, ($6,A6)
	move.w  (A0)+, D0
	add.w   D0, ($a,A6)
	move.l  ($a,A6), ($e,A6)
	move.b  D1, ($91,A6)
	tst.b   D1
	rts
	
; ============================================
; PLAYER X/Y POSITION MODIFIERS FOR INTO DEMOS
tbl_introdemo_playxy:
	dc.w	introdemo_playxy_slums-tbl_introdemo_playxy
	dc.w	introdemo_playxy_subway-tbl_introdemo_playxy
	dc.w	introdemo_playxy_wside-tbl_introdemo_playxy
	dc.w	introdemo_playxy_indust-tbl_introdemo_playxy
	dc.w	introdemo_playxy_bayarea-tbl_introdemo_playxy
	dc.w	introdemo_playxy_uptown-tbl_introdemo_playxy
	dc.w	introdemo_playxy_bonus1-tbl_introdemo_playxy
	dc.w	introdemo_playxy_bonus2-tbl_introdemo_playxy
	
; ===============SLUMS=======================
	
introdemo_playxy_slums:
	dc.w introdemo_playxy_slums_0-introdemo_playxy_slums
	dc.w introdemo_playxy_slums_1-introdemo_playxy_slums
	dc.w introdemo_playxy_slums_2-introdemo_playxy_slums

; ORDER OF X/Y MOD DATA: LEADER, FOLLOWER1, FOLLOWER2
; FORMAT OF X/Y MOD DATA: XXXX YYYY SIGNED
introdemo_playxy_slums_0:
	dc.l $FFC0003C, $FFB00020, $FFA80028
introdemo_playxy_slums_1:
	dc.l $FFF00032, $FFE00036, $FFC80034
introdemo_playxy_slums_2:
	dc.l $0010FFF8, $0010FFFC, $0010FFF2
	
; ===============SUBWAY=======================
	
introdemo_playxy_subway:
	dc.w introdemo_playxy_subway_0-introdemo_playxy_subway
	dc.w introdemo_playxy_subway_1-introdemo_playxy_subway
	dc.w introdemo_playxy_subway_2-introdemo_playxy_subway
	dc.w introdemo_playxy_subway_3-introdemo_playxy_subway
	
introdemo_playxy_subway_0:
	dc.l $FFA8004C, $FFC8005E, $FF900052
introdemo_playxy_subway_1:
	dc.l $FFA80019, $FFC80038, $FF980028
introdemo_playxy_subway_2:	
	dc.l $FFC8002A, $FFA80040, $FF880015
introdemo_playxy_subway_3:
	dc.l $FFC8008C, $FFB8008C, $FFA8008C
	
; ===============WEST SIDE====================
	
introdemo_playxy_wside:
	dc.w introdemo_playxy_wside_0-introdemo_playxy_wside
	dc.w introdemo_playxy_wside_1-introdemo_playxy_wside
	dc.w introdemo_playxy_wside_2-introdemo_playxy_wside
	
introdemo_playxy_wside_0:
	dc.l $FFB80068, $FFD80078, $FFA00058
introdemo_playxy_wside_1:
	dc.l $00A20040, $00DE0040, $00B80030
introdemo_playxy_wside_2:
	dc.l $FFD80018, $FFB8002B, $FFC80022
	
; ===========INDUSTRIAL AREA==================

introdemo_playxy_indust:
	dc.w introdemo_playxy_indust_0-introdemo_playxy_indust
	dc.w introdemo_playxy_indust_1-introdemo_playxy_indust
	
introdemo_playxy_indust_0:
	dc.l $FF9C0065, $FFC80049, $FFB00040
introdemo_playxy_indust_1:
	dc.l $00A20026, $00DE0026, $00BA0026
	
; ==============BAY AREA======================
	
introdemo_playxy_bayarea:
	dc.w introdemo_playxy_bayarea_0-introdemo_playxy_bayarea

introdemo_playxy_bayarea_0:
	dc.l $FFC80020, $FFB80030, $FFBF0040
	
; ================UPTOWN======================
	
introdemo_playxy_uptown:
	dc.w introdemo_playxy_uptown_0-introdemo_playxy_uptown
	dc.w introdemo_playxy_uptown_1-introdemo_playxy_uptown
	dc.w introdemo_playxy_uptown_2-introdemo_playxy_uptown

introdemo_playxy_uptown_0:
	dc.l $FFC80034, $FFA90024, $FFB80044
introdemo_playxy_uptown_1:
	dc.l $00A0003A, $0080002A, $00B0001A
introdemo_playxy_uptown_2:
	dc.l $0090002C, $0080001C, $0070000C
	
; ===============BONUS 1======================
	
introdemo_playxy_bonus1:
	dc.w introdemo_playxy_bonus1_0-introdemo_playxy_bonus1
	
introdemo_playxy_bonus1_0:
	dc.l $FFBE0030, $01B80030, $01C80020
	
; ==============BONUS 2=======================
	
introdemo_playxy_bonus2:
	dc.w introdemo_playxy_bonus2_0-introdemo_playxy_bonus2
	
introdemo_playxy_bonus2_0:
	dc.l $FFB80050, $FFC80030, $FFC00018
	
; ============================================