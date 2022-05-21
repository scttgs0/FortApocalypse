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
                lda SLAVE_STATUS,x
                cmp #kOFF
                beq _2

                cmp #kPICKUP
                bne _1

                jsr S_COL2

                ldx #$00
                .setbank $AF
                stz SID_CTRL3
                .setbank $03
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


;=======================================
;
;=======================================
GetSlaveAddr    .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda SLAVE_X,x
                sta TEMP1
                lda SLAVE_Y,x
                sta TEMP2
                jmp ComputeMapAddr

                .endproc


;=======================================
;
;=======================================
SlaveCollision  .proc
;v_???          .var ADR1
;---

                jsr GetSlaveAddr

                ldy #0
                lda (ADR1),y
                beq S_COL2

                cmp #EXP
                beq S_COL2

                cmp #MISS_LEFT
                beq S_COL2

                cmp #MISS_RIGHT
                beq S_COL2

                dec ADR1+1
                lda (ADR1),y
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
;v_???          .var TEMP2
;---

                jsr SlaveErase

                lda #kOFF
                sta SLAVE_STATUS,x
                dec SLAVES_LEFT
                .endproc

                ;[fall-through]


;=======================================
;
;=======================================

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


;=======================================
;
;=======================================
SlaveErase      .proc
;v_???          .var ADR1
;---

                jsr GetSlaveAddr

                ldy #0
                lda #$48                ; '^H'
                sta (ADR1),y
                dec ADR1+1
                lda #$1F                ; '?'
                sta (ADR1),y
                rts
                .endproc


;=======================================
;
;=======================================
SlaveMove       .proc
;v_???          .var ADR1
;---

_next1          lda SLAVE_DX,x
                bmi _1

                inc SLAVE_DX,x
                lda SLAVE_DX,x
                and #$01
                ora #$10
                sta SLAVE_DX,x
                inc SLAVE_X,x
                bra _2

_1              dec SLAVE_DX,x
                lda SLAVE_DX,x
                and #$01
                ora #$F0
                sta SLAVE_DX,x
                dec SLAVE_X,x

_2              jsr GetSlaveAddr

                ldy #0
                lda (ADR1),y
                cmp #$48
                beq _XIT

                lda SLAVE_DX,x
                eor #$E0
                sta SLAVE_DX,x
                jmp _next1

_XIT            rts
                .endproc


;=======================================
;
;=======================================
SlaveDraw       .proc
;v_???          .var ADR1
;---

                jsr GetSlaveAddr

                ldy #0
                lda SLAVE_DX,x
                pha
                and #$03
                tax
                pla
                bpl _1

                lda SLAVE_CHR_B_L,x
                sta (ADR1),y
                dec ADR1+1
                lda SLAVE_CHR_T_L,x
                sta (ADR1),y
                rts

_1              lda SLAVE_CHR_B_R,x
                sta (ADR1),y
                dec ADR1+1
                lda SLAVE_CHR_T_R,x
                sta (ADR1),y
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

_1              lda SLAVE_STATUS,x
                cmp #kOFF
                beq _next1

                lda SLAVE_X,x
                sec
                sbc CHOP_X
                bpl _2

                eor #-2
_2              cmp #4
                bge _next1

                lda SLAVE_Y,x
                sec
                sbc CHOP_Y
                bpl _3

                eor #-2
_3              cmp #4
                bge _next1

                lda #kPICKUP
                sta SLAVE_STATUS,x
                lda #$A8
                sta SID_CTRL3
                lda #32
                sta SID_FREQ3

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
