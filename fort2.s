;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT2.S
;---------------------------------------
; MOVE PODS
; MOVE CRUISE MISSILE
; CHECK HYPER CHAMBERS
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
MOVE_CRUISE_MISSILES
                dec MISSILE_SPD
                bne MCE
                lda MISSILE_SPEED
                sta MISSILE_SPD

MM1 ;unused
                ldx #MAX_TANKS-1
M_ST
                lda CM_STATUS,X
                cmp #OFF
                beq M_END
                cmp #BEGIN
                bne _1
                jmp M_BEGIN

_1              jsr M_COL
                bcs M_END
                jsr M_ERASE
                jsr M_MOVE
                jsr M_DRAW

M_END
                lda TANK_STATUS,X
                cmp #ON
                bne _2
                lda TANK_Y,X
                sec
                sbc CHOP_Y
                bmi _2
                cmp #14
                bge _2
                lda CM_STATUS,X
                cmp #OFF
                bne _2
                lda CHOP_X
                sec
                sbc #2
                sbc TANK_X,X
                bpl _1
                eor #-2
_1              cmp #9
                bge _2
                lda #BEGIN
                sta CM_STATUS,X

_2              dex
                bpl M_ST
MCE
                ldx #MAX_TANKS-1
_1              lda CM_STATUS,X
                cmp #OFF
                bne _2
                dex
                bpl _1
                lda #0
                sta AUDC4
                sta S6_VAL
_2              rts


;=======================================
;
;=======================================
GET_MISS_ADR
                lda CM_X,X
                sta TEMP1
                lda CM_Y,X
                sta TEMP2
                jmp COMPUTE_MAP_ADR


;=======================================
;
;=======================================
M_BEGIN
                ldy TANK_X,X
                iny
                tya
                sta CM_X,X
                lda TANK_Y,X
                sec
                sbc #2
                sta CM_Y,X
                ldy #LEFT
                lda CHOP_X
                sec
                sbc TANK_X,X
                bmi _1
                ldy #RIGHT
_1              tya
                sta CM_STATUS,X
                lda #0
                sta CM_TEMP,X
                lda #20
                sta CM_TIME,X
                lda #1
                sta S6_VAL
                jmp M_END


;=======================================
;
;=======================================
M_COL
                jsr GET_MISS_ADR
                ldy #0
                lda (ADR1),Y
                cmp #EXP
                beq M_COL2
                clc
                rts


;=======================================
;
;=======================================
M_COL2
                jsr M_ERASE
                lda #1
                sta S3_VAL
                lda #OFF
                sta CM_STATUS,X
                lda #-1
                sta CM_TIME,X
                stx TEMP1
                ldx #$10
                ldy #$00
                jsr INC_SCORE
                ldx TEMP1
                sec
                rts


;=======================================
;
;=======================================
M_ERASE
                jsr GET_MISS_ADR
                lda CM_TEMP,X
                cmp #EXP_WALL
                beq _2
                cmp #$60+128
                bge _1
                cmp #$40
                beq _1
                cmp #$5B
                blt _2
                cmp #$5F+1
                blt _1
_2              ldy #0
                sta (ADR1),Y
_1              rts


;=======================================
;
;=======================================
M_MOVE
                lda CM_STATUS,X
                cmp #LEFT
                beq _1
                inc CM_X,X
                jmp _2
_1              dec CM_X,X
_2              lda CM_TIME,X
                bpl _3
_4              inc CM_Y,X
                jmp _8
_3              lda CHOP_X
                sec
                sbc CM_X,X
                sta TEMP1
                lda CM_STATUS,X
                cmp #LEFT
                bne _5
                lda TEMP1
                bpl _4
                bmi _6                  ; FORCED
_5              lda TEMP1
                bmi _4
_6              lda CM_X,X
                cmp #$D8
                bge _4
                cmp #$2D
                blt _4
                ldy CHOP_Y
                iny
                tya
                sec
                sbc CM_Y,X
                beq _8
                bpl _7
                dec CM_Y,X
                jmp _8
_7              inc CM_Y,X
_8              jsr GET_MISS_ADR
                ldy #0
                lda (ADR1),Y
                cmp #MISS_LEFT
                beq _7
                cmp #MISS_RIGHT
                beq _7
_9              lda CM_TIME,X
                bmi _10
                dec CM_TIME,X
_10             rts


;=======================================
;
;=======================================
M_DRAW
                jsr GET_MISS_ADR
                ldy #0
                lda (ADR1),Y
                sta CM_TEMP,X
                lda #MISS_LEFT
                ldy CM_STATUS,X
                cpy #LEFT
                beq _1
                lda #MISS_RIGHT
_1              ldy #0
                sta (ADR1),Y
                lda CM_TEMP,X
                jsr CHECK_CHR
                bcc _2
                jmp M_COL2
_2              rts


;=======================================
;
;=======================================
CHECK_HYPER_CHAMBER
                lda MODE
                cmp #HYPERSPACE_MODE
                bne _1
                lda #STOP_MODE
                sta MODE
                lda #$F
                sta BAK2_COLOR
                ldx #2
                jsr WAIT_FRAME
                lda #$0
                sta BAK2_COLOR
                lda RANDOM
                and #3
                tax
                lda H_XF,X
                sta SX_F
                lda H_YF,X
                sta SY_F
                lda H_X,X
                sta SX
                lda H_Y,X
                sta SY
                lda H_CX,X
                sta CHOPPER_X
                lda H_CY,X
                sta CHOPPER_Y
                lda #8
                sta CHOPPER_ANGLE
                lda #0
                sta CHOPPER_COL
                lda #GO_MODE
                sta MODE
_1              rts

;---------------------------------------
;---------------------------------------

H_XF
                .byte $DD,$76,$10,$4B
H_YF
                .byte $7A,$7B,$B8,$B8
H_X
                .byte $22,$BC,$55,$87
H_Y
                .byte $0F,$0F,$18,$18
H_CX
                .byte $73,$78,$76,$75
H_CY
                .byte $8C,$89,$AF,$AF


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
