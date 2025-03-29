.scope bitmap
; Bitmap Base are bits 16 - 11 and is at 2048 increments
DCSEL= $9F25
BITMAP_BASE_LAYER0 = $9F2F
BITMAP_BASE_LAYER1 = $9F36
PALLETTE_OFFSET = $9F31
RESOLUTION_320 = %00000000
RESOLUTION_640 = %00000001
HSCALE = $9F2A
VSCALE = $9F2B

;DSEL1
HSTART = $9F29
HSTOP = $9F2A
VSTART = $9F2B
VSTOP = $9F2C

bitmapStart = $00
setDefaultAddressLayer0:
    lda #bitmapStart
    sta BITMAP_BASE_LAYER0
    rts

setHalfScale:
    lda #64
    sta HSCALE
    sta VSCALE
    rts

setWholeScale:
    lda #128
    sta HSCALE
    sta VSCALE
    rts

setResolution320:
    lda #%00000010
    sta DCSEL
    lda #0

    sta HSTART
    sta VSTART

    lda #640 >> 2
    sta HSTOP

    lda #480 >> 1
    sta VSTOP

    lda #$00
    sta DCSEL
    rts

clearMemory:
    lda #<bitmapStart
    sta $9F20
    lda #>bitmapStart
    sta $9F21
    lda #^bitmapStart
    ora #$10
    sta $9F22
    ldx #0
@outerLoop:
    ldy #0
@loop:
    lda #0
    sta $9F23
    iny
    cpy #$ff
    bne @loop
    inx
    cpx #151
    bne @outerLoop
    rts
.endscope