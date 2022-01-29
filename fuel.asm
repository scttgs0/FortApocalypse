;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: fuel.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
CHECK_FUEL_BASE .proc
                lda FUEL_STATUS
                cmp #REFUEL
                bne _1

                jmp RE_FUEL

_1              lda CHOPPER_STATUS
                cmp #LAND
                bne _4

                lda CHOP_Y
                cmp #7+2
                blt _4

                cmp #11+2
                bge _4

                ldx CHOP_X
                lda LEVEL
                bne _2

                cpx #$15+2
                blt _4

                cpx #$EC+2+6
                bge _4

                jmp _3

_2              cpx #$82
                blt _4

                cpx #$82+6
                bge _4

_3              lda #REFUEL
                sta FUEL_STATUS
                asl COMPUTE_MAP_ADR     ; PROT
                lda #1
                sta TIM4_VAL
                lda #4
                sta FUEL_TEMP
_4              lda #0
                ldx FUEL_STATUS
                cpx #REFUEL
                beq _6

                lda FUEL2
                bne _XIT

                lda FRAME
                and #%00001000
                bne _5

                lda #9
                sta TEMP1
                lda #0
                sta TEMP2
                lda #$A4
                sta AUDC2
                sta AUDF2
                ldx #<txtLowOnFuel
                ldy #>txtLowOnFuel
                jsr PRINT

                jmp _XIT

_5              lda #$A4
_6              sta AUDC2
                lda #$88
                sta AUDF2
                jsr CLEAR_INFO

_XIT            rts
                .endproc


;=======================================
;
;=======================================
RE_FUEL         .proc
                dec TIM4_VAL
                bne FE

                lda #1
                sta TIM4_VAL
                lda FUEL_TEMP
                bmi F1

DF1             lda #9+2
                sta TEMP2
                lda FUEL_TEMP
                sta TEMP3
                ldx LEVEL
                dex                     ; X=1?
                beq _1

                lda #$15+2
                sta TEMP1
                jsr DRAW_BASE

                lda #$EC+2
                bne _2                  ; FORCED

_1              lda #$82
_2              sta TEMP1
                jsr DRAW_BASE

                dec FUEL_TEMP
FE              rts

F1              ldx #1
                lda CHOP_Y
                cmp #11+2
                bge _1

                ldx #0
                stx AUDC2
_1              stx S4_VAL
                lda CHOP_Y
                cmp #8+2
                bge FE

                lda #FULL
                sta FUEL_STATUS
                lda #4
                sta FUEL_TEMP
                jsr DF1

                jmp SAVE_POS

                .endproc


;=======================================
;
;=======================================
DRAW_BASE       .proc
;---
                jsr COMPUTE_MAP_ADR

                lda #4
                sta TEMP4
                lda TEMP3
                asl
                clc
                adc TEMP3
                asl
                tax
_next1          ldy #0
_next2          lda BASE_SHAPE,X
                sta (ADR1),Y
                inx
                iny
                cpy #6
                bne _next2

                inc ADR1+1
                dec TEMP4
                bpl _next1

                rts
                .endproc

;---------------------------------------
;---------------------------------------
BASE_SHAPE
                .byte $00,$00,$00,$00,$00,$00    ; .... .... .... .... .... ....
                .byte $00,$00,$00,$00,$00,$00    ; .... .... .... .... .... ....
                .byte $00,$00,$00,$00,$00,$00    ; .... .... .... .... .... ....
                .byte $00,$00,$00,$00,$00,$00    ; .... .... .... .... .... ....
                .byte $44,$44,$44,$44,$44,$44    ; G.G. G.G. G.G. G.G. G.G. G.G.
                .byte $55,$58,$58,$58,$58,$56    ; GGGG GGR. GGR. GGR. GGR. GGGR
                .byte $55,$26,$35,$25,$2C,$56    ; GGGG .RGR .#GG .RGG .R#. GGGR
                .byte $55,$58,$58,$58,$58,$56    ; GGGG GGR. GGR. GGR. GGR. GGGR
                .byte $54,$00,$00,$00,$00,$54    ; GGG. .... .... .... .... GGG.

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
