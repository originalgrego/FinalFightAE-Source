 org 0xB6400	; bgmap ID 0x99
	incbin	"bgmaps/bgmap_scroll2_graffiticredits.bin"

 org 0xC8F42	; insert new bgmap in Bay Area scroll
	dc.b	$99

 org 0xC5080		; new palette for Bay Area SCROLL2
	incbin	"palettes/pal_scroll2_bayarea_newgraffiti.bin"