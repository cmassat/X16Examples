
setOriginX:
	STA l_x1
    stx l_x1 + 1
    rts

setOriginY:
    STA l_y1
    stx l_y1 + 1
    rts

setDestX:
	STA l_x2
    stx l_x2 + 1
    rts
setDestY:
    STA l_y2
    stx l_y2 + 1
    rts

setColor4bbp:
	and #$0f
	sta mColor
	sta mOddColor

	lda mColor
	asl
	asl
	asl
	asl
	sta mEvenColor
	rts

calcXDir:
	lda l_x1 + 1
	cmp l_x2 + 1
	beq @checkLoX
	bcs @negX
	bcc @posX
@checkLoX:
    lda l_x1
	cmp l_x2
	beq _zeroX
	bcc @posX
	bcs @negX
	rts
@posX:
    lda #lDirPos
	sta mXdir
	
	lda l_x2
	SEC
	sbc l_x1
	sta l_dx

	lda l_x2 + 1
	sbc l_x1 + 1
	sta l_dx + 1
	rts
@negX:
    lda #lDirNeg
	sta mXdir

	lda l_x1
	SEC
	sbc l_x2
	sta l_dx

	lda l_x1 + 1
	sbc l_x2 + 1
	sta l_dx + 1
	rts
_zeroX:
    lda #lDirZer
	sta mXdir
    rts

calcYDir:
	lda l_y1 + 1
	cmp l_y2 + 1
	beq @checkLoY
	bcs @negY
	bcc @posY
@checkLoY:
    lda l_y1
	cmp l_y2
	bcc @posY
    beq @zeroY
	bcs @negY
	rts
@posY:
    lda #lDirPos
	sta mYdir

	lda l_y2
	SEC
	sbc l_y1
	sta l_dy

	lda l_y2 + 1
	sbc l_y1 + 1
	sta l_dy + 1
	rts
@negY:
    lda #lDirNeg
	sta mYdir

	lda l_y1
	SEC
	sbc l_y2
	sta l_dy

	lda l_y1 + 1
	sbc l_y2 + 1
	sta l_dy + 1

	rts
@zeroY:
    lda #lDirZer
	sta mYdir
	;stz l_dy
	;stz l_dy + 1
    rts

calcai:
	lda mSteep
	cmp #1
	beq @setSteep
    ;ai =2*dy
    lda l_dy
    sta l_ai
    lda l_dy + 1
    sta l_ai + 1

    clc
    lda l_ai
    asl
    sta l_ai
    
    lda l_ai + 1
    rol
    sta l_ai + 1
    rts
@setSteep:
	;ai =2*dx
    lda l_dx
    sta l_ai
    lda l_dx + 1
    sta l_ai + 1

    clc
    lda l_ai
    asl
    sta l_ai

    lda l_ai + 1
    rol
    sta l_ai + 1
	rts

calcbi:
	lda mSteep
	cmp #1
	beq @setSteep
    ;bi =2*(dy-dx)
    LDA l_dy
    SEC
    SBC l_dx
    sta l_bi

    LDA l_dy + 1
    SBC l_dx + 1
    sta l_bi + 1

    clc
    lda l_bi
    asl
    sta l_bi

    lda l_bi + 1
    rol
    sta l_bi + 1
    rts
@setSteep:
	;bi =2*(dx-dy)
    LDA l_dx
    SEC
    SBC l_dy
    sta l_bi

    LDA l_dx + 1
    SBC l_dy + 1
    sta l_bi + 1

    clc
    lda l_bi
    asl
    sta l_bi

    lda l_bi + 1
    rol
    sta l_bi + 1
	rts

calcDecision:
    ;decision = ai-dx
    lda l_ai 
	sec  
    sbc l_dx
	sta l_d

	lda l_ai + 1
	sbc l_dx + 1
	sta l_d + 1

	rts 

checkSteep:
	lda mXdir
	cmp #lDirZer
	beq _skip

	lda l_dy + 1
	cmp l_dx + 1
	beq _checkLo
	bcs _steep
_skip:
	rts
_checkLo:
	lda l_dy
	cmp l_dx
	bcs _steep
	rts
_steep:
	lda #1
	sta mSteep
	rts

lineUpdateDecision:
	lda mXdir
	cmp #lDirZer
	beq _updateYOnly

	lda mYdir
	cmp #lDirZer
	beq _updateXOnly
    lda l_d + 1
	cmp #0
	bmi _isNeg

	lda l_d 
	clc 
	adc l_bi 
	sta l_d 
	lda l_d + 1
	adc l_bi + 1
	sta l_d + 1

	lda mSteep
	cmp #1
	beq _steepSlope

	lda l_d + 1
	cmp #0
	bmi _updateX
	beq _updateY
	bpl _updateY
    rts 
_isNeg:
    lda l_d 
	clc
	adc l_ai 
	sta l_d
	lda l_d + 1
	adc l_ai + 1
	sta l_d + 1
	 
	lda mSteep
	cmp #1
	beq _steepSlope
	lda l_d + 1
	cmp #0
	bmi _updateX
	beq _updateY
	bpl _updateY
    rts
