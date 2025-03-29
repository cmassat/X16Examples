.segment "INIT"
.segment "zeropage"
ROM_BANK          = $01
RAM_BANK          = $00
.segment "ONCE"
.segment "CODE"
.segment "DATA"
.org $080D
.segment "STARTUP"
start:
	jsr initVideo
	jsr initGfx

	lda #<100
	ldx #>100
	jsr setOriginX

	lda #<100
	ldx #>100
	jsr setOriginY

	lda #<320
	ldx #>320
	jsr setDestX

	lda #<200
	ldx #>200
	jsr setDestY

	lda #02
	jsr setColor4bbp

	jsr do_line
game_loop:
	nop
	bra game_loop
	rts
.include "line.asm"
.include "bitmap.asm"
.include "vera.asm"
.include "init.asm"

