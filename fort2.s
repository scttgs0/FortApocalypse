;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT2.S
;---------------------------------------
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



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
                jsr ComputeMapAddr
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
