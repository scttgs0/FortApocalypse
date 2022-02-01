;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT3.S
;---------------------------------------
; MAIN INTERUPT DRIVER
;       PART (I)
; UpdateChopper
; UpdateRobotChopper
; UpdateRockets
; DO.ROBOT CHOPPER
; DoChopper
; RobotAI
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
VERTBLKD        .proc
                sei
                php
                cld
                lda #0
                sta ATTRACT
                lda M2PL
                ora M3PL
                and #%00000011
                ora P0PL
                ora P1PL
                asl
                asl
                asl
                asl
                ora P0PF
                ora P1PF
                sta CHOPPER_COL
                lda M0PL
                ora M1PL
                and #%00001100
                ora P2PL
                ora P2PF
                ora P3PL
                ora P3PF
                sta ROBOT_COL
                sta HITCLR

                jsr DoNumbers
                jsr DrawMap
                jsr UpdateChopper
                jsr UpdateRobotChopper
                jsr ReadTrigger
                jsr DoExplode

                lda MODE
                cmp #GO_MODE
                bne _1

                jsr DoRobotChopper
                jsr UpdateRockets
                jsr DoLaser1
                jsr DoLaser2
                jsr DoBlocks
                jsr DoElevator
                jsr DoChopper
                jsr RobotAI
                jsr ReadJoystick

_1              plp
                cli
                jmp VVBLKD_RET

                .endproc


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
                sta PCOLR2
                sta PCOLR3
                lda #8
                sta ROBOT_ANGLE
                lda RANDOM
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

;---------------------------------------
;---------------------------------------

;                     00  01  02  03  04  05  06  07
ROB_X           .byte $84,$C3,$49,$C3,$49,$84,$84,$84
                .byte $D7,$D7,$D7,$D6,$D6,$D6,$33,$33
ROB_Y           .byte $00,$16,$16,$21,$21,$00,$00,$00
                .byte $12,$12,$12,$06,$06,$06,$06,$06


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
                bne _2                  ; FORCED

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
                bne _4                  ; FORCED

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
; at exit:
;   C           completion status
;=======================================
CheckChrI       .proc
;v_???          .var ADR1_I
;v_???          .var ADR2_I
;---

                jsr ComputeMapAddrI

                ldy #0
                lda (ADR1_I),y
                and #$7F
                ldy #0
                sty ADR2_I+1
                asl
                rol ADR2_I+1
                asl
                rol ADR2_I+1
                asl
                rol ADR2_I+1

                clc
                adc #<CHR_SET2
                sta ADR2_I
                lda #>CHR_SET2
                adc ADR2_I+1
                sta ADR2_I+1

                ldy #7
_next1          lda (ADR2_I),y
                bne _XIT
                dey
                bpl _next1

                clc
                rts

_XIT            sec
                rts
                .endproc


;=======================================
;
;=======================================
DoChopper       .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;v_???          .var TEMP3_I
;v_???          .var TEMP4_I
;---

                lda CHOPPER_STATUS
                cmp #OFF
                bne _1

_XIT            rts

_leap           jmp _8

_1              cmp #CRASH
                beq _XIT

                cmp #LAND
                beq _2

                cmp #PICKUP
                beq _2

                lda FRAME
                and GRAV_SKL
                bne _2

                inc CHOPPER_Y
_2              lda CHOPPER_COL
                beq _3

                cmp #4
                beq _leap               ; LASER

                cmp #8
                bne _4                  ; HYPER

                lda LEVEL
                bne _leap

                sta CHOPPER_COL
                lda #HYPERSPACE_MODE
                sta MODE

                lda #1
                sta SND3_VAL
                sta SND5_VAL
_3              ldx #FLY
                bne _9                  ; FORCED

_4              lda CHOP_X
                sta TEMP1_I
                lda CHOP_Y
                sta TEMP2_I
                jsr ComputeMapAddrI

                lda #0
                sta TEMP3_I
                sta TEMP4_I
                jsr CheckLanding

                inc ADR1_I+1
                jsr CheckLanding

                inc ADR1_I+1
                jsr CheckLanding

                lda CHOPPER_COL
                and #%11110000
                bne _8

                lda CHOPPER_COL
                and #%00000010
                beq _5

                jsr SlavePickUp
                bcc _5

                ldx #PICKUP
                jmp _9

_5              lda TEMP3_I
                cmp #3
                beq _8

                dec CHOPPER_Y
                ldx FUEL_STATUS
                lda CHOP_Y
                cmp #10+4
                blt _6

                cpx #EMPTY
                beq _8

_6              cpx #kREFUEL
                beq _7

                lda TEMP4_I
                bne _7

                jsr RestorePoint

_7              ldx #LAND
                bne _9                  ; FORCED

_8              lda #20
                sta TIM3_VAL
                lda #1
                sta SND3_VAL
                ldx #CRASH
_9              stx CHOPPER_STATUS
                rts
                .endproc


