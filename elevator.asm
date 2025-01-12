
; SPDX-FileName: elevator.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;======================================
;
;======================================
DoElevator      .proc
;v_???          .var ADR1_I
;---

                dec ELEVATOR_TIM
                bne _XIT

                lda ELEVATOR_SPD
                sta ELEVATOR_TIM

                ldx #$20-1
                lda #$00
_next1          sta BLOCK_5,X

                dex
                bpl _next1

                lda ELEVATOR_NUM
                clc
                adc ELEVATOR_DX
                and #$03
                sta ELEVATOR_NUM

                asl
                tax
                lda _ELEVATORS,X
                sta ADR1_I
                lda _ELEVATORS+1,X
                sta ADR1_I+1

                ldy #$07
                lda #$55
_next2          sta (ADR1_I),Y

                dey
                bpl _next2

_XIT            rts

;--------------------------------------

_ELEVATORS      .addr BLOCK_5,BLOCK_6
                .addr BLOCK_7,BLOCK_8

                .endproc
