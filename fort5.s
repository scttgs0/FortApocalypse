;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT5.S
;---------------------------------------
; MOVE SLAVES
; FUEL BASE
; SET SCANNER
; CHECK FORT
;
; LINE INTERUPTS
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
MOVE_SLAVES     ldx SLAVE_NUM

                lda SLAVE_STATUS,X

                cmp #OFF
                beq _2

                cmp #PICKUP
                bne _1
                jsr S_COL2
                ldx #$00
                stx AUDC3
                ldy #$08
                jsr INC_SCORE
                inc SLAVES_SAVED
                jmp _2

_1              jsr S_COL
                bcs _2
                jsr S_ERASE
                jsr S_MOVE
                jsr S_DRAW
                dec S_MOVE              ; PROT

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
                jsr CLEAR_INFO
_XIT            rts


;=======================================
;
;=======================================
GET_SLAVE_ADR   lda SLAVE_X,X
                sta TEMP1
                lda SLAVE_Y,X
                sta TEMP2
                jmp COMPUTE_MAP_ADR

S_COL           jsr GET_SLAVE_ADR
                ldy #0
                lda (ADR1),Y
                beq _1
                cmp #EXP
                beq _1
                cmp #MISS_LEFT
                beq _1
                cmp #MISS_RIGHT
                beq _1
                dec ADR1+1
                lda (ADR1),Y
                beq _1
                cmp #EXP
                beq _1
                cmp #MISS_LEFT
                beq _1
                cmp #MISS_RIGHT
                beq _1
                clc
                rts
_1
S_COL2          jsr S_ERASE
                lda #OFF
                sta SLAVE_STATUS,X
                dec SLAVES_LEFT
PRINT_SLAVES_LEFT
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


;=======================================
;
;=======================================
S_ERASE         jsr GET_SLAVE_ADR
                ldy #0
                lda #$48                ; '^H'
                sta (ADR1),Y
                dec ADR1+1
                lda #$1F                ; '?'
                sta (ADR1),Y
                rts


;=======================================
;
;=======================================
S_MOVE
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
_2              jsr GET_SLAVE_ADR
                ldy #0
                lda (ADR1),Y
                cmp #$48
                beq _XIT
                lda SLAVE_DX,X
                eor #$E0
                sta SLAVE_DX,X
                jmp _next1
_XIT            rts


;=======================================
;
;=======================================
S_DRAW          jsr GET_SLAVE_ADR
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


;=======================================
;
;=======================================
PICK_UP_SLAVE   ldx #8-0
_0              dex
                bpl _1
                clc
                rts

_1              lda SLAVE_STATUS,X
                cmp #OFF
                beq _0
                lda SLAVE_X,X
                sec
                sbc CHOP_X
                bpl _2
                eor #-2
_2              cmp #4
                bge _0
                lda SLAVE_Y,X
                sec
                sbc CHOP_Y
                bpl _3
                eor #-2
_3              cmp #4
                bge _0
                lda #PICKUP
                sta SLAVE_STATUS,X
                lda #$A8
                sta AUDC3
                lda #32
                sta AUDF3

                sec
                rts

;---------------------------------------
;---------------------------------------

SLAVE_CHR_T_L
                .byte $4A,$4A
SLAVE_CHR_T_R
                .byte $49,$49
LAND_CHR
SLAVE_CHR_B_L
                .byte $3E,$3D
SLAVE_CHR_B_R
                .byte $3B,$3C
                .byte $44
LAND_LEN        = *-LAND_CHR-1


;=======================================
;
;=======================================
CHECK_FUEL_BASE
                lda FUEL_STATUS
                cmp #REFUEL
                bne _3
                jmp RE_FUEL
_3              lda CHOPPER_STATUS
                cmp #LAND
                bne _9
                lda CHOP_Y
                cmp #7+2
                blt _9
                cmp #11+2
                bge _9
                ldx CHOP_X
                lda LEVEL
                bne _1
                cpx #$15+2
                blt _9
                cpx #$EC+2+6
                bge _9
                jmp _2
_1              cpx #$82
                blt _9
                cpx #$82+6
                bge _9
_2              lda #REFUEL
                sta FUEL_STATUS
                asl COMPUTE_MAP_ADR     ; PROT
                lda #1
                sta TIM4_VAL
                lda #4
                sta FUEL_TEMP
_9
                lda #0
                ldx FUEL_STATUS
                cpx #REFUEL
                beq _11
                lda FUEL2
                bne _20

                lda FRAME
                and #%00001000
                bne _10
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
                jmp _20
_10             lda #$A4
_11             sta AUDC2
                lda #$88
                sta AUDF2
                jsr CLEAR_INFO
_20             rts


;=======================================
;
;=======================================
RE_FUEL
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


;=======================================
;
;=======================================
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


;=======================================
;
;=======================================
DRAW_BASE
                jsr COMPUTE_MAP_ADR
                lda #4
                sta TEMP4
                lda TEMP3
                asl
                clc
                adc TEMP3
                asl
                tax
_1              ldy #0
_2              lda BASE_SHAPE,X
                sta (ADR1),Y
                inx
                iny
                cpy #6
                bne _2
                inc ADR1+1
                dec TEMP4
                bpl _1
                rts

