;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT5.S
;---------------------------------------
; SET SCANNER
; CHECK FORT
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
DO_CHECKSUM2    ldy #0
                sty TEMP1
                sty ADR1
                lda #$90
                sta ADR1+1
                clc

_next1          adc (ADR1),Y
                bcc _1
                inc TEMP1
_1              iny
                bne _next1
                inc ADR1+1
                ldx ADR1+1
                cpx #$B0
                bne _next1
                ;cmp #0
                cmp #$C7
                bne _2
                lda TEMP1
                ;cmp #0
                cmp #$f8
                beq _XIT

_2              .byte $12

_XIT            rts


;=======================================
;
;=======================================
POS_IT
                stx TEMP3
                ldx TEMP1
                lda TEMP2
                jsr MULT_BY_40
                txa
                lsr
                lsr
                lsr
                clc
                adc #<SCANNER+3
                adc TEMP1
                sta ADR2
                lda #>SCANNER
                adc TEMP2
                sta ADR2+1
                txa
                and #7
                tax
                ldy #0
                lda (ADR2),Y
                eor POS_MASK1,X
                sta (ADR2),Y
                ldx TEMP3
                rts


;=======================================
;
;=======================================
MULT_BY_40
                sta TEMP1
                asl
                asl
                adc TEMP1

                ldy #0
                sty TEMP2
                asl
                rol TEMP2
                asl
                rol TEMP2
                asl
                rol TEMP2
                sta TEMP1
                rts


;=======================================
;
;=======================================
CHECK_FORT
                lda FORT_STATUS
                cmp #EXPLODE
                beq _1
                rts

_1
DO_CHECKSUM1 ;unused
                ldy #0
                sty TEMP1
                sty ADR1
                lda #$90
                sta ADR1+1
                clc

_1              adc (ADR1),Y
                bcc _2
                inc TEMP1
_2              iny
                bne _1
                inc ADR1+1
                ldx ADR1+1
                cpx #$B0
                bne _1
                ;cmp #0
                cmp #$C7
                bne _4
                lda TEMP1
                ;cmp #0
                cmp #$F8
                beq _3

_4              .byte $12
_3

NEXT_PART1 ;unused
                ldx #$00
                ldy #$50
                jsr INC_SCORE
                jsr GIVE_BONUS
                lda #STOP_MODE
                sta MODE
                lda #$99
                sta BONUS1
                sta BONUS2
                lda #$76
                sta LAND_CHOP_X
                lda #$A0
                sta LAND_CHOP_Y
                lda #$6E
                sta LAND_X
                lda #$11
                sta LAND_Y
                lda #$07
                sta LAND_FX
                lda #$96
                sta LAND_FY
                lda #8
                sta LAND_CHOP_ANGLE
                ldx #16-1
                lda #0
_90             sta WINDOW_1,X
                dex
                bpl _90
                lda #0
                sta TEMP3
                sta TEMP4
                sta TEMP6
_2              lda #121
                sta TEMP1
                lda #20
                sta TEMP2
                jsr ComputeMapAddr
                lda TEMP3
                asl
                tax
                lda FORT_EXP,X
                sta ADR2
                lda FORT_EXP+1,X
                sta ADR2+1
_3              ldy TEMP4
                lda (ADR2),Y
                sta TEMP5
                ldy #7+8+8
_4              ldx #2
                lda #0
                ror TEMP5
                bcc _5
                lda #EXP
_5              sta (ADR1),Y
                dey
                dex
                bpl _5
                tya
                bpl _4
                inc ADR1+1
                inc TEMP6
                lda TEMP6
                cmp #3
                bne _3
                lda #0
                sta TEMP6
                inc TEMP4
                lda TEMP4
                cmp #6
                bne _3
                lda #0
                sta TEMP4
                lda #$10
                sta BAK2_COLOR
                lda #$CF
                sta AUDC4
                ldy #15
_6              ldx #2
                jsr WAIT_FRAME
                inc BAK2_COLOR
                lda #1
                sta S3_VAL
                lda RANDOM
                sta AUDF4
                dey
                bpl _6
                lda #0
                sta BAK2_COLOR
                inc TEMP3
                lda TEMP3
                cmp #4
                bne _2
                lda #GO_MODE
                sta MODE
                lda #OFF
                sta FORT_STATUS
                sta LASER_STATUS

                jmp CLEAR_SOUNDS

;---------------------------------------
;---------------------------------------

FORT_EXP        .addr FORT_EX1,FORT_EX2
                .addr FORT_EX3,FORT_EX4


;=======================================
;
;=======================================
DO_CHECKSUM3
                ldx #0
                txa
                clc
_1              adc $B980,X
                inx
                bne _1
                ;cmp #$0
                cmp #$90
                beq _2

                .byte $12

_2              rts

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
