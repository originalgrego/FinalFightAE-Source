 org 0x05DAF0
   jmp hijack_dynamite_scene_check_player_active
   
 org 0x05DD78
   jmp hijack_dynamite_scene_clear_player_status_bit

 org 0x05DDB8
   jmp hijack_dynamite_scene_initialize_player_draw_handler
   
 org 0x05DB30
   jmp hijack_dynamite_scene_call_draw_handlers
   
 org 0x05DDE4
	jmp	hijack_dynamite_scene_get_attributes
   
 org 0x05DDEC
   jmp hijack_dynamite_scene_set_x_position
   
 org 0x05DC96  
   jmp hijack_dynamite_scene_knife_check
   
 org 0x05E128  
   andi.w  #$ffff, D0 ; Allow for negative x values in $6 and $20

 org 0x05E200
	jmp hijack_dynamite_scene_drawportrait ; fix for Cody's extra portrait palette
	
 org 0x05E164
	jmp hijack_dynamite_scene_drawportrait_getlocation	; changed to set aside the vram dest for drawing the portrait, so that attributes can be modified if this is Cody
   
;	###########
;	## NOTES ##
;	###########
;
;	0x90B014	- First visible tile of leftmost dynamite scene portrait, SCROLL2
;
;	0x05E34A	- dynamitescene_drawhead
;