
; SPDX-FileName: laser.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;======================================
;
;======================================
DoLaser1        .proc
                lda FRAME
                and #7
                bne _XIT

                lda LASER_STATUS
                cmp #kOFF
                beq _1

                lda TIM1_VAL
                clc
                adc LASER_SPD
                sta TIM1_VAL
                bne _1

                ldx #0
_next1          lda LASER_DIAG,X
                sta LASER_1,X
                inx
                cpx #32
                bne _next1

                ldx #0
_next2          lda LASER_VERT,X
                sta LASER_3,X
                inx
                cpx #8
                bne _next2

                rts

_1              ldx #32-1
                lda #0
_next3          sta LASER_1,X
                dex
                bpl _next3

                ldx #8-1
_next4          sta LASER_3,X
                dex
                bpl _next4

_XIT            rts
                .endproc


;======================================
;
;======================================
DoLaser2        .proc
                lda FRAME
                and #7
                bne _XIT

                lda LASER_STATUS
                cmp #kOFF
                beq _1

                lda TIM2_VAL
                clc
                adc LASER_SPD
                sta TIM2_VAL
                bne _1

                ldx #0
_next1          lda LASER_DIAG,X
                sta LASER_2,X
                inx
                cpx #32
                bne _next1

                ldx #0
_next2          lda LASER_HORZ,X
                sta LASER_3,X
                inx
                cpx #8
                bne _next2

                rts

_1              ldx #32-1
                lda #0
_next3          sta LASER_2,X
                dex
                bpl _next3

_XIT            rts
                .endproc
