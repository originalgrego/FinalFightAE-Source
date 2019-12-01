
;================================================
hijack_sim_player_2:
   lea     (p2_main_mem,A5), A6
   jsr     $005742 

   lea     (p3_main_mem,A5), A6
   jsr     $005742 

   jmp $00573A
;================================================

;================================================
hijack_cody_knife_prox:
	moveq	#0, D5
	move.b	($13,A6), D5
	lsl.b	#2, D5
	move.l	tbl_codyknifeprox_otherplayers(pc,d5), D6
	movea.l	A5, A0
	adda.w	D6, A0
	move.w	#0, D1
	jsr		$BD6E
	bne		hijack_codyknifeprox_return

	swap	D6
	movea.l	A5, A0
	adda.w	D6, A0
	move.w	#0, D1
	jmp		$BD6E
	
hijack_codyknifeprox_return:
	rts
	
tbl_codyknifeprox_otherplayers:
	dc.w	p3_main_mem, p2_main_mem
	dc.w	p3_main_mem, p1_main_mem
	dc.w	p2_main_mem, p1_main_mem
;================================================


;================================================
hijack_weapon_46_calc
   tst.b ($12, A0)
   bne weapon46_not_player

   moveq #$0, D0
   bra weapon46_exit
   
weapon46_not_player:
   move.b  ($13,A0), D0
   add.b   D0, D0
   
weapon46_exit:
   jmp $004320
;================================================
