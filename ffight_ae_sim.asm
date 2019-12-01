 ; Sim player 2
 org 0x005732
   jmp hijack_sim_player_2
   
 ; Cody knife proximity test
 org 0x00BCDE
   jmp hijack_cody_knife_prox
   
 ; Fix weapon pickup
 org 0x00431A
   jmp hijack_weapon_46_calc
   