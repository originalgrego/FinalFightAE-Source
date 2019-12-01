 ; Commonalizing p1/p2/p3 init
 org 0x009FA4
	jmp handle_two_player_init

	; 0x009faa used by string hijack for p2 top level entity
	
	; Free space till 009FC3
	
 ; Clear player ram, this happens when a player is initialized, dunno why it happens again
 org 0x009F48
   jmp hijack_clear_player_2_ram_char_select

 org 0x009F66
   jmp hijack_player_2_init_char_select

 org 0x0097DA
   jmp hijack_player_2_hitbox_init
   
   
 org 0x00A018
   jmp hijack_init_players_level_start
 
 ; More select a char stuff, checks $7f + A5
 org 0x00A0B6
   jmp hijack_player_2_init_2_demo
   
 ; Player 1 init ID var to also set palette byte
 org 0x009F8C
	jmp hijack_player_1_init_idvar
	
 ; Prevent player's palette var from clearing
 org 0x00A2FC
	NOP
	NOP
