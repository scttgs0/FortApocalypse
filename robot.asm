;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: robot.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ROB_X           .byte $84,$C3,$49,$C3,$49,$84,$84,$84
                .byte $D7,$D7,$D7,$D6,$D6,$D6,$33,$33
ROB_Y           .byte $00,$16,$16,$21,$21,$00,$00,$00
                .byte $12,$12,$12,$06,$06,$06,$06,$06

;=======================================
;
;=======================================
RobotAI         .proc
                lda R_STATUS
                cmp #OFF
                beq _1

                cmp #CRASH
                beq _XIT

                lda FRAME
                and ROBOT_SPD
                beq RobotStart

                rts

                lda TIM7_VAL
                beq _2

_1              dec TIM7_VAL
                bne _XIT
_2              lda #$88
                ;!! sta PCOLR2
                ;!! sta PCOLR3
                lda #8
                sta ROBOT_ANGLE
                lda SID_RANDOM
                and #7
                ldx LEVEL
                dex                     ; X=1?
                bne _3

                clc
                adc #8
_3              tax
                lda ROB_X,x
                sta R_X
                lda ROB_Y,x
                sta R_Y
                lda R_X
                sec
                sbc CHOP_X
                bpl _4

                eor #-2
_4              cmp #34
                bge _6

                lda R_Y
                sec
                sbc CHOP_Y
                bpl _5

                eor #-2
_5              cmp #8
                blt _XIT

_6              lda #FLY
                sta R_STATUS
                ldx #0
                stx R_FX
                stx R_FY
                stx TIM7_VAL
                inx                     ; X=1
                stx TIM8_VAL
                jmp PositionRobot

_XIT            rts
                .endproc


;=======================================
;
;=======================================
RobotStart      .proc
;v_???          .var TEMP4_I
;---

                lda ROBOT_ANGLE
                and #1
                sta TEMP4_I
                lda ROBOT_ANGLE
                and #$FE
                sta ROBOT_ANGLE
                jsr PositionRobot

R_F             .block
                dec TIM8_VAL
                bne _XIT

                lda #5
                sta TIM8_VAL
                lda ROBOT_STATUS
                cmp #ON
                bne _XIT

                lda ROCKET_STATUS+2
                bne _XIT

                lda ROBOT_ANGLE
                and #%00011110
                lsr
                cmp #4
                blt _2

                cmp #6
                bge _1

                lda #3
                bra _2

_1              sec
                sbc #2
_2              cmp #6
                blt _3

                lda #5
_3              cmp #0
                bne _4

                lda #1
_4              sta ROCKET_STATUS+2
                lda ROBOT_X
                and #3
                clc
                adc ROBOT_X
                adc #8
                sta ROCKET_X+2
                lda ROBOT_Y
                clc
                adc #8
                sta ROCKET_Y+2
                lda #$3F
                sta SND2_VAL
_XIT            .endblock

R_B             .block
                lda R_X
                ldx #215
                cmp #216
                beq _1

                ldx #49
                cmp #48
                bne _5

_1              lda FRAME
                and #3
                bne _4

                lda ROBOT_ANGLE
                cmp #4
                blt _2

                cmp #14
                blt _4

_2              cmp #8
                bge _3

                inc ROBOT_ANGLE
                inc ROBOT_ANGLE
                bra _4

_3              dec ROBOT_ANGLE
                dec ROBOT_ANGLE
_4              lda ROBOT_STATUS
                cmp #OFF
                bne _7

                stx R_X
                jmp _7

_5              lda CHOP_X
                sec
                sbc R_X
                beq _7
                bpl _6

                jsr RobotLeft
                jmp _7

_6              jsr RobotRight

_7              lda CHOP_Y
                sec
                sbc R_Y
                beq _9
                bpl _8

                jsr RobotUp
                jmp _9

_8              jsr RobotDown
_9              jsr PositionRobot
                .endblock

R_END           .block
                lda ROBOT_ANGLE
                bpl _1

                lda #0
                sta ROBOT_ANGLE
_1              cmp #18
                blt _2

                lda #16
                sta ROBOT_ANGLE
_2              lda ROBOT_ANGLE
                ora TEMP4_I
                sta ROBOT_ANGLE
                lda R_FX
                and #3
                sta R_FX
                lda R_FY
                and #7
                sta R_FY
                rts
                .endblock
                .endproc


;=======================================
;
;=======================================
RobotLeft       .proc
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                lda R_X
                sta TEMP1_I
                lda R_Y
                sta TEMP2_I
                jsr CheckChrI

                bcs _XIT

                dec TEMP1_I
                jsr CheckChrI

                bcs _XIT

                dec TEMP1_I
                jsr CheckChrI

                bcs _XIT

                dec R_FX
                lda R_FX
                cmp #-1
                bne _1

                dec R_X
_1              lda FRAME
                and #3
                bne _XIT

                dec ROBOT_ANGLE
                dec ROBOT_ANGLE
_XIT            rts
                .endproc


;=======================================
;
;=======================================
RobotRight      .proc
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                lda R_X
                sta TEMP1_I
                lda R_Y
                sta TEMP2_I
                jsr CheckChrI

                bcs _XIT

                inc TEMP1_I
                jsr CheckChrI

                bcs _XIT

                inc TEMP1_I
                jsr CheckChrI

                bcs _XIT

                inc R_FX
                lda R_FX
                cmp #4
                bne _1

                inc R_X