RestorePoint    .proc
                lda SX_F
                sta LAND_FX
                lda SY_F
                sta LAND_FY
                lda SX
                sta LAND_X
                lda SY
                sta LAND_Y
                lda CHOPPER_X
                sta LAND_CHOP_X
                lda CHOPPER_Y
                sta LAND_CHOP_Y
                lda CHOPPER_ANGLE
                sta LAND_CHOP_ANGLE
                rts
                .endproc


;=======================================
;
;=======================================
CheckLanding    .proc
;v_???          .var ADR1_I
;v_???          .var TEMP3_I
;v_???          .var TEMP4_I
;---

                ldy #0
                ldx #LAND_LEN
                lda (ADR1_I),y
_next1          cmp LAND_CHR,x
                beq _XIT

                cmp #$48
                beq _1

                dex
                bpl _next1

                inc TEMP3_I
_XIT            rts

_1              inc TEMP4_I
                rts
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
UpdateChopper   .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                lda CHOPPER_STATUS
                cmp #BEGIN
                beq _1

                cmp #OFF
                bne _2

                lda #0
                sta HPOSP0
                sta HPOSP1
                rts

_1              lda #FLY
                sta CHOPPER_STATUS
                jmp _CCXY

_2              ldy OCHOPPER_Y
                ldx #17
                lda #0
_next1          sta PLAYER+PL0,y
                sta PLAYER+PL1,y
                iny
                dex
                bpl _next1

                lda CHOPPER_X
                sta HPOSP0
                clc
                adc #8
                sta HPOSP1

                lda CHOPPER_ANGLE
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

                ldx CHOPPER_Y
                stx OCHOPPER_Y

_next2          ldy TEMP1_I
                lda (ADR1_I),y
                sta PLAYER+PL0,x
                ldy TEMP2_I
                lda (ADR1_I),y
                sta PLAYER+PL1,x

                inc TEMP1_I
                inc TEMP2_I
                inx

                lda TEMP1_I
                cmp #18
                bne _next2

                lda CHOPPER_STATUS
                cmp #CRASH
                bne _5

                ldx CHOPPER_Y
                ldy #18
_next3          lda PLAYER+PL0,x
                and RANDOM
                sta PLAYER+PL0,x
                lda PLAYER+PL1,x
                and RANDOM
                sta PLAYER+PL1,x
                inx
                dey
                bne _next3

                inc PCOLR0
                inc PCOLR1
                lda RANDOM
                ora #$F
                sta BAK2_COLOR
                lda MODE
                cmp #GO_MODE
                bne _5

                lda FRAME
                and #1
                bne _3

                inc CHOPPER_Y
_3              dec TIM3_VAL
                bne _5

                lda R_STATUS
                cmp #OFF
                beq _4

                jsr PositionRobot

                lda #OFF
                sta R_STATUS
_4              jsr PositionChopper

                lda #NEW_PLAYER_MODE
                sta MODE

_5              lda FRAME
                and #3
                bne _6

                lda CHOPPER_ANGLE
                eor #1
                sta CHOPPER_ANGLE

_6              lda MODE
                cmp #GO_MODE
                bne _XIT

                jsr PositionChopper

_CCXY           lda CHOPPER_X
                sec
                sbc #24
                lsr
                lsr
                clc
                adc SX
                sta CHOP_X
                lda CHOPPER_Y
                sec
                sbc #76+12
                lsr
                lsr
                lsr
                sta TEMP1_I
                lda SY
                bpl _7

                lda #0
_7              clc
                adc TEMP1_I
                sta CHOP_Y
                jmp PositionChopper

_XIT            rts
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
                and RANDOM
                sta PLAYER+PL2,x
                lda PLAYER+PL3,x
                and RANDOM
                sta PLAYER+PL3,x
                inx
                dey
                bne _next3

                inc PCOLR2
                inc PCOLR3
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
UpdateRockets   .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                ldx #2


NXT_RCK         .block
                lda ROCKET_STATUS,x
                bne _1

_next1          jmp _XIT

_1              cmp #7
                beq _next1

                lda ROCKET_X,x
                sec
                sbc #32+1
                lsr
                lsr
                clc
                adc SX
                sta TEMP1_I
                sta ROCKET_TEMPX,x
                lda #0
                ldy SY
                bmi _2

                lda SY_F
                and #7
_2              clc
                adc ROCKET_Y,x
                sec
                sbc #82+12
                lsr
                lsr
                lsr
                sta TEMP2_I
                lda SY
                bpl _3

                lda #0
_3              clc
                adc TEMP2_I
                sta TEMP2_I
                sta ROCKET_TEMPY,x
                jsr CheckChrI
                bcc _XIT

                ldy #1
                sty SND3_VAL
                dey                     ; Y=0
                sty SND2_VAL
                lda (ADR1_I),y
                sta ROCKET_TEMP,x
                cmp #EXP2
                bne _4

                ldy LEVEL
                dey
                bne _4

                sty ROCKET_TEMP+0
                sty ROCKET_TEMP+1
                sty ROCKET_TEMP+2
                lda #EXPLODE
                sta FORT_STATUS
                bne _7                  ; FORCED