_updateY:
    jsr lineUpdateY
	jsr lineUpdateX
	rts
_updateX:
    jsr lineUpdateX
    rts
_updateYOnly:
    jsr lineUpdateY
    rts
_updateXOnly:
	jsr lineUpdateX
	rts
_steepSlope:
	lda l_d + 1
	cmp #0
	bmi _updateYOnly
	beq _updateY
	bpl _updateY
	rts

lineUpdateX:
    lda mXdir
	cmp #lDirNeg
	beq @neg
	lda l_x1
	clc
	adc #1
	sta l_x1

	lda l_x1 + 1
	adc #0
	sta l_x1 + 1
    rts
@neg:
    lda l_x1
	sec
	sbc #1
	sta l_x1

	lda l_x1 + 1
	sbc #0
	sta l_x1 + 1
    rts

lineUpdateY:
    lda mYdir
	cmp #lDirNeg
	beq @neg
	lda l_y1
	clc
	adc #1
	sta l_y1

	lda l_y1 + 1
	adc #0
	sta l_y1 + 1
    rts  
@neg:
    lda l_y1
	sec
	sbc #1
	sta l_y1

	lda l_y1 + 1
	sbc #0
	sta l_y1 + 1
    rts

do_line:
	stz mSteep
    jsr calcXDir
	jsr calcYDir
	jsr checkSteep
	jsr calcai
	jsr calcbi
	jsr calcDecision

_loop:
    jsr putPixel

;updateDecision
	jsr lineUpdateDecision

	lda mXdir
	cmp #lDirZer
	beq _checkEOLY
_checkEOL:
	lda l_x1+1
	cmp l_x2 + 1
	beq _checklo
	bra _loop
_checklo:
	lda l_x1
	cmp l_x2
	bne _loop
	bra _putLastPixel
	rts
_checkEOLY:
	 lda l_y1 + 1
	 cmp l_y2 + 1
	 beq @checkLoY
	 bra _loop
@checkLoY:
	 lda l_y1
	 cmp l_y2
	 bne _loop
_putLastPixel:
   lda l_x2
   sta l_x1
   lda l_x2 + 1
   sta l_x1 + 1

   lda l_y2
   sta l_y1
   lda l_y2 + 1
   sta l_y1 + 1

   jsr putPixel
    rts

putPixel:
	phy
	phx
	pha
	jsr findPixelCoordinate

	lda l_x1
	and #1
	beq _even
	stz $9F22
	lda mPixel + 1
	sta $9F21
	lda mPixel
	sta $9F20
	lda $9F23
	and #$F0
	ora mOddColor
	sta $9F23

	pla
	plx
	ply
	rts
_even:
	stz $9F22
	lda mPixel + 1
	sta $9F21
	lda mPixel
	sta $9F20
	lda $9F23
	and #$0F
	ora mEvenColor
	sta $9F23
	pla
	plx
	ply
	rts

findPixelCoordinate:
	lda l_y1
	sta workSheet
	stz workSheet + 1

	asl workSheet
	rol workSheet + 1

	asl workSheet
	rol workSheet + 1

	asl workSheet
	rol workSheet + 1

	asl workSheet
	rol workSheet + 1

	asl workSheet
	rol workSheet + 1

	asl workSheet
	rol workSheet + 1

	asl workSheet
	rol workSheet + 1

	lda workSheet
	sta workAddA
	lda workSheet + 1
	sta workAddA + 1


	lda l_y1
	sta workSheet
	stz workSheet + 1
	asl workSheet
	rol workSheet + 1

	asl workSheet
	rol workSheet + 1

	asl workSheet
	rol workSheet + 1

	asl workSheet
	rol workSheet + 1

	asl workSheet
	rol workSheet + 1

	lda workSheet
	sta workAddB
	lda workSheet + 1
	sta workAddB + 1


	lda workAddA
	clc
	adc workAddB
	sta mPixel

	lda workAddA + 1
	adc workAddB + 1
	sta mPixel + 1

	;addX
	lda l_x1
	sta workSheet
	lda l_x1 + 1
	sta workSheet + 1
	clc
	lsr workSheet + 1
	ror workSheet

	lda mPixel
	clc
	adc workSheet
	sta mPixel

	lda mPixel+1
	adc workSheet + 1
	sta mPixel + 1

	rts

.segment "DATA"
l_dx: .word $0
l_dy: .word $0
l_xi: .word $0
l_yi: .word $0
l_ai: .word $0
l_bi: .word $0
l_d:  .word $0

l_x1: .word $0
l_y1: .word $0
l_x2: .word $0
l_y2: .word $0
mSteep:
	.byte $0
mPixel:
	.byte $00, $00
workSheet:
	.byte $00, $00, $00
workAddA:
	.byte $00, $00, $00
workAddB:
	.byte $00, $00, $00
lDirZer = 0
lDirNeg = 1
lDirPos = 2

mXdir:
    .byte $00
mYdir:
    .byte $00
mDWeight:
    .byte $00

mColor:
	.byte $00
mOddColor:
	.byte $00
mEvenColor:
	.byte $00