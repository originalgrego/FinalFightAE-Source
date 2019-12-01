 org 0x72600
	dc.w $0000	;region switch

 org 0xEA5
	dc.b $1B	; region warning text pointer

 org 0x170A4	; Enable USA intro music queue
	NOP

 org 0x17974	; Force English script (also affects character bios)
	NOP

 org 0x17152	; Disable Japan intro music cue
	bra $17170
	
 org 0x172CE	; Fix "Sometime in the 1990's..." screen
	NOP

 org 0x175CE	; Enable Jessica Cry 1
	NOP
	
 org 0x17544	; Enable Jessica Cry 2 & 3
	NOP
	
 org 0x186B4	; Fix ending font (override region check) (Haggar and Jessica)
	NOP

 org 0x1861C	; Fix ending font (override region check) (Haggar and Jessica)
	NOP
	
 org 0x186CA	; Fix ending font (override region check) (Haggar and Jessica)
	NOP

 org 0x1870E	; Fix ending font (override region check) (Haggar and Jessica)
	NOP

 org 0x18ACC	; Fix ending font (override region check) (Cody and Jessica)
	NOP
	
 org 0x19D46	; Secret ending ending POM (override region check)
	NOP
	
 org 0x19D84	; Secret ending AKIMAN (override region check)
	NOP
	
 org 0x19F96	; Secret ending  (override region check)
	NOP
	
 org 0x19E90	; Secret ending  (override region check)
	NOP
	
 org 0x19E52	; Secret ending  (override region check)
	NOP
	