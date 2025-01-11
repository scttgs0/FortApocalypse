
;--------------------------------------
;--------------------------------------
; FILE: FORT4.ASM
;--------------------------------------
; MAIN INTERRUPT DRIVER
;       PART (II)
; POSITION THINGS
; ReadJoystick
; ReadTrigger
; DoLaser1
; DoLaser2
; DoBlocks
; DoElevator
; DoExplode
; DoNumbers
; DrawMap
;--------------------------------------
;--------------------------------------


;======================================
;
;======================================
PositionChopper .proc
v_posX          .var TEMP1_I
v_posY          .var TEMP2_I
;---

                lda CHOP_X
                sta v_posX
                lda CHOP_Y
                sta v_posY

                jmp PositionRobot.POS_IT_I

                .endproc


;======================================
;
;======================================
PositionRobot   .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;v_???          .var TEMP3_I
;---

                lda R_X
                sta TEMP1_I
                lda R_Y
                sta TEMP2_I

POS_IT_I        ldx TEMP1_I
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
                .endproc


;======================================
;
;======================================
ReadJoystick    .proc
v_angleBit0     .var TEMP1_I
;---

                lda CHOPPER_STATUS      ; skip joystick read when Off
                cmp #OFF
                beq _XIT

                cmp #CRASH              ; skip joystick read when Crashed
                bne _doStick

_XIT            rts

_doStick        lda CHOPPER_ANGLE
                and #1
                sta v_angleBit0

                lda CHOPPER_ANGLE
                and #$FE
                sta CHOPPER_ANGLE

                lda DEMO_STATUS
                bne _2

                ldx DEMO_COUNT
                lda DEMO_STICK,X
                sta STICK

                lda FRAME
                and #$F
                bne _2

                inx
                cpx #$6C
                bcc _1

                ldx #0
_1              stx DEMO_COUNT

_2              ldx STICK
                cpx #$F
                bne _3

                jsr Hover

                lda #20
                sta SND1_2_VAL

_3              lda FUEL_STATUS
                cmp #EMPTY
                bne _chk_right

                lda #60
                sta SND1_2_VAL

_chk_right      txa
                and #RIGHT
                bne _chk_left

                lda #17
                sta SND1_2_VAL

                lda CHOPPER_ANGLE
                cmp #14
                bcs _4

                lda FRAME
                and #1
                bne _5

_4              inc CHOPPER_X

_5              lda FRAME
                and #3
                bne _chk_left

                inc CHOPPER_ANGLE
                inc CHOPPER_ANGLE

_chk_left       txa
                and #LEFT
                bne _chk_up

                lda #17
                sta SND1_2_VAL

                lda CHOPPER_ANGLE
                cmp #4
                bcc _6

                lda FRAME
                and #1
                bne _7

_6              dec CHOPPER_X

_7              lda FRAME
                and #3
                bne _chk_up

                dec CHOPPER_ANGLE
                dec CHOPPER_ANGLE

_chk_up         lda FUEL_STATUS
                cmp #EMPTY
                beq _chk_down

                txa
                and #UP
                bne _chk_down

                lda #13
                sta SND1_2_VAL

                dec CHOPPER_Y

                jsr Hover

_chk_down       txa
                and #DOWN
                bne _8

                lda #26
                sta SND1_2_VAL

                lda CHOPPER_STATUS
                cmp #LAND
                beq _8

                cmp #PICKUP
                beq _8

                inc CHOPPER_Y

                jsr Hover

_8              lda CHOPPER_ANGLE
                bpl _9

                lda #0
                sta CHOPPER_ANGLE

_9              cmp #18
                bcc _10

                lda #16
                sta CHOPPER_ANGLE

_10             lda CHOPPER_ANGLE
                ora v_angleBit0
                sta CHOPPER_ANGLE

                rts
                .endproc


;======================================
;
;======================================
ReadTrigger     .proc
                lda CHOPPER_STATUS      ; skip trigger read when crashed
                cmp #CRASH
                beq _XIT

                lda DEMO_STATUS
                bne _1

                lda FRAME
                and #$F
                beq _4

                rts

_1              ldx TRIG0
                beq _2

                stx TRIG_FLAG

                rts

_2              lda TRIG_FLAG
                beq _XIT

                stx TRIG_FLAG

                lda MODE
                cmp #TITLE_MODE
                beq _3

                cmp #OPTION_MODE
                bne _4

_3              lda #START_MODE
                sta MODE
                sta DEMO_STATUS

_4              lda ELEVATOR_DX
                eor #-2
                sta ELEVATOR_DX

                ldx #1
_next1          lda ROCKET_STATUS,X
                beq _5

                dex
                bpl _next1

_XIT            rts

