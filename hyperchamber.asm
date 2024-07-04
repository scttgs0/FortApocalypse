
; SPDX-FileName: hyperchamber.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;======================================
;
;======================================
CheckHyperchamber .proc
                lda MODE
                cmp #HYPERSPACE_MODE
                bne _XIT

                lda #STOP_MODE
                sta MODE

                lda #$F
                sta BAK2_COLOR

                ldx #2
                jsr WaitFrame

                stz BAK2_COLOR

                .frsRandomByte
                and #3

                tax
                lda _H_XF,X
                sta SX_F
                lda _H_YF,X
                sta SY_F

                lda _H_X,X
                sta SX
                lda _H_Y,X
                sta SY

                lda _H_CX,X
                sta CHOPPER_X
                lda _H_CY,X
                sta CHOPPER_Y

                lda #8
                sta CHOPPER_ANGLE

                stz CHOPPER_COL

                lda #GO_MODE
                sta MODE

_XIT            rts

;--------------------------------------

_H_XF           .byte $DD,$76,$10,$4B
_H_YF           .byte $7A,$7B,$B8,$B8
_H_X            .byte $22,$BC,$55,$87
_H_Y            .byte $0F,$0F,$18,$18
_H_CX           .byte $73,$78,$76,$75
_H_CY           .byte $8C,$89,$AF,$AF

                .endproc
