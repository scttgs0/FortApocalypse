;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT2.S
;---------------------------------------
; MOVE PODS
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
MOVE_PODS
                lda #POD_SPEED
_1              pha
                jsr MP1
                pla
                sec
                sbc #1
                bne _1
_2              rts


;=======================================
;
;=======================================
MP1
                ldx POD_NUM

                lda POD_STATUS,X
                sta POD_COM
                and #$0F
                cmp #OFF
                beq P_END
                cmp #BEGIN
                bne _1
                jmp P_BEGIN

_1              jsr P_COL
                bcs P_END
                jsr P_ERASE
                jsr P_MOVE
                jsr P_DRAW

P_END
                ldx POD_NUM
                inx
                cpx #MAX_PODS
                blt _1
                ldx #0
_1              stx POD_NUM
                rts


;=======================================
;
;=======================================
GET_POD_ADR
                lda POD_X,X
                sta TEMP1
                lda POD_Y,X
                sta TEMP2
                jmp COMPUTE_MAP_ADR


;=======================================
;
;=======================================
GET_POD_VAL
                jsr GET_POD_ADR
                ldy #0
                lda (ADR1),Y
                sta TEMP1
                iny
                lda (ADR1),Y
                sta TEMP2
                rts


;=======================================
;
;=======================================
PUT_POD_VAL
                jsr GET_POD_ADR
                ldy #0
                lda TEMP3
                sta (ADR1),Y
                iny
                lda TEMP4
                sta (ADR1),Y
                rts


;=======================================
;
;=======================================
POS_POD
                lda POD_X,X
                sta TEMP1
                lda POD_Y,X
                sta TEMP2
                jmp POS_IT


;=======================================
;
;=======================================
P_BEGIN
_1              lda RANDOM
                cmp #50
                blt _1
                cmp #256-50
                bge _1
                sta POD_X,X
_2              lda RANDOM
                cmp #40
                bge _2
                sta POD_Y,X
                jsr GET_POD_ADR
                ldy #0
                lda (ADR1),Y
                iny
                ora (ADR1),Y
                bne _1
                lda #ON
                sta POD_STATUS,X
                sta POD_COM
                jsr P_DRAW
                lda #$01
                sta POD_DX,X
                jmp P_END


;=======================================
;
;=======================================
P_COL
                jsr GET_POD_VAL
                lda TEMP1
                cmp #MISS_LEFT
                beq _1
                cmp #MISS_RIGHT
                beq _1
                cmp #EXP
                beq _1
                lda TEMP2
                cmp #MISS_LEFT
                beq _1
                cmp #MISS_RIGHT
                beq _1
                cmp #EXP
                beq _1
                clc
                rts
_1              jsr P_ERASE
                lda #OFF
                sta POD_STATUS,X
                ldx #$50
                ldy #$00
                jsr INC_SCORE
                sec
                rts


;=======================================
;
;=======================================
P_ERASE
                jsr POS_POD
                lda POD_TEMP1,X
                sta TEMP3
                lda POD_TEMP2,X
                sta TEMP4
                jmp PUT_POD_VAL


;=======================================
;
;=======================================
P_DRAW
                jsr POS_POD
                jsr GET_POD_VAL
                lda TEMP1
                sta POD_TEMP1,X
                lda TEMP2
                sta POD_TEMP2,X
                lda POD_COM
                lsr
                lsr
                lsr
                tay
                lda POD_CHR,Y
                sta TEMP3
                lda POD_CHR+1,Y
                sta TEMP4
                jmp PUT_POD_VAL


;=======================================
;
;=======================================
P_MOVE
_0              lda POD_DX,X
                bpl _1
                lda POD_COM
                sec
                sbc #$10
                and #$3F
                sta POD_COM
                and #$F0
                cmp #$30
                bne _2
                dec POD_X,X
                jmp _2
_1              lda POD_COM
                clc
                adc #$10
                and #$3F
                sta POD_COM
                and #$F0
                bne _2
                inc POD_X,X
_2              lda POD_X,X
                sta TEMP1
                lda POD_Y,X
                sta TEMP2
                jsr COMPUTE_MAP_ADR
                ldy #0
                lda (ADR1),Y
                iny
                ora (ADR1),Y
                bne _3
                lda POD_X,X
                cmp #50
                blt _3
                cmp #256-50
                blt _4
_3              lda POD_DX,X
                eor #-2
                sta POD_DX,X
                jmp _0
_4

                lda POD_COM
                sta POD_STATUS,X
                rts

