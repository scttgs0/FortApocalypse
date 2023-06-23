
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

                lda SID_RANDOM
                and #3

                tax
                lda H_XF,x
                sta SX_F
                lda H_YF,x
                sta SY_F

                lda H_X,x
                sta SX
                lda H_Y,x
                sta SY

                lda H_CX,x
                sta CHOPPER_X
                lda H_CY,x
                sta CHOPPER_Y

                lda #8
                sta CHOPPER_ANGLE

                stz CHOPPER_COL

                lda #GO_MODE
                sta MODE
_XIT            rts
                .endproc

;--------------------------------------
;--------------------------------------

H_XF            .byte $DD,$76,$10,$4B
H_YF            .byte $7A,$7B,$B8,$B8
H_X             .byte $22,$BC,$55,$87
H_Y             .byte $0F,$0F,$18,$18
H_CX            .byte $73,$78,$76,$75
H_CY            .byte $8C,$89,$AF,$AF
