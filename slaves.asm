;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: slaves.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
MoveSlaves      .proc
                ldx SLAVE_NUM
                lda SLAVE_STATUS,X
                cmp #OFF
                beq _2

                cmp #PICKUP
                bne _1

                jsr S_COL2

                ldx #$00
                stx AUDC3
                ldy #$08
                jsr IncreaseScore

                inc SLAVES_SAVED
                jmp _2

_1              jsr SlaveCollision

                bcs _2

                jsr SlaveErase
                jsr SlaveMove
                jsr SlaveDraw

                dec SlaveMove              ; PROT
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


;=======================================
;
;=======================================
GetSlaveAddr    .proc
                lda SLAVE_X,X
                sta TEMP1
                lda SLAVE_Y,X
                sta TEMP2
                jmp ComputeMapAddr

                .endproc


;=======================================
;
;=======================================
SlaveCollision  .proc
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


;=======================================
;
;=======================================
S_COL2          .proc
                jsr SlaveErase

                lda #OFF
                sta SLAVE_STATUS,X
                dec SLAVES_LEFT
                .endproc

                ;[fall-through]

PrintSlavesLeft .proc
;---

                lda #9
                sta TEMP1
                lda #0
                sta TEMP2
                ldx #<txtMenRemain
                ldy #>txtMenRemain
                jsr PRINT

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


;=======================================
;
;=======================================
SlaveErase      .proc
                jsr GetSlaveAddr

                ldy #0
                lda #$48                ; '^H'
                sta (ADR1),Y
                dec ADR1+1
                lda #$1F                ; '?'
                sta (ADR1),Y
                rts
                .endproc


;=======================================
;
;=======================================
SlaveMove       .proc
_next1          lda SLAVE_DX,X
                bmi _1

                inc SLAVE_DX,X
                lda SLAVE_DX,X
                and #$01
                ora #$10
                sta SLAVE_DX,X
                inc SLAVE_X,X
                jmp _2

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


;=======================================
;
;=======================================
SlaveDraw       .proc
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


;=======================================
;
;=======================================
SlavePickUp     .proc
                ldx #8-0
_next1          dex
                bpl _1

                clc
                rts

_1              lda SLAVE_STATUS,X
                cmp #OFF
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

                lda #PICKUP
                sta SLAVE_STATUS,X
                lda #$A8
                sta AUDC3
                lda #32
                sta AUDF3

                sec
                rts
                .endproc

;---------------------------------------
;---------------------------------------

SLAVE_CHR_T_L   .byte $4A,$4A
SLAVE_CHR_T_R   .byte $49,$49

LAND_CHR
SLAVE_CHR_B_L   .byte $3E,$3D
SLAVE_CHR_B_R   .byte $3B,$3C
                .byte $44
LAND_LEN        = *-LAND_CHR-1

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
