
; SPDX-FileName: robot.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


ROB_X           .byte $84,$C3,$49,$C3,$49,$84,$84,$84
                .byte $D7,$D7,$D7,$D6,$D6,$D6,$33,$33
ROB_Y           .byte $00,$16,$16,$21,$21,$00,$00,$00
                .byte $12,$12,$12,$06,$06,$06,$06,$06

;======================================
;
;======================================
RobotAI         .proc
                lda R_STATUS
                cmp #kOFF
                beq _1

                cmp #kCRASH
                beq _XIT

                lda FRAME
                and ROBOT_SPD
                beq RobotStart

                rts

;--------------------------------------
                lda TIM7_VAL            ; dead code
                beq _2
;--------------------------------------

_1              dec TIM7_VAL
                bne _XIT

_2              lda #$88
                ;!! sta PCOLR2
                ;!! sta PCOLR3

                lda #$08
                sta ROBOT_ANGLE

                .frsRandomByte
                and #$07

                ldx LEVEL
                dex                     ; X=1?
                bne _3

                clc
                adc #$08
_3              tax

                lda ROB_X,X
                sta R_X
                lda ROB_Y,X
                sta R_Y

                lda R_X
                sec
                sbc CHOP_X
                bpl _4

                eor #-2
_4              cmp #$22
                bcs _6

                lda R_Y
                sec
                sbc CHOP_Y
                bpl _5

                eor #-2
_5              cmp #$08
                bcc _XIT

_6              lda #kFLY
                sta R_STATUS

                ldx #$00
                stx R_FX
                stx R_FY
                stx TIM7_VAL

                inx                     ; X=1
                stx TIM8_VAL

                jmp PositionRobot

_XIT            rts
                .endproc


;======================================
;
;======================================
RobotStart      .proc
;v_???          .var TEMP4_I
;---

                lda ROBOT_ANGLE
                and #$01
                sta TEMP4_I

                lda ROBOT_ANGLE
                and #$FE
                sta ROBOT_ANGLE

                jsr PositionRobot

; - - - - - - - - - - - - - - - - - - -
R_F             .block
                dec TIM8_VAL
                bne _XIT

                lda #$05
                sta TIM8_VAL

                lda ROBOT_STATUS
                cmp #kON
                bne _XIT

                lda ROCKET_STATUS+2
                bne _XIT

                lda ROBOT_ANGLE
                and #%00011110
                lsr
                cmp #$04
                bcc _2

                cmp #$06
                bcs _1

                lda #$03
                bra _2

_1              sec
                sbc #$02
_2              cmp #$06
                bcc _3

                lda #$05
_3              cmp #$00
                bne _4

                lda #$01
_4              sta ROCKET_STATUS+2

                lda ROBOT_X
                and #$03
                clc
                adc ROBOT_X
                adc #$08
                sta ROCKET_X+2

                lda ROBOT_Y
                clc
                adc #$08
                sta ROCKET_Y+2

                lda #$3F
                sta SND2_VAL
_XIT            .endblock

; - - - - - - - - - - - - - - - - - - -
R_B             .block
                lda R_X
                ldx #$D7
                cmp #$D8
                beq _1

                ldx #$31
                cmp #$30
                bne _5

_1              lda FRAME
                and #$03
                bne _4

                lda ROBOT_ANGLE
                cmp #$04
                bcc _2

                cmp #$0E
                bcc _4

_2              cmp #$08
                bcs _3

                inc ROBOT_ANGLE
                inc ROBOT_ANGLE

                bra _4

_3              dec ROBOT_ANGLE
                dec ROBOT_ANGLE

_4              lda ROBOT_STATUS
                cmp #kOFF
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

; - - - - - - - - - - - - - - - - - - -
R_END           .block
                lda ROBOT_ANGLE
                bpl _1

                lda #$00
                sta ROBOT_ANGLE

_1              cmp #$12
                bcc _2

                lda #$10
                sta ROBOT_ANGLE

_2              lda ROBOT_ANGLE
                ora TEMP4_I
                sta ROBOT_ANGLE

                lda R_FX
                and #$03
                sta R_FX
                lda R_FY
                and #$07
                sta R_FY

                rts
                .endblock
                .endproc


;======================================
;
;======================================
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
                and #$03
                bne _XIT

                dec ROBOT_ANGLE
                dec ROBOT_ANGLE

_XIT            rts
                .endproc


