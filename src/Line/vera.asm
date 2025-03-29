.scope vera
LAYER0_CONFIG = $9F2D
LAYER1_CONFIG = $9F34
BITMAP = %00000100
COLOR_DEPTH_1BPP  = %00000000;  0
COLOR_DEPTH_2BPP  = %00000001; 1
COLOR_DEPTH_4BPP  = %00000010; 2
COLOR_DEPTH_8BPP  = %00000011; 3
DC_VIDEO = $9F29
OUTPUT_MODE_DISABLED = 1
OUTPUT_MODE_VGA = %00000001
OUTPUT_MODE_SVIDEO = %00000010
OUTPUT_MODE_RGB = %00000011

resetMode:
    stz DC_VIDEO
    stz videoMode
    rts

setMode:
    lda videoMode
    sta DC_VIDEO
    rts

vgaModeEnable:
    lda videoMode
    ora #%00000001
    sta videoMode
    rts

layer0ModeEnable:
    lda videoMode
    ora #%00010000
    sta videoMode
    rts

layer1ModeEnable:
    lda videoMode
    ora #%00100000
    sta videoMode
    rts

spriteModeEnable:
    lda videoMode
    ora #%01000000
    sta videoMode
    rts

resetLayer0:
    stz LAYER0_CONFIG
    stz videoLayer
    rts

resetLayer1:
    stz LAYER1_CONFIG
    stz videoLayer
    rts

setLayer0:
    lda videoLayer
    sta LAYER0_CONFIG
    rts

setLayer1:
    lda  videoLayer
    sta  LAYER0_CONFIG
    rts

bitmapLayerEnable:
    lda videoLayer
    ora #BITMAP
    sta videoLayer
    rts

color16LayerEnable:
    lda videoLayer
    ora #COLOR_DEPTH_4BPP
    sta videoLayer
    rts


.segment "DATA"
videoMode:
    .byte $00
videoLayer:
    .byte $00

.endscope