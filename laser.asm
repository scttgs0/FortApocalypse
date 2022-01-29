;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: laser.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
DoLaser1        .proc
                lda FRAME
                and #7
                bne _XIT

                lda LASER_STATUS
                cmp #OFF
                beq _1

                lda TIM1_VAL
                clc
                adc LASER_SPD
                sta TIM1_VAL
                bne _1

                ldx #0
_next1          lda LASER_SHAPES,X
                sta LASERS_1,X
                inx
                cpx #32
                bne _next1

                ldx #0
_next2          lda LASER_SHAPES+24,X
                sta LASER_3,X
                inx
                cpx #8
                bne _next2

                rts

_1              ldx #32-1
                lda #0
_next3          sta LASERS_1,X
                dex
                bpl _next3

                ldx #8-1
_next4          sta LASER_3,X
                dex
                bpl _next4

_XIT            rts
                .endproc

;=======================================
;
;=======================================
DoLaser2        .proc
                lda FRAME
                and #7
                bne _XIT

                lda LASER_STATUS
                cmp #OFF
                beq _1

                lda TIM2_VAL
                clc
                adc LASER_SPD
                sta TIM2_VAL
                bne _1

                ldx #0
_next1          lda LASER_SHAPES,X
                sta LASERS_2,X
                inx
                cpx #32
                bne _next1

                ldx #0
_next2          lda LASER_SHAPES+16,X
                sta LASER_3,X
                inx
                cpx #8
                bne _next2

                rts

_1              ldx #32-1
                lda #0
_next3          sta LASERS_2,X
                dex
                bpl _next3

_XIT            rts
                .endproc

;---------------------------------------
;---------------------------------------

LASER_SHAPES    .byte %11000000
                .byte %11000000
                .byte %00110000
                .byte %00110000
                .byte %00001100
                .byte %00001100
                .byte %00000011
                .byte %00000011

                .byte %00000011
                .byte %00000011
                .byte %00001100
                .byte %00001100
                .byte %00110000
                .byte %00110000
                .byte %11000000
                .byte %11000000

                .byte %00000000
                .byte %00000000
                .byte %00000000
                .byte %11111111
                .byte %11111111
                .byte %00000000
                .byte %00000000
                .byte %00000000

                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000
                .byte %00110000

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