_1              lda FRAME
                and #3
                bne _XIT

                inc ROBOT_ANGLE
                inc ROBOT_ANGLE
_XIT            rts
                .endproc


;=======================================
;
;=======================================
RobotDown       .proc
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                lda R_X
                sta TEMP1_I
                lda R_Y
                sta TEMP2_I
                jsr CheckChrI

                bcs _XIT

                inc TEMP2_I
                jsr CheckChrI

                bcs _XIT

                inc TEMP2_I
                jsr CheckChrI

                bcs _XIT

                inc R_FY
                lda R_FY
                cmp #8
                bne _XIT

                inc R_Y

_XIT            rts
                .endproc


;=======================================
;
;=======================================
RobotUp         .proc
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                lda R_X
                sta TEMP1_I
                lda R_Y
                cmp #3
                blt _1

                sta TEMP2_I
                jsr CheckChrI

                bcs _XIT

                dec TEMP2_I
                jsr CheckChrI

                bcs _XIT

                dec TEMP2_I
                jsr CheckChrI

                bcs _XIT

                dec TEMP2_I
                jsr CheckChrI

                bcs _XIT

_1              dec R_FY
                lda R_FY
                cmp #-1
                bne _XIT

                dec R_Y
_XIT            rts
                .endproc


;=======================================
;
;=======================================
P1              .proc
                ldx #OFF
                jmp DoRobotChopper.DRCE

                .endproc


;=======================================
;
;=======================================
DoRobotChopper  .proc
;v_???          .var TEMP1_I
;---

                lda R_STATUS
                cmp #OFF
                beq P1

                lda R_X
                cmp SX
                blt P1

                sec
                sbc SX
                cmp #48
                bge P1

                ldy SY
                bpl _1

                ldy #0
_1              sty TEMP1_I
                lda R_Y
                cmp TEMP1_I
                blt P1

                sec
                sbc SY
                cmp #19
                bge P1

                lda R_X
                sec
                sbc SX
                asl
                asl
                clc
                adc #22
                sta TEMP1_I
                lda SX_F
                and #3
                clc
                adc TEMP1_I
                adc R_FX
                sta ROBOT_X
                lda R_Y
                ldy SY
                bpl _2

                ldy #0
_2              sty TEMP1_I
                sec
                sbc TEMP1_I
                asl
                asl
                asl
                clc
                adc #71+12
                sta TEMP1_I
                lda SY_F
                eor #$FF
                and #7
                clc
                adc TEMP1_I
                ldy SY
                bpl _3

                clc
                adc #8
_3              clc
                adc R_FY
                sta ROBOT_Y
                ldx #FLY
                lda ROBOT_COL
                beq _4

                lda R_STATUS
                cmp #CRASH
                beq _4

                ldx #CRASH
                lda #20
                sta TIM7_VAL
                lda #1
                sta SND3_VAL
_4              lda R_STATUS
                cmp #CRASH
                beq _5

                stx R_STATUS
_5              ldx #ON
DRCE            stx ROBOT_STATUS
                rts
                .endproc


;=======================================
;
;=======================================
UpdateRobotChopper .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                lda ROBOT_STATUS
                cmp #OFF
                bne _1

                lda #0
                sta ROBOT_X
                sta ROBOT_Y

_1              ldy OROBOT_Y
                ldx #17
                lda #0
_next1          sta PLAYER+PL2,y
                sta PLAYER+PL3,y
                iny
                dex
                bpl _next1

                lda ROBOT_ANGLE
                asl
                tax
                lda CHOPPER_SHAPES,x
                sta ADR1_I
                lda CHOPPER_SHAPES+1,x
                sta ADR1_I+1

                lda #0
                sta TEMP1_I
                lda #18
                sta TEMP2_I

                ldx ROBOT_Y
                stx OROBOT_Y
_next2          ldy TEMP1_I
                lda (ADR1_I),y
                sta PLAYER+PL2,x
                ldy TEMP2_I
                lda (ADR1_I),y
                sta PLAYER+PL3,x
                inc TEMP1_I
                inc TEMP2_I
                inx
                lda TEMP1_I
                cmp #18
                bne _next2

                lda R_STATUS
                cmp #CRASH
                bne _2

                ldx ROBOT_Y
                ldy #18
_next3          lda PLAYER+PL2,x
                and SID_RANDOM
                sta PLAYER+PL2,x
                lda PLAYER+PL3,x
                and SID_RANDOM
                sta PLAYER+PL3,x
                inx
                dey
                bne _next3

                ;!! inc PCOLR2
                ;!! inc PCOLR3
                dec TIM7_VAL
                bne _2

                lda #OFF
                sta R_STATUS
                jsr PositionRobot

                lda #255
                sta TIM7_VAL
_2              lda FRAME
                and #3
                bne _XIT

                lda ROBOT_ANGLE
                eor #1
                sta ROBOT_ANGLE

_XIT            rts
                .endproc


;=======================================
;
;=======================================
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
                lda (ADR1_I),y
                eor POS_MASK1,x
                sta (ADR1_I),y
                rts
                .endproc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
