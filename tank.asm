;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: tank.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MAX_TANKS       = 6

TANK_SHAPE      .byte $EC,$ED,$EE,$EF,$F0       ; 'lmnop' atari-ascii
                .byte MISS_LEFT,MISS_RIGHT


;=======================================
;
;=======================================
PositionTank    .proc
                lda TANK_X,X
                sta TEMP1

                ldy TANK_Y,X
                dey
                sty TEMP2

                jsr PositionIt

                lda TANK_Y,X
                sta TEMP2
                rts
                .endproc


;=======================================
;
;=======================================
MoveTanks       .proc
MT1
                dec TANK_SPD
                beq _1
                jmp MT2

_1              lda TANK_SPEED
                sta TANK_SPD

                ldx #MAX_TANKS-1

_2              lda TANK_Y,X
                sta TEMP2
                lda TANK_STATUS,X
                cmp #OFF
                bne _3

                jmp _11

_3              cmp #BEGIN
                bne _5

                lda #ON
                sta TANK_STATUS,X
                lda TANK_START_X,X
                sta TANK_X,X
                lda TANK_START_Y,X
                sta TANK_Y,X
                lda #-1
                ldy RANDOM
                bpl _4

                lda #1
_4              sta TANK_DX,X
                jsr PositionTank
                jmp _7

_5              cmp #CRASH
                bne _13
                jmp _11

; RESTORE OLD POS
_13             lda TANK_X,X
                sta TEMP1
                jsr ComputeMapAddr

                stx TEMP1
                ldy #0
                txa
                asl
                adc TEMP1
                tax
_6              lda (ADR1),Y
                cmp #EXP
                beq _15

                cmp #MISS_LEFT
                beq _15

                cmp #MISS_RIGHT
                bne _12

_15             ldx TEMP1
                lda #CRASH
                sta TANK_STATUS,X
                ldy #2
                lda #EXP
_14             sta (ADR1),Y
                dey
                bpl _14

                lda #10
                sta TIM5_VAL
                jmp _11

_12             lda TANK_TEMP,X
                sta (ADR1),Y
                inx
                iny
                cpy #3
                bne _6

                ldy #1
                dec ADR1+1
                lda #0
                sta (ADR1),Y

; MOVE X
                ldx TEMP1
_7              jsr PositionTank

                lda TANK_X,X
                clc
                adc TANK_DX,X
                sta TANK_X,X

; SAVE NEW POS
                jsr PositionTank

                lda TANK_X,X
                sta TEMP1
                jsr ComputeMapAddr

                stx TEMP1
                ldy #0
                txa
                asl
                adc TEMP1
                tax
_8              lda (ADR1),Y
                sta TANK_TEMP,X
                inx
                iny
                cpy #3
                bne _8

; CHECK FOR COLLISION
                ldx TEMP1
                ldy #0
                jsr CheckTankCollision

                bcs _7
                ldy #2
                jsr CheckTankCollision

                bcs _7

; DRAW TANK
                ldy #2
_9              lda TANK_SHAPE,Y
                sta (ADR1),Y
                dey
                bpl _9

                dec ADR1+1
                ldy #$6F+128            ; 'o'
                lda CHOP_X
                sec
                sbc TANK_X,X
                bpl _10

                ldy #$70+128            ; 'p'
_10             tya
                ldy #1
                sta (ADR1),Y

_11             dex
                bmi MT2

                jmp _2

MT2
                dec TIM5_VAL
                bne _4

                lda #10
                sta TIM5_VAL

                ldx #MAX_TANKS-1
_1              lda TANK_STATUS,X
                cmp #CRASH
                bne _3

                lda #OFF
                sta TANK_STATUS,X
                lda TANK_X,X
                sta TEMP1
                lda TANK_Y,X
                sta TEMP2
                jsr ComputeMapAddr

                stx TEMP1
                ldy #0
                txa
                asl
                adc TEMP1
                tax
_2              lda TANK_TEMP,X
                sta (ADR1),Y
                inx
                iny
                cpy #3
                bne _2

                dec ADR1+1
                ldy #1
                lda #0
                sta (ADR1),Y
                ldx #$50
                ldy #$2
                jsr IncreaseScore

                ldx TEMP1
                jsr PositionTank

_3              lda TANK_STATUS,X
                cmp #OFF
                bne _10

                lda CHOP_Y
                cmp #3
                blt _10

                sec
                sbc #3
                cmp TANK_START_Y,X
                blt _10

                lda TANK_START_X,X
                sec
                sbc #5
                sta TEMP1
                lda TANK_START_Y,X
                sta TEMP2
                jsr ComputeMapAddr

                ldy #13-1
_9              lda (ADR1),Y
                bmi _10

                dey
                bpl _9

                lda #BEGIN
                sta TANK_STATUS,X

_10             dex
                bpl _1

_4              rts
                .endproc


;=======================================
;
;=======================================
CheckTankCollision .proc
                ldx #HIT_LIST2_LEN
_1              lda (ADR1),Y
                cmp HIT_LIST,X
                beq _2

                dex
                bpl _1

                ldx TEMP1
                clc
                rts

_2              ldx TEMP1
                lda TANK_DX,X
                eor #-2
                sta TANK_DX,X
                sec
                rts
                .endproc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