;---------------------------------------
;---------------------------------------

POD_CHR
                .byte $40,$00
                .byte $5B,$5C
                .byte $5D,$5E
                .byte $00,$5F


;=======================================
;
;=======================================
CHECK_CHR
                ldy #0
                sty ADR2+1
                and #$7F
                asl
                rol ADR2+1
                asl
                rol ADR2+1
                asl
                rol ADR2+1
                clc
                adc #<CHR_SET2
                sta ADR2
                lda #>CHR_SET2
                adc ADR2+1
                sta ADR2+1
                ldy #7
_1              lda (ADR2),Y
                bne _2
                dey
                bpl _1
                clc
                rts
_2              sec
                rts


;=======================================
;
;=======================================
SCREEN_ON
                jsr SCREEN_OFF
                lda #<DSP_LST1
                sta SDLST
                lda #>DSP_LST1
                sta SDLST+1
                rts


;=======================================
;
;=======================================
SCREEN_OFF
                lda #<DSP_LST2
                sta SDLST
                lda #>DSP_LST2
                sta SDLST+1
                lda #OFF
                sta CHOPPER_STATUS
                sta ROBOT_STATUS
                ldx R_STATUS
                cpx #CRASH
                bne _0
                sta R_STATUS
_0              ldx #$E0
                lda #0
_1              sta CHR_SET1+$200,X
                inx
                bne _1
_2              sta CHR_SET1+$300,X
                sta PLAY_SCRN+$000,X
                sta PLAY_SCRN+$100,X
                sta PLAY_SCRN+$200,X
                inx
                bne _2
                sta S1_1_VAL
                sta S2_VAL
                sta S3_VAL
                sta S4_VAL
                sta S5_VAL
                sta S6_VAL
                sta BAK2_COLOR
                lda #20
                sta S1_2_VAL
                ldx #MAX_TANKS-1
                stx TIM7_VAL
_3              lda CM_STATUS,X
                cmp #OFF
                beq _4
                lda #OFF
                sta CM_STATUS,X
                jsr M_ERASE
_4              dex
                bpl _3

                ldx #2
_5              lda ROCKET_STATUS,X
                cmp #7                  ; EXP
                bne _6
                lda ROCKET_TEMPX,X
                sta TEMP1
                lda ROCKET_TEMPY,X
                sta TEMP2
                jsr COMPUTE_MAP_ADR
                ldy #0
                lda ROCKET_TEMP,X
                sta (ADR1),Y
_6              lda #0
                sta ROCKET_STATUS,X
                sta ROCKET_X,X
                dex
                bpl _5

                brl CLEAR_SOUNDS


;=======================================
;
;=======================================
CCL
                lda TEMP2
                pha
                lda TEMP1
                pha
                lda TEMP2
                jsr MULT_BY_40
                pla
                pha
                clc
                adc TEMP1
                adc #<PLAY_SCRN
                sta ADR1
                lda #>PLAY_SCRN
                adc TEMP2
                sta ADR1+1
                pla
                sta TEMP1
                pla
                sta TEMP2
                rts


;=======================================
;
;=======================================
PRINT
                stx ADR2
                sty ADR2+1
                jsr CCL
                ldy #0
                sty TEMP5
                sty TEMP6
_1              ldy TEMP5
                lda (ADR2),Y
                beq _3
                cmp #$FF
                beq _2
                ldy TEMP6
                sta (ADR1),Y
                inc TEMP6
                clc
                adc #32
_3              ldy TEMP6
                sta (ADR1),Y
                inc TEMP6
                inc TEMP5
                bne _1                  ; FORCED
_2              rts


;=======================================
;
;=======================================
GIVE_BONUS
                ldx BONUS1
                ldy BONUS2
                jsr INC_SCORE
                lda #0
                sta BONUS1
                sta BONUS2
                sed
                lda CHOP_LEFT
                clc
                adc #2
                sta CHOP_LEFT
                cld
                ldx #2

                ;[fall-through]


;=======================================
;
;=======================================
WAIT_FRAME
                lda MODE
                sta TEMP_MODE
                lda FRAME
_1              cmp FRAME
                beq _1
                jsr ReadKeyboard
                lda MODE
                cmp TEMP_MODE
                bne _2
                dex
                bne WAIT_FRAME
                rts

_2              ldx #$FF
                txs
                jmp MAIN


;=======================================
;
;=======================================
CLEAR_INFO
                ldy #40-1
                lda #0
_1              sta PLAY_SCRN,Y
                dey
                bpl _1
                rts

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