_5              lda CHOPPER_ANGLE
                and #%00011110
                lsr
                cmp #4
                bcc _7

                cmp #6
                bcs _6

                lda #3
                bne _7

_6              sec
                sbc #2
_7              cmp #6
                bcc _8

                lda #5
_8              cmp #0
                bne _9

                lda #1
_9              sta ROCKET_STATUS,X

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
                .endproc


;======================================
;
;======================================
Hover           .proc
                lda FRAME
                and #7
                bne _XIT

                lda CHOPPER_ANGLE
                cmp #4
                bcc _1

                cmp #14
                bcc _XIT

_1              cmp #8
                bcs _2

                inc CHOPPER_ANGLE
                inc CHOPPER_ANGLE

                rts

_2              dec CHOPPER_ANGLE
                dec CHOPPER_ANGLE

_XIT            rts
                .endproc


;======================================
;
;======================================
DrawMap         .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

DO_X            .block
                ldx CHOPPER_X
                cpx #MIN_RIGHT+1
                bcc _2

                ldx #MIN_RIGHT
                stx CHOPPER_X

                lda SX
                cmp #$D8+1
                bcc _1

                lda #1+1
                sta SX

_1              dec SX_F
                lda SX_F
                and #3
                eor #3
                bne _2

                inc SX

_2              cpx #MIN_LEFT
                bcs _XIT

                ldx #MIN_LEFT
                stx CHOPPER_X

                lda SX
                cmp #1+1+1
                bcs _3

                lda #$D8+1
                sta SX

_3              inc SX_F
                lda SX_F
                and #3
                bne _XIT

                dec SX
_XIT            .endblock

; - - - - - - - - - - - - - - - - - - -
DO_Y            .block
                lda SY
                cmp #24
                beq _1

                ldx CHOPPER_Y
                cpx #MIN_DOWN+1
                bcc _1

                ldx #MIN_DOWN
                stx CHOPPER_Y
                bne _2                  ; [unc]

_1              ldx CHOPPER_Y
                cpx #MAX_DOWN+1
                bcc _3

                lda #MAX_DOWN
                sta CHOPPER_Y

                lda SY_F
                and #7
                bne _2

                lda SY
                cmp #24
                beq _3

_2              inc SY_F
                lda SY_F
                and #7
                bne _3

                inc SY
_3              lda SY
                cmp #-1
                beq _4

                cpx #MIN_UP
                bcs _4

                ldx #MIN_UP
                stx CHOPPER_Y
                bne _5                  ; [unc]

_4              cpx #MAX_UP
                bcs _6

                lda #MAX_UP
                sta CHOPPER_Y

                lda SY_F
                and #7
                eor #7
                bne _5

                lda SY
                cmp #-1
                beq _6

_5              dec SY_F
                lda SY_F
                and #7
                eor #7
                bne _6

                dec SY

_6              lda SX_F
                and #3
                sta HSCROL
                lda SY_F
                and #7
                sta VSCROL

                lda SX
                sta TEMP1_I
                lda SY
                sta TEMP2_I

                jsr ComputeMapAddrI

; for each map row, recalculate the display list LMS address
                ldx #0
                ldy #MAP_LINES
_nextRow        inx

                lda ADR1_I
                sta DSP_MAP,X
                inx
                lda ADR1_I+1
                sta DSP_MAP,X

                inc ADR1_I+1

                inx
                dey
                bne _nextRow

                rts
                .endblock
                .endproc


;======================================
;
;======================================
ComputeMapAddrI .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

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
                .endproc


;======================================
;
;======================================
ComputeMapAddr  .proc
;v_???          .var ADR1
v_posX          .var TEMP1
v_posY          .var TEMP2
;---

                lda #<MAP-5
                clc
                adc v_posX
                sta ADR1
                lda #>MAP-5
                adc #0
                sta ADR1+1

                lda v_posY
                clc
                adc ADR1+1
                sta ADR1+1

                rts
                .endproc


;======================================
;
;======================================
DoLaser1        .proc
                lda FRAME
                and #7
                bne _XIT

                lda LASER_STATUS
                cmp #OFF
                beq _1

                lda TIM1_VAL
                clc
                adc LASER_SPD
                sta TIM1_VAL
                bne _1

                ldx #0
_next1          lda LASER_SHAPES,X
                sta LASERS_1,X

                inx
                cpx #32
                bne _next1

                ldx #0
_next2          lda LASER_SHAPES+24,X
                sta LASER_3,X

                inx
                cpx #8
                bne _next2

                rts

_1              ldx #32-1
                lda #0
_next3          sta LASERS_1,X

                dex
                bpl _next3

                ldx #8-1
_next4          sta LASER_3,X

                dex
                bpl _next4

_XIT            rts
                .endproc


