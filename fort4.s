;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT4.S
;---------------------------------------
; MAIN INTERUPT DRIVER
;       PART (II)
; POSITION THINGS
; READ_STICK
; READ_TRIG
; DO_LASER_1
; DO_LASER_2
; DO_BLOCKS
; DO_ELEVATOR
; DO_EXP
; DoNumbers
; DRAW_MAP
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

POS_CHOPPER
                lda CHOP_X
                sta TEMP1_I
                lda CHOP_Y
                sta TEMP2_I
                jmp POS_IT_I

POS_ROBOT
                lda R_X
                sta TEMP1_I
                lda R_Y
                sta TEMP2_I
;               JMP POS_IT_I

POS_IT_I
                ldx TEMP1_I
                lda TEMP2_I

                asl
                asl
                adc TEMP2_I
                ldy #0
                sty TEMP3_I
                asl
                rol TEMP3_I
                asl
                rol TEMP3_I
                asl
                rol TEMP3_I
                sta TEMP2_I

                txa
                lsr
                lsr
                lsr
                clc
                adc #<SCANNER+3
                adc TEMP2_I
                sta ADR1_I
                lda #>SCANNER
                adc TEMP3_I
                sta ADR1_I+1
                txa
                and #7
                tax
                ldy #0
                lda (ADR1_I),Y
                eor POS_MASK1,X
                sta (ADR1_I),Y
                rts

READ_STICK
                lda CHOPPER_STATUS
                cmp #OFF
                beq _1
                cmp #CRASH
                bne DO_STICK
_1              rts
DO_STICK
                lda CHOPPER_ANGLE
                and #1
                sta TEMP1_I
                lda CHOPPER_ANGLE
                and #$FE
                sta CHOPPER_ANGLE
                lda DEMO_STATUS
;               CMP #0                  ; ON
                bne _20
                ldx DEMO_COUNT
                lda DEMO_STICK,X
                sta STICK
                lda FRAME
                and #$F
                bne _20
                inx
                cpx #$6C
                blt _19
                ldx #0
_19             stx DEMO_COUNT
_20             ldx STICK
                cpx #$F
                bne _0
                jsr HOVER
                lda #20
                sta SND1_2_VAL
_0              lda FUEL_STATUS
                cmp #EMPTY
                bne _10
                lda #60
                sta SND1_2_VAL
_10             txa
                and #RIGHT
                bne _1
                lda #17
                sta SND1_2_VAL
                lda CHOPPER_ANGLE
                cmp #14
                bge _70
                lda FRAME
                and #1
                bne _71
_70             inc CHOPPER_X
_71             lda FRAME
                and #3
                bne _1
                inc CHOPPER_ANGLE
                inc CHOPPER_ANGLE
_1              txa
                and #LEFT
                bne _2
                lda #17
                sta SND1_2_VAL
                lda CHOPPER_ANGLE
                cmp #4
                blt _73
                lda FRAME
                and #1
                bne _74
_73             dec CHOPPER_X
_74             lda FRAME
                and #3
                bne _2
                dec CHOPPER_ANGLE
                dec CHOPPER_ANGLE
_2              lda FUEL_STATUS
                cmp #EMPTY
                beq _3
                txa
                and #UP
                bne _3
                lda #13
                sta SND1_2_VAL
                dec CHOPPER_Y
                jsr HOVER
_3              txa
                and #DOWN
                bne _4
                lda #26
                sta SND1_2_VAL
                lda CHOPPER_STATUS
                cmp #LAND
                beq _4
                cmp #PICKUP
                beq _4
                inc CHOPPER_Y
                jsr HOVER

_4              lda CHOPPER_ANGLE
                bpl _5
                lda #0
                sta CHOPPER_ANGLE
_5              cmp #18
                blt _6
                lda #16
                sta CHOPPER_ANGLE
_6              lda CHOPPER_ANGLE
                ora TEMP1_I
                sta CHOPPER_ANGLE
                rts

READ_TRIG
                lda CHOPPER_STATUS
                cmp #CRASH
                beq _2

                lda DEMO_STATUS
;               CMP #0                  ; ON
                bne _9
                lda FRAME
                and #$F
                beq _10
                rts

_9              ldx TRIG0
                beq _0
                stx TRIG_FLAG
                rts