;---------------------------------------
;---------------------------------------
BASE_SHAPE
                .byte $00,$00,$00,$00,$00,$00    ; 0
                .byte $00,$00,$00,$00,$00,$00    ; 1
                .byte $00,$00,$00,$00,$00,$00    ; 2
                .byte $00,$00,$00,$00,$00,$00    ; 3
                .byte $44,$44,$44,$44,$44,$44    ; 4
                .byte $55,$58,$58,$58,$58,$56    ; 5
                .byte $55,$26,$35,$25,$2C,$56    ; 6
                .byte $55,$58,$58,$58,$58,$56    ; 7
                .byte $54,$00,$00,$00,$00,$54    ; 8


;=======================================
;
;=======================================
SET_SCANNER
                lda #0
                sta TEMP1
                sta TEMP2
                inc DRAW_MAP            ; PROT
                lda SY
                beq _2
                bmi _2
                cmp #17
                blt _1
                lda #16
_1              jsr MULT_BY_40
_2              lda SX
                lsr
                lsr
                lsr
                clc
                adc #<SCANNER
                adc TEMP1
                sta ADR1
                lda #>SCANNER
                adc TEMP2
                sta ADR1+1
                lda ADR1
                sta SCAN_ADR1
                lda ADR1+1
                sta SCAN_ADR1+1
                lda #<S_LINE1
                sta SCAN_ADR2
                sta ADR2
                lda #>S_LINE1
                sta SCAN_ADR2+1
                sta ADR2+1
                jsr DO_LINE
                lda #<S_LINE2
                sta SCAN_ADR2
                sta ADR2
                lda #>S_LINE2
                sta SCAN_ADR2+1
                sta ADR2+1
                jsr DO_LINE
                lda #<S_LINE3
                sta SCAN_ADR2
                sta ADR2
                lda #>S_LINE3
                sta SCAN_ADR2+1
                sta ADR2+1
                jmp DO_LINE
_3              rts


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
DO_LINE
                lda #7
                sta TEMP1
_0              ldx #12
                ldy #0
_1              lda (ADR1),Y
                sta (ADR2),Y
                inc ADR1
                bne _2
                inc ADR1+1
_2              lda ADR2
                clc
                adc #8
                sta ADR2
                lda ADR2+1
                adc #0
                sta ADR2+1
                dex
                bne _1
                lda SCAN_ADR1
                clc
                adc #40
                sta SCAN_ADR1
                sta ADR1
                lda SCAN_ADR1+1
                adc #0
                sta SCAN_ADR1+1
                sta ADR1+1
                inc SCAN_ADR2
                bne _3
                inc SCAN_ADR2+1
_3              lda SCAN_ADR2
                sta ADR2
                lda SCAN_ADR2+1
                sta ADR2+1
                dec TEMP1
                bpl _0
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
                jsr COMPUTE_MAP_ADR
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

FORT_EXP
                .addr FORT_EX1,FORT_EX2
                .addr FORT_EX3,FORT_EX4


;=======================================
;
;=======================================
LINE1           pha
                txa
                pha
                lda #<LINE2
                sta VDSLST
                lda #>LINE2
                sta VDSLST+1

                ldx #0
_1              txa
                sta WSYNC
                asl
                ora #$E0
                sta COLBK
                inx
                cpx #8
                bne _1

                beq LINEC               ; FORCED


;=======================================
;
;=======================================
LINE2
                pha
                txa
                pha
                lda #<LINE3
                sta VDSLST
                lda #>LINE3
                sta VDSLST+1
                ldx #2
_0              lda ROCKET_X,X
                sta HPOSM0,X
                dex
                bpl _0

                ldx #7
_1              txa
                sta WSYNC
                asl
                ora #$E0
                sta COLBK
                dex
                bpl _1

LINEC           lda #0
                sta COLBK
                pla
                tax
                pla
                rti


;=======================================
;
;=======================================
LINE3
                pha
                php
                cld
                lda #<LINE4
                sta VDSLST
                lda #>LINE4
                sta VDSLST+1
                lda ROBOT_X
                sta HPOSP2
                clc
                adc #8
                sta HPOSP3
                lda #>CHR_SET2
                sta WSYNC
                sta CHBASE
                lda BAK_COLOR
                sta COLPF0
                lda #$0A
                sta COLPF1
                lda #$93
                sta COLPF2
                lda FRAME
                sta COLPF3
                sta WSYNC
                lda BAK2_COLOR
                sta COLBK
                plp
                pla
                rti


;=======================================
;
;=======================================
LINE4
                pha
                txa
                pha
                tya
                pha
                php

                cld
                lda #<LINE1
                sta VDSLST
                lda #>LINE1
                sta VDSLST+1
                ldx #7
                lda #0
_0              sta HPOSP0,X
                dex
                bpl _0
                sta WSYNC
                sta COLBK
                lda MODE
                cmp #STOP_MODE
                beq _1
                cmp #GO_MODE
                bne _2
_1              jsr DO_SOUNDS

_2              plp
                pla
                tay
                pla
                tax
                pla
                rti


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
