;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT4.S
;---------------------------------------
; MAIN INTERUPT DRIVER
;       PART (II)
; POSITION THINGS
; DO_BLOCKS
; DO_EXP
; DO_NUMBERS
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
DO_BLOCKS
                lda FRAME
                and #$7F
                bne _9
                ldx #32-1
                lda #0
_1              sta BLOCK_1,X
                dex
                bpl _1
                lda RANDOM
                bmi _3
                ldx #7
                lda #$55
_2              sta BLOCK_1,X
                dex
                bpl _2
_3              lda RANDOM
                bmi _5
                ldx #7
                lda #$55
_4              sta BLOCK_2,X
                dex
                bpl _4
_5              lda RANDOM
                bmi _7
                ldx #7
                lda #$55
_6              sta BLOCK_3,X
                dex
                bpl _6
_7              lda RANDOM
                bmi _9
                ldx #7
                lda #$55
_8              sta BLOCK_4,X
                dex
                bpl _8
_9              rts


;=======================================
;
;=======================================
DO_EXP
                ldx #7
_1              lda EXP_SHAPE,X
                and RANDOM
                sta EXPLOSION,X
                sta EXPLOSION2,X
                dex
                bpl _1
                ldx #3
_2              lda RANDOM
                and #$0F
                ora #$A0
                sta MISS_CHR_LEFT,X
                inx
                cpx #5
                bne _2
                ldx #3
_3              lda RANDOM
                and #$E0
                ora #$0A
                sta MISS_CHR_RIGHT,X
                inx
                cpx #5
                bne _3
                rts


;=======================================
;
;=======================================
DO_NUMBERS
                lda MODE
                cmp #NEW_PLAYER_MODE
                beq _1
                cmp #GAME_OVER_MODE
                bne DO_N
_1              rts
; SCORE
DO_N            lda #<SCORE_DIG
                sta S_ADR
                lda #>SCORE_DIG
                sta S_ADR+1
                lda #0
                sta S_FLG
                ldx #5
                lda SCORE3
                jsr DDIG
                lda SCORE2
                jsr DDIG
                lda SCORE1
                jsr DDIG

; DEC BONUS
                lda MODE
                cmp #GO_MODE
                bne _1
                lda BONUS1
                ora BONUS2
                beq _1
                lda FRAME
                and #7
                bne _1
                sed
                lda BONUS1
                sec
                sbc #1
                sta BONUS1
                lda BONUS2
                sbc #0
                sta BONUS2
                cld

; BONUS
_1              lda #<BONUS_DIG
                sta S_ADR
                lda #>BONUS_DIG
                sta S_ADR+1
                lda #0
                sta S_FLG
                ldx #3
                lda BONUS2
                jsr DDIG
                lda BONUS1
                jsr DDIG

; DEC FUEL
                lda MODE
                cmp #GO_MODE
                bne _4
                lda FUEL_STATUS
                cmp #FULL
                bne _4
                lda FUEL1
                ora FUEL2
                beq _3
                lda FRAME
                and #15
                bne _4
                sed
                lda FUEL1
                sec
                sbc #1
                sta FUEL1
                lda FUEL2
                sbc #0
                sta FUEL2
                cld
                jmp _4
_3              lda #EMPTY
                sta FUEL_STATUS

; FUEL
_4              lda #<FUEL_DIG
                sta S_ADR
                lda #>FUEL_DIG
                sta S_ADR+1
                lda #0
                sta S_FLG
                ldx #3
                lda FUEL2
                jsr DDIG
                lda FUEL1

;
; DRAW DIGIT
;
DDIG            tay
                lda S_FLG
                bne _1
                tya
                and #$F0
                bne _1
                tya
                ora #$A0
                tay
                bne _2
_1              lda #1
                sta S_FLG
_2              lda S_FLG
                bne _3
                tya
                and #$F
                bne _3
                tya
                ora #$A
                tay
                bne _4
_3              lda #1
                sta S_FLG
_4              tya
                sta S_TEMP
                lsr
                lsr
                lsr
                lsr
                jsr DRAW
                lda S_TEMP
                and #$F

DRAW            cmp #$A
                bne _1
                cpx #0
                bne _0
                lda #0
                beq _1                  ; FORCED
_0              lda #<$F0+128           ; BLANK
_1              clc
                adc #$10+128            ; '0'
                ldy #0
                sta (S_ADR),Y
                cmp #$10+128
                bne _2
                lda #$A+128
_2              iny
                and #$8F
                sta (S_ADR),Y
                lda S_ADR
                clc
                adc #2
                sta S_ADR
                lda S_ADR+1
                adc #0
                sta S_ADR+1
                dex
                rts

;=======================================
; 
;=======================================
INC_SCORE       .proc
                lda DEMO_STATUS
                beq _XIT

                sed
                txa
                clc
                adc SCORE1
                sta SCORE1

                tya
                adc SCORE2
                sta SCORE2

                lda SCORE3
                adc #0
                sta SCORE3
                cld
_XIT            rts
                .endproc

;---------------------------------------
;---------------------------------------

DEMO_STICK
                .byte $0B,$0B,$0B,$0B,$09,$09,$09,$09
                .byte $09,$09,$0A,$0A,$0A,$0A,$0B,$09
                .byte $09,$0B,$0A,$0A,$0B,$09,$0B,$0A
                .byte $0B,$09,$0B,$0A,$0A,$0A,$0A,$0B
                .byte $0B,$09,$09,$0B,$0B,$0A,$09,$0D
                .byte $09,$0B,$0A,$0A,$0A,$0A,$0A,$0A
                .byte $0B,$09,$09,$09,$0A,$0E,$06,$07
                .byte $07,$07,$05,$05,$05,$05,$07,$06
                .byte $06,$07,$05,$06,$06,$07,$05,$05
                .byte $07,$06,$05,$07,$07,$07,$06,$06
                .byte $06,$06,$06,$07,$07,$06,$05,$05
                .byte $07,$06,$06,$07,$05,$05,$06,$06
                .byte $06,$06,$07,$05,$05,$07,$06,$06
                .byte $07,$06,$09,$09

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