_0              lda TRIG_FLAG
                beq _2
                stx TRIG_FLAG
                lda MODE
                cmp #TITLE_MODE
                beq _30
                cmp #OPTION_MODE
                bne _10
_30             lda #START_MODE
                sta MODE
;               LDA #1
                sta DEMO_STATUS
_10             lda ELEVATOR_DX
                eor #-2
                sta ELEVATOR_DX
                ldx #1
_1              lda ROCKET_STATUS,X
                beq _3
                dex
                bpl _1
_2              rts

_3              lda CHOPPER_ANGLE
                and #%00011110
                lsr
                cmp #4
                blt _6
                cmp #6
                bge _7
                lda #3
                bne _6
_7              sec
                sbc #2
_6              cmp #6
                blt _4
                lda #5
_4              cmp #0
                bne _5
                lda #1
_5              sta ROCKET_STATUS,X
                lda CHOPPER_X
                and #3
                clc
                adc CHOPPER_X
                adc #8
                sta ROCKET_X,X
                lda CHOPPER_Y
                clc
                adc #8
                sta ROCKET_Y,X
                lda #$3F
                sta SND2_VAL
                rts

HOVER           lda FRAME
                and #7
                bne _2
                lda CHOPPER_ANGLE
                cmp #4
                blt _3
                cmp #14
                blt _2
_3              cmp #8
                bge _1
                inc CHOPPER_ANGLE
                inc CHOPPER_ANGLE
                rts
_1              dec CHOPPER_ANGLE
                dec CHOPPER_ANGLE
_2              rts

DRAW_MAP
DO_X
                ldx CHOPPER_X
                cpx #MIN_RIGHT+1
                blt _2
                ldx #MIN_RIGHT
                stx CHOPPER_X
                lda SX
                cmp #$D8+1
                blt _1
                lda #1+1
                sta SX
_1              dec SX_F
                lda SX_F
                and #3
                eor #3
                bne _2
                inc SX

_2              cpx #MIN_LEFT
                bge _4
                ldx #MIN_LEFT
                stx CHOPPER_X
                lda SX
                cmp #1+1+1
                bge _3
                lda #$D8+1
                sta SX
_3              inc SX_F
                lda SX_F
                and #3
;               EOR #0
                bne _4
                dec SX
_4
DO_Y
                lda SY
                cmp #24
                beq _80
                ldx CHOPPER_Y
                cpx #MIN_DOWN+1
                blt _80
                ldx #MIN_DOWN
                stx CHOPPER_Y
                bne _21                 ; FORCED
_80             ldx CHOPPER_Y
                cpx #MAX_DOWN+1
                blt _3
                lda #MAX_DOWN
                sta CHOPPER_Y
                lda SY_F
                and #7
;               EOR #0
                bne _21
                lda SY
                cmp #24
                beq _3
_21             inc SY_F
                lda SY_F
                and #7
;               EOR #0
                bne _3
                inc SY
_3              lda SY
                cmp #-1
                beq _81
                cpx #MIN_UP
                bge _81
                ldx #MIN_UP
                stx CHOPPER_Y
                bne _31                 ; FORCED
_81             cpx #MAX_UP
                bge _4
                lda #MAX_UP
                sta CHOPPER_Y
                lda SY_F
                and #7
                eor #7
                bne _31
                lda SY
                cmp #-1
                beq _4
_31             dec SY_F
                lda SY_F
                and #7
                eor #7
                bne _4
                dec SY

_4              lda SX_F
                and #3
                sta HSCROL
                lda SY_F
                and #7
                sta VSCROL
                lda SX
                sta TEMP1_I
                lda SY
                sta TEMP2_I
                jsr COMPUTE_MAP_ADR_I
                ldx #0
                ldy #MAP_LINES
_5              inx
                lda ADR1_I
                sta DSP_MAP,X
                inx
                lda ADR1_I+1
                sta DSP_MAP,X
                inc ADR1_I+1
                inx
                dey
                bne _5
                rts

COMPUTE_MAP_ADR_I
                lda #<MAP-5
                clc
                adc TEMP1_I
                sta ADR1_I
                lda #>MAP-5
                adc #0
                sta ADR1_I+1
                lda TEMP2_I
                clc
                adc ADR1_I+1
                sta ADR1_I+1
                rts

