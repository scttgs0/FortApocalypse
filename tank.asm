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
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda TANK_X,x
                sta TEMP1

                ldy TANK_Y,x
                dey
                sty TEMP2

                jsr PositionIt

                lda TANK_Y,x
                sta TEMP2
                rts
                .endproc


;=======================================
;
;=======================================
MoveTanks       .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

MT1             .block
                dec TANK_SPD
                beq _1
                jmp MT2

_1              lda TANK_SPEED
                sta TANK_SPD

                ldx #MAX_TANKS-1

_2              lda TANK_Y,x
                sta TEMP2
                lda TANK_STATUS,x
                cmp #OFF
                bne _3

                jmp _11

_3              cmp #BEGIN
                bne _5

                lda #ON
                sta TANK_STATUS,x
                lda TANK_START_X,x
                sta TANK_X,x
                lda TANK_START_Y,x
                sta TANK_Y,x
                lda #-1
                ;!! ldy RANDOM
                bpl _4

                lda #1
_4              sta TANK_DX,x
                jsr PositionTank
                jmp _7

_5              cmp #CRASH
                bne _13
                jmp _11

; RESTORE OLD POS
_13             lda TANK_X,x
                sta TEMP1
                jsr ComputeMapAddr

                stx TEMP1
                ldy #0
                txa
                asl
                adc TEMP1
                tax
_6              lda (ADR1),y
                cmp #EXP
                beq _15

                cmp #MISS_LEFT
                beq _15

                cmp #MISS_RIGHT
                bne _12

_15             ldx TEMP1
                lda #CRASH
                sta TANK_STATUS,x
                ldy #2
                lda #EXP
_14             sta (ADR1),y
                dey
                bpl _14

                lda #10
                sta TIM5_VAL
                jmp _11

_12             lda TANK_TEMP,x
                sta (ADR1),y
                inx
                iny
                cpy #3
                bne _6

                ldy #1
                dec ADR1+1
                lda #0
                sta (ADR1),y

; MOVE X
                ldx TEMP1
_7              jsr PositionTank

                lda TANK_X,x
                clc
                adc TANK_DX,x
                sta TANK_X,x

; SAVE NEW POS
                jsr PositionTank

                lda TANK_X,x
                sta TEMP1
                jsr ComputeMapAddr

                stx TEMP1
                ldy #0
                txa
                asl
                adc TEMP1
                tax
_8              lda (ADR1),y
                sta TANK_TEMP,x
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
_9              lda TANK_SHAPE,y
                sta (ADR1),y
                dey
                bpl _9

                dec ADR1+1
                ldy #$6F+128            ; 'o'
                lda CHOP_X
                sec
                sbc TANK_X,x
                bpl _10

                ldy #$70+128            ; 'p'
_10             tya
                ldy #1
                sta (ADR1),y

_11             dex
                bmi MT2

                jmp _2
                .endblock


_XIT            rts


MT2             .block
                dec TIM5_VAL
                bne MoveTanks._XIT

                lda #10
                sta TIM5_VAL

                ldx #MAX_TANKS-1
_next1          lda TANK_STATUS,x
                cmp #CRASH
                bne _1

                lda #OFF
                sta TANK_STATUS,x
                lda TANK_X,x
                sta TEMP1
                lda TANK_Y,x
                sta TEMP2
                jsr ComputeMapAddr

                stx TEMP1
                ldy #0
                txa
                asl
                adc TEMP1
                tax
_next2          lda TANK_TEMP,x
                sta (ADR1),y
                inx
                iny
                cpy #3
                bne _next2

                dec ADR1+1
                ldy #1
                lda #0
                sta (ADR1),y
                ldx #$50
                ldy #$2
                jsr IncreaseScore

                ldx TEMP1
                jsr PositionTank

_1              lda TANK_STATUS,x
                cmp #OFF
                bne _2

                lda CHOP_Y
                cmp #3
                blt _2

                sec
                sbc #3
                cmp TANK_START_Y,x
                blt _2

                lda TANK_START_X,x
                sec
                sbc #5
                sta TEMP1
                lda TANK_START_Y,x
                sta TEMP2
                jsr ComputeMapAddr

                ldy #13-1
_next3          lda (ADR1),y
                bmi _2

                dey
                bpl _next3

                lda #BEGIN
                sta TANK_STATUS,x

_2              dex
                bpl _next1

                rts
                .endblock
                .endproc


;=======================================
;
;=======================================
CheckTankCollision .proc
;v_???          .var TEMP1
;---

                ldx #HIT_LIST2_LEN
_1              lda (ADR1),y
                cmp HIT_LIST,x
                beq _2

                dex
                bpl _1

                ldx TEMP1
                clc
                rts

_2              ldx TEMP1
                lda TANK_DX,x
                eor #-2
                sta TANK_DX,x
                sec
                rts
                .endproc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
