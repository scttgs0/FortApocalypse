
; SPDX-FileName: slaves.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;======================================
;
;======================================
MoveSlaves      .proc
                ldx SLAVE_NUM
                lda SLAVE_STATUS,X
                cmp #kOFF
                beq _2

                cmp #kPICKUP
                bne _1

                jsr S_COL2

                ldx #$00
                ;--.setbank $AF
                stz SID1_CTRL3
                ;--.setbank $03
                ldy #$08
                jsr IncreaseScore

                inc SLAVES_SAVED
                jmp _2

_1              jsr SlaveCollision

                bcs _2

                jsr SlaveErase
                jsr SlaveMove
                jsr SlaveDraw

                ;-----------------------
                ; Copy Protection
                ;-----------------------
                ; dec SlaveMove
                ;-----------------------

_2              ldx SLAVE_NUM
                inx
                cpx #8
                blt _3

                ldx #0
_3              stx SLAVE_NUM
                lda PLAY_SCRN+5
                beq _XIT

                dec TIM9_VAL
                bne _XIT

                jsr ClearInfo

_XIT            rts
                .endproc


;======================================
;
;======================================
GetSlaveAddr    .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda SLAVE_X,X
                sta TEMP1
                lda SLAVE_Y,X
                sta TEMP2
                jmp ComputeMapAddr

                .endproc


;======================================
;
;======================================
SlaveCollision  .proc
;v_???          .var ADR1
;---

                jsr GetSlaveAddr

                ldy #0
                lda (ADR1),Y
                beq S_COL2

                cmp #EXP
                beq S_COL2

                cmp #MISS_LEFT
                beq S_COL2

                cmp #MISS_RIGHT
                beq S_COL2

                dec ADR1+1
                lda (ADR1),Y
                beq S_COL2

                cmp #EXP
                beq S_COL2

                cmp #MISS_LEFT
                beq S_COL2

                cmp #MISS_RIGHT
                beq S_COL2

                clc
                rts
                .endproc


;======================================
;
;======================================
S_COL2          .proc
;v_???          .var TEMP2
;---

                jsr SlaveErase

                lda #kOFF
                sta SLAVE_STATUS,X
                dec SLAVES_LEFT
                .endproc

                ;[fall-through]


;======================================
;
;======================================

PrintSlavesLeft .proc
;v_???          .var TEMP1
;---

                lda #9
                sta TEMP1
                lda #0
                sta TEMP2
                ldx #<txtMenRemain
                ldy #>txtMenRemain
                jsr Print

                lda SLAVES_LEFT
                ora #$10+128
                sta PLAY_SCRN+5
                cmp #$10+128
                bne _1

                lda #$A+128
_1              and #$8F
                sta PLAY_SCRN+6
                lda #90
                sta TIM9_VAL
                sec
                rts
                .endproc


;======================================
;
;======================================
SlaveErase      .proc
;v_???          .var ADR1
;---

                jsr GetSlaveAddr

                ldy #0
                lda #$48                ; '^H'
                sta (ADR1),Y
                dec ADR1+1
                lda #$1F                ; '?'
                sta (ADR1),Y
                rts
                .endproc


;======================================
;
;======================================
SlaveMove       .proc
;v_???          .var ADR1
;---

_next1          lda SLAVE_DX,X
                bmi _1

                inc SLAVE_DX,X
                lda SLAVE_DX,X
                and #$01
                ora #$10
                sta SLAVE_DX,X
                inc SLAVE_X,X
                bra _2

_1              dec SLAVE_DX,X
                lda SLAVE_DX,X
                and #$01
                ora #$F0
                sta SLAVE_DX,X
                dec SLAVE_X,X

_2              jsr GetSlaveAddr

                ldy #0
                lda (ADR1),Y
                cmp #$48
                beq _XIT

                lda SLAVE_DX,X
                eor #$E0
                sta SLAVE_DX,X
                jmp _next1

_XIT            rts
                .endproc


;======================================
;
;======================================
SlaveDraw       .proc
;v_???          .var ADR1
;---

                jsr GetSlaveAddr

                ldy #0
                lda SLAVE_DX,X
                pha
                and #$03
                tax
                pla
                bpl _1

                lda SLAVE_CHR_B_L,X
                sta (ADR1),Y
                dec ADR1+1
                lda SLAVE_CHR_T_L,X
                sta (ADR1),Y
                rts

_1              lda SLAVE_CHR_B_R,X
                sta (ADR1),Y
                dec ADR1+1
                lda SLAVE_CHR_T_R,X
                sta (ADR1),Y
                rts
                .endproc


;======================================
;
;======================================
SlavePickUp     .proc
                ldx #8-0
_next1          dex
                bpl _1

                clc
                rts

_1              lda SLAVE_STATUS,X
                cmp #kOFF
                beq _next1

                lda SLAVE_X,X
                sec
                sbc CHOP_X
                bpl _2

                eor #-2
_2              cmp #4
                bge _next1

                lda SLAVE_Y,X
                sec
                sbc CHOP_Y
                bpl _3

                eor #-2
_3              cmp #4
                bge _next1

                lda #kPICKUP
                sta SLAVE_STATUS,X
                lda #$A8
                sta SID1_CTRL3
                lda #32
                sta SID1_FREQ3

                sec
                rts
                .endproc


;--------------------------------------
;--------------------------------------

SLAVE_CHR_T_L   .byte $4A,$4A
SLAVE_CHR_T_R   .byte $49,$49

LAND_CHR
SLAVE_CHR_B_L   .byte $3E,$3D
SLAVE_CHR_B_R   .byte $3B,$3C
                .byte $44
LAND_LEN        = *-LAND_CHR-1