;======================================
;
;======================================
DoLaser2        .proc
                lda FRAME
                and #7
                bne _XIT

                lda LASER_STATUS
                cmp #OFF
                beq _1

                lda TIM2_VAL
                clc
                adc LASER_SPD
                sta TIM2_VAL
                bne _1

                ldx #0
_next1          lda LASER_SHAPES,X
                sta LASERS_2,X

                inx
                cpx #32
                bne _next1

                ldx #0
_next2          lda LASER_SHAPES+16,X
                sta LASER_3,X

                inx
                cpx #8
                bne _next2

                rts

_1              ldx #32-1
                lda #0
_next3          sta LASERS_2,X

                dex
                bpl _next3

_XIT            rts
                .endproc


;======================================
;
;======================================
DoBlocks        .proc
                lda FRAME
                and #$7F
                bne _XIT

                ldx #32-1
                lda #0
_next1          sta BLOCK_1,X

                dex
                bpl _next1

                lda RANDOM
                bmi _1

                ldx #7
                lda #$55
_next2          sta BLOCK_1,X

                dex
                bpl _next2

_1              lda RANDOM
                bmi _2

                ldx #7
                lda #$55
_next3          sta BLOCK_2,X

                dex
                bpl _next3

_2              lda RANDOM
                bmi _3

                ldx #7
                lda #$55
_next4          sta BLOCK_3,X

                dex
                bpl _next4

_3              lda RANDOM
                bmi _XIT

                ldx #7
                lda #$55
_next5          sta BLOCK_4,X

                dex
                bpl _next5

_XIT            rts
                .endproc


;======================================
;
;======================================
DoElevator      .proc
;v_???          .var ADR1_I
;---

                dec ELEVATOR_TIM
                bne _XIT

                lda ELEVATOR_SPD
                sta ELEVATOR_TIM

                ldx #32-1
                lda #0
_next1          sta BLOCK_5,X

                dex
                bpl _next1

                lda ELEVATOR_NUM
                clc
                adc ELEVATOR_DX
                sta ELEVATOR_NUM        ; redundant
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
_next2          sta (ADR1_I),Y

                dey
                bpl _next2

_XIT            rts
                .endproc


;--------------------------------------
;--------------------------------------

ELEVATORS       .addr BLOCK_5,BLOCK_6
                .addr BLOCK_7,BLOCK_8


;======================================
;
;======================================
DoExplode       .proc
                ldx #7
_next1          lda EXP_SHAPE,X
                and RANDOM
                sta EXPLOSION,X
                sta EXPLOSION2,X

                dex
                bpl _next1

                ldx #3
_next2          lda RANDOM
                and #$0F
                ora #$A0
                sta MISS_CHR_LEFT,X

                inx
                cpx #5
                bne _next2

                ldx #3
_next3          lda RANDOM
                and #$E0
                ora #$0A
                sta MISS_CHR_RIGHT,X

                inx
                cpx #5
                bne _next3

                rts
                .endproc


;======================================
;
;======================================
DoNumbers       .proc
                lda MODE
                cmp #NEW_PLAYER_MODE
                beq _XIT

                cmp #GAME_OVER_MODE
                bne DO_N

_XIT            rts

; - - - - - - - - - - - - - - - - - - -
; SCORE
DO_N            .block
                lda #<SCORE_DIG
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
                bne _3

                lda FUEL_STATUS
                cmp #FULL
                bne _3

                lda FUEL1
                ora FUEL2
                beq _2

                lda FRAME
                and #15
                bne _3

                sed
                lda FUEL1
                sec
                sbc #1
                sta FUEL1
                lda FUEL2
                sbc #0
                sta FUEL2
                cld

                jmp _3

_2              lda #EMPTY
                sta FUEL_STATUS

; FUEL
_3              lda #<FUEL_DIG
                sta SCRN_ADR
                lda #>FUEL_DIG
                sta SCRN_ADR+1

                lda #0
                sta SCRN_FLG

                ldx #3
                lda FUEL2
                jsr DDIG

                lda FUEL1
                .endblock

; - - - - - - - - - - - - - - - - - - -
DDIG            .block                  ; DRAW DIGIT
                tay
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
                .endblock

; - - - - - - - - - - - - - - - - - - -
DRAW            .block
                cmp #$A
                bne _2

                cpx #0
                bne _1

                lda #0
                beq _2                  ; [unc]

_1              lda #<$F0+128           ; BLANK
_2              clc
                adc #$10+128            ; '0'
                ldy #0
                sta (SCRN_ADR),Y

                cmp #$10+128
                bne _3

                lda #$A+128

_3              iny
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
                .endblock
                .endproc


;======================================
;
;======================================
IncreaseScore   .proc
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


;--------------------------------------
;--------------------------------------

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
