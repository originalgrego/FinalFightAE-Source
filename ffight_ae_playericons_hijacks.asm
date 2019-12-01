hijack_playericons:
	lea (player_icon_table).l, A1
	move.b  ($15,A6), D0 ; Load player id
	jmp		$1F196
	

player_icon_table:
 incbin "tables\tbl_player_icons.bin"