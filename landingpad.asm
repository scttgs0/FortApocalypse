
; SPDX-FileName: landingpad.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;======================================
;
;======================================
RestorePoint    .proc
                lda SX_F
                sta LAND_FX
                lda SY_F
                sta LAND_FY

                lda SX
                sta LAND_X
                lda SY
                sta LAND_Y

                lda CHOPPER_X
                sta LAND_CHOP_X
                lda CHOPPER_Y
                sta LAND_CHOP_Y

                lda CHOPPER_ANGLE
                sta LAND_CHOP_ANGLE
                rts
                .endproc


;======================================
;
;======================================
CheckLanding    .proc
;v_???          .var ADR1_I
;v_???          .var TEMP3_I
;v_???          .var TEMP4_I
;---

                ldy #0
                ldx #LAND_LEN
                lda (ADR1_I),y
_next1          cmp LAND_CHR,x
                beq _XIT

                cmp #$48
                beq _1

                dex
                bpl _next1

                inc TEMP3_I
_XIT            rts

_1              inc TEMP4_I
                rts
                .endproc
