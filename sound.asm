;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: sound.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
DO_SOUNDS       .proc

S1              .block                  ; CHOPPER SOUND
                lda CHOPPER_STATUS
                cmp #OFF
                beq _XIT
                lda FRAME
                and #2
                bne _XIT
                lda #$83
                sta AUDC1
                lda S1_1_VAL
                bpl _1
                lda S1_2_VAL
_1              sec
                sbc #4
                sta S1_1_VAL
                sta AUDF1
_XIT            .endblock


S2              .block                  ; MISSILE SOUND
                lda S2_VAL
                bmi _XIT
                eor #$3F
                clc
                adc #16
                sta AUDF2
                ldx #$86
                cmp #$3F+16
                bne _1
                ldx #0
_1              stx AUDC2
                dec S2_VAL
_XIT            .endblock


S3              .block                  ; EXPLOSION SOUND
                lda S3_VAL
                beq _XIT
                lda RANDOM
                and #3
                ora S3_VAL
                adc #$10
                sta AUDF3
                inc S3_VAL
                lda S3_VAL
                cmp #$31
                bne _1
                lda #0
                sta S3_VAL
_1              ldx #$48
                cmp #0
                bne _2
                tax                     ; X=0
_2              stx AUDC3
_XIT            .endblock


S4              .block                  ; RE-FUEL SOUND
                lda S4_VAL
                beq _XIT
                ldx #0
                lda FRAME
                and #7
                beq _1
                ldx #$18
_1              ldy #$00
                lda FUEL1
                cmp #<MAX_FUEL
                lda FUEL2
                sbc #>MAX_FUEL
                bcs _2
                ldy #$A6
                sed
                lda FUEL1
                clc
                adc #4
                sta FUEL1
                lda FUEL2
                adc #0
                sta FUEL2
                cld
_2              stx AUDF2
                sty AUDC2
_XIT            .endblock


S5              .block                  ; HYPER CHAMBER SOUND
                lda S5_VAL
                beq _XIT
                inc S5_VAL
                cmp #$50
                bne _1
                lda #0
                sta S5_VAL
_1              sta AUDF2
                lda #$A8
                sta AUDC2
_XIT            .endblock


S6              .block                  ; CRUISE MISSILE SOUND
                lda FRAME
                and #1
                bne _XIT
                lda S6_VAL
                beq _XIT
                inc S6_VAL
                cmp #$20
                blt _1
                ldx #0
                stx S6_VAL
_1              sta AUDF4
                lda #$07
                sta AUDC4
_XIT            rts
                .endblock
                .endproc


;=======================================
;
;=======================================
CLEAR_SOUNDS
                lda #0
                sta AUDC1
                sta AUDC2
                sta AUDC3
                sta AUDC4
                rts

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