_4              cmp #EXP_WALL
                bne _5

                stx TEMP1_I
                lda #$10
                sta BAK2_COLOR
                ldx #$20
                ldy #$00
                jsr IncreaseScore
                ldx TEMP1_I
                lda #0
                sta ROCKET_TEMP,x
                beq _6                  ; FORCED

_5              ldy #HIT_LIST_LEN
_next2          cmp HIT_LIST,y
                beq _7

                dey
                bpl _next2

_6              lda #7
                bne _8                  ; FORCED

_7              lda #0
_8              sta ROCKET_STATUS,x
                ldy #0
                lda #EXP
                sta (ADR1_I),y
                lda #7
                sta ROCKET_TIM,x
_XIT            .endblock


MOVE_ROCKETS    .block
                lda ROCKET_STATUS,x
                beq _1

                cmp #7                  ; EXP
                beq _2

                lda SSIZEM
                sta SIZEM
                lda ROCKET_X,x
                cmp #0+4
                blt _1

                cmp #255-4
                bge _1

                lda ROCKET_Y,x
                cmp #MAX_DOWN+18
                bge _1

                cmp #MAX_UP
                bge _3

_1              lda #0                  ; OFF
                sta ROCKET_STATUS,x
_2              lda #0
                sta ROCKET_X,x
                lda #$F0
                sta ROCKET_Y,x
_3              ldy OROCKET_Y,x
                lda PLAYER+MIS+0,y
                and ROCKET1_MASK,x
                sta PLAYER+MIS+0,y
                lda PLAYER+MIS+1,y
                and ROCKET1_MASK,x
                sta PLAYER+MIS+1,y
                lda PLAYER+MIS+4,y
                and ROCKET1_MASK,x
                sta PLAYER+MIS+4,y
                lda PLAYER+MIS+5,y
                and ROCKET1_MASK,x
                sta PLAYER+MIS+5,y
                lda ROCKET_Y,x
                sta OROCKET_Y,x
                tay
                lda ROCKET2_MASK,x
                pha
                ora PLAYER+MIS+0,y
                sta PLAYER+MIS+0,y
                pla
                ora PLAYER+MIS+1,y
                sta PLAYER+MIS+1,y
                lda SSIZEM
                and ROCKET1_MASK,x
                sta SSIZEM
                lda ROCKET_STATUS,x
                cmp #3
                beq _4

                lda SSIZEM
                ora ROCKET3_MASK,x
                sta SSIZEM
                lda ROCKET2_MASK,x
                pha
                ora PLAYER+MIS+4,y
                sta PLAYER+MIS+4,y
                pla
                ora PLAYER+MIS+5,y
                sta PLAYER+MIS+5,y
_4              ldy ROCKET_STATUS,x
                beq _5

                cpy #7                  ; EXP
                beq _5

                lda ROCKET_X,x
                clc
                adc ROCKET_DX-1,y
                sta ROCKET_X,x
                lda ROCKET_Y,x
                clc
                adc ROCKET_DY-1,y
                sta ROCKET_Y,x
_5              dex
                bmi RocketExplode

                jmp NXT_RCK

                .endblock
                .endproc


;=======================================
;
;=======================================
RocketExplode   .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                ldx #2
_next1          lda ROCKET_STATUS,x
                cmp #7                  ; EXP
                bne _2

                dec ROCKET_TIM,x
                bne _2

                lda ROCKET_TEMPX,x
                sta TEMP1_I
                lda ROCKET_TEMPY,x
                sta TEMP2_I
                lda #0
                sta BAK2_COLOR
                jsr ComputeMapAddrI

                lda ROCKET_TEMP,x
                cmp #EXP
                beq _1

                ldy #HIT_LIST_LEN
_next2          cmp HIT_LIST,y
                beq _1

                dey
                bpl _next2
                iny                     ; Y=0
                sta (ADR1_I),y
_1              lda #0                  ; OFF
                sta ROCKET_STATUS,x
_2              dex
                bpl _next1

                rts
                .endproc

;---------------------------------------
;---------------------------------------

HIT_LIST        .byte $40,$5B,$5C,$5D,$5E,$5F
                .byte $3B,$3C,$3D,$3E,$49,$4A

TANK_SHAPE      .byte $EC,$ED,$EE,$EF,$F0       ; 'lmnop' atari-ascii
                .byte MISS_LEFT,MISS_RIGHT

HIT_LIST_LEN    = *-HIT_LIST-1
                .byte $61,$00                   ; 'a ' atari-ascii
                .byte EXP
HIT_LIST2_LEN   = *-HIT_LIST-1

ROCKET_DX       .char -4,-4,0,4,4
ROCKET_DY       .byte 2,0,2,0,2

ROCKET1_MASK    .byte %11111100
                .byte %11110011
                .byte %11001111
;               .byte %00111111
ROCKET2_MASK    .byte %00000011
                .byte %00001100
                .byte %00110000
;               .byte %11000000
ROCKET3_MASK    .byte %00000001
                .byte %00000100
                .byte %00010000
;               .byte %01000000

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