ComputeMapAddr
                lda #<MAP-5
                clc
                adc TEMP1
                sta ADR1
                lda #>MAP-5
                adc #0
                sta ADR1+1
                lda TEMP2
                clc
                adc ADR1+1
                sta ADR1+1
                rts

DO_LASER_1
                lda FRAME
                and #7
                bne _4
                lda LASER_STATUS
                cmp #OFF
                beq _2
                lda TIM1_VAL
                clc
                adc LASER_SPD
                sta TIM1_VAL
                bne _2
                ldx #0
_1              lda LASER_SHAPES,X
                sta LASERS_1,X
                inx
                cpx #32
                bne _1
                ldx #0
_5              lda LASER_SHAPES+24,X
                sta LASER_3,X
                inx
                cpx #8
                bne _5
                rts
_2              ldx #32-1
                lda #0
_3              sta LASERS_1,X
                dex
                bpl _3
                ldx #8-1
;               LDA #0
_6              sta LASER_3,X
                dex
                bpl _6
_4              rts

DO_LASER_2
                lda FRAME
                and #7
                bne _4
                lda LASER_STATUS
                cmp #OFF
                beq _2
                lda TIM2_VAL
                clc
                adc LASER_SPD
                sta TIM2_VAL
                bne _2
                ldx #0
_1              lda LASER_SHAPES,X
                sta LASERS_2,X
                inx
                cpx #32
                bne _1
                ldx #0
_5              lda LASER_SHAPES+16,X
                sta LASER_3,X
                inx
                cpx #8
                bne _5
                rts
_2              ldx #32-1
                lda #0
_3              sta LASERS_2,X
                dex
                bpl _3
_4              rts

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

DO_ELEVATOR
                dec ELEVATOR_TIM
                bne _3
                lda ELEVATOR_SPD
                sta ELEVATOR_TIM
                ldx #32-1
                lda #0
_1              sta BLOCK_5,X
                dex
                bpl _1
                lda ELEVATOR_NUM
                clc
                adc ELEVATOR_DX
                sta ELEVATOR_NUM
                and #3
                sta ELEVATOR_NUM
                asl
                tax
                lda ELEVATORS,X
                sta ADR1_I
                lda ELEVATORS+1,X
                sta ADR1_I+1
                ldy #7
                lda #$55
_2              sta (ADR1_I),Y
                dey
                bpl _2
_3              rts

ELEVATORS
                .addr BLOCK_5,BLOCK_6
                .addr BLOCK_7,BLOCK_8

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

DoNumbers
                lda MODE
                cmp #NEW_PLAYER_MODE
                beq _1
                cmp #GAME_OVER_MODE
                bne DO_N
_1              rts
; SCORE
DO_N            lda #<SCORE_DIG
                sta SCRN_ADR
                lda #>SCORE_DIG
                sta SCRN_ADR+1
                lda #0
                sta SCRN_FLG
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
                sta SCRN_ADR
                lda #>BONUS_DIG
                sta SCRN_ADR+1
                lda #0
                sta SCRN_FLG
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
                sta SCRN_ADR
                lda #>FUEL_DIG
                sta SCRN_ADR+1
                lda #0
                sta SCRN_FLG
                ldx #3
                lda FUEL2
                jsr DDIG
                lda FUEL1
;               JSR DDIG
;               RTS

;
; DRAW DIGIT
;
DDIG            tay
                lda SCRN_FLG
                bne _1
                tya
                and #$F0
                bne _1
                tya
                ora #$A0
                tay
                bne _2
_1              lda #1
                sta SCRN_FLG
_2              lda SCRN_FLG
                bne _3
                tya
                and #$F
                bne _3
                tya
                ora #$A
                tay
                bne _4
_3              lda #1
                sta SCRN_FLG
_4              tya
                sta SCRN_TEMP
                lsr
                lsr
                lsr
                lsr
                jsr DRAW
                lda SCRN_TEMP
                and #$F
;               JSR DRAW
;               RTS

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
                sta (SCRN_ADR),Y
                cmp #$10+128
                bne _2
                lda #$A+128
_2              iny
                and #$8F
                sta (SCRN_ADR),Y
                lda SCRN_ADR
                clc
                adc #2
                sta SCRN_ADR
                lda SCRN_ADR+1
                adc #0
                sta SCRN_ADR+1
                dex
                rts

INC_SCORE
                lda DEMO_STATUS
;               CMP #0                  ; ON
                beq _1
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
_1              rts

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