;======================================
;
;======================================
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
                cmp #$04
                bne _1

                inc R_X

_1              lda FRAME
                and #$03
                bne _XIT

                inc ROBOT_ANGLE
                inc ROBOT_ANGLE

_XIT            rts
                .endproc


;======================================
;
;======================================
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
                cmp #$08
                bne _XIT

                inc R_Y

_XIT            rts
                .endproc


;======================================
;
;======================================
RobotUp         .proc
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                lda R_X
                sta TEMP1_I

                lda R_Y
                cmp #$03
                bcc _1

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


;======================================
;
;======================================
P1              .proc
                ldx #kOFF
                jmp DoRobotChopper.DRCE

                .endproc


;======================================
;
;======================================
DoRobotChopper  .proc
;v_???          .var TEMP1_I
;---

                lda R_STATUS
                cmp #kOFF
                beq P1

                lda R_X
                cmp SX
                bcc P1

                sec
                sbc SX
                cmp #$30
                bcs P1

                ldy SY
                bpl _1

                ldy #$00
_1              sty TEMP1_I

                lda R_Y
                cmp TEMP1_I
                bcc P1

                sec
                sbc SY
                cmp #$13
                bcs P1

                lda R_X
                sec
                sbc SX
                asl
                asl
                clc
                adc #$16
                sta TEMP1_I

                lda SX_F
                and #$03
                clc
                adc TEMP1_I
                adc R_FX
                sta ROBOT_X

                lda R_Y
                ldy SY
                bpl _2

                ldy #$00
_2              sty TEMP1_I

                sec
                sbc TEMP1_I
                asl
                asl
                asl
                clc
                adc #$47+12
                sta TEMP1_I

                lda SY_F
                eor #$FF
                and #$07
                clc
                adc TEMP1_I

                ldy SY
                bpl _3

                clc
                adc #$08

_3              clc
                adc R_FY
                sta ROBOT_Y

                ldx #kFLY
                lda ROBOT_COL
                beq _4

                lda R_STATUS
                cmp #kCRASH
                beq _4

                ldx #kCRASH
                lda #$14
                sta TIM7_VAL

                lda #$01
                sta SND3_VAL

_4              lda R_STATUS
                cmp #kCRASH
                beq _5

                stx R_STATUS

_5              ldx #kON
DRCE            stx ROBOT_STATUS

                rts
                .endproc


;======================================
;
;======================================
UpdateRobotChopper .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                lda ROBOT_STATUS
                cmp #kOFF
                bne _1

                lda #$00
                sta ROBOT_X
                sta ROBOT_Y

_1              ldy OROBOT_Y
                ldx #$11
                lda #$00
_next1          sta PLAYER+PL2,Y
                sta PLAYER+PL3,Y

                iny
                dex
                bpl _next1

                lda ROBOT_ANGLE
                asl
                tax

                lda CHOPPER_SHAPES,X
                sta ADR1_I
                lda CHOPPER_SHAPES+1,X
                sta ADR1_I+1

                lda #$00
                sta TEMP1_I
                lda #$12
                sta TEMP2_I

                ldx ROBOT_Y
                stx OROBOT_Y

_next2          ldy TEMP1_I
                lda (ADR1_I),Y
                sta PLAYER+PL2,X

                ldy TEMP2_I
                lda (ADR1_I),Y
                sta PLAYER+PL3,X

                inc TEMP1_I
                inc TEMP2_I
                inx

                lda TEMP1_I
                cmp #$12
                bne _next2

                lda R_STATUS
                cmp #kCRASH
                bne _2

                ldx ROBOT_Y
                ldy #$12
_next3          lda PLAYER+PL2,X
                and frsRandomREG
                sta PLAYER+PL2,X

                lda PLAYER+PL3,X
                and frsRandomREG
                sta PLAYER+PL3,X

                inx
                dey
                bne _next3

                ;!! inc PCOLR2
                ;!! inc PCOLR3

                dec TIM7_VAL
                bne _2

                lda #kOFF
                sta R_STATUS

                jsr PositionRobot

                lda #$FF
                sta TIM7_VAL

_2              lda FRAME
                and #$03
                bne _XIT

                lda ROBOT_ANGLE
                eor #$01
                sta ROBOT_ANGLE

_XIT            rts
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

                ldy #$00
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
                and #$07
                tax

                ldy #$00
                lda (ADR1_I),Y
                eor POS_MASK1,X
                sta (ADR1_I),Y

                rts
                .endproc
