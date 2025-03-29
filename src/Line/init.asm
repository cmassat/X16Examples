initVideo:
    jsr vera::resetMode

    jsr vera::vgaModeEnable
    jsr vera::layer0ModeEnable
    jsr vera::setMode

    jsr vera::resetLayer0
    jsr vera::color16LayerEnable
    jsr vera::bitmapLayerEnable
    jsr vera::setLayer0

    jsr vera::color16LayerEnable
    rts

initGfx:
    jsr bitmap::setDefaultAddressLayer0
    jsr bitmap::setHalfScale
    jsr bitmap::setResolution320
    jsr bitmap::clearMemory
    rts 