
; ============================================
; Intro demos
 org 0x00E6D0
	jmp xintrodemo_playerassign_leader1p
	
 org 0x00E6DA
	jmp xintrodemo_playerassign_leader3p
; ============================================

; Fix for the leader/follower behavior in the Car Crush bonus stage.
; By default, the game forces any player in the Car Crush stage
; to be a follower if they are not 1P, regardless of how their leader
; flag is set. This was likely to force 2P to always approach from
; the right side of the screen for verisimilitude with the joystick
; positions on the cabinet. However, with three players this falls
; apart. This fix bypasses the player ID check that takes place after
; the leader check so that the new 3 player leader/follower system works.

 org 0x00E3D8
	NOP
	NOP
	NOP