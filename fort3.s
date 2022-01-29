;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT3.S
;---------------------------------------
; MAIN INTERUPT DRIVER
;       PART (I)
; UPDATE_CHOPPER
; UPDATE_ROCKETS
; DO_CHOPPER
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
VERTBLKD        sei
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

                jsr DO_NUMBERS
                jsr DRAW_MAP
                jsr UPDATE_CHOPPER
                jsr UpdateRobotChopper
                jsr ReadTrigger
                jsr DO_EXP

                lda MODE
                cmp #GO_MODE
                bne _1

                jsr DoRobotChopper
                jsr UPDATE_ROCKETS
                jsr DoLaser1
                jsr DoLaser2
                jsr DO_BLOCKS
                jsr DoElevator
                jsr DO_CHOPPER
                jsr RobotAI
                jsr ReadJoystick

_1
                plp
                cli
                jmp VVBLKD_RET


;=======================================
;
;=======================================
CHECK_CHR_I
                jsr COMPUTE_MAP_ADR_I
                ldy #0
                lda (ADR1_I),Y
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
_1              lda (ADR2_I),Y
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
DO_CHOPPER
                lda CHOPPER_STATUS
                cmp #OFF
                bne _2
_1              rts

_20             jmp _4

_2              cmp #CRASH
                beq _1
                cmp #LAND
                beq _3
                cmp #PICKUP
                beq _3
                lda FRAME
                and GRAV_SKL
                bne _3
                inc CHOPPER_Y

_3              lda CHOPPER_COL
                beq _12
                cmp #4
                beq _20                 ; LASER
                cmp #8
                bne _6                  ; HYPER

                lda LEVEL
                bne _20
                sta CHOPPER_COL
                lda #HYPERSPACE_MODE
                sta MODE
                lda #1
                sta S3_VAL
                sta S5_VAL
_12             ldx #FLY
                bne _5                  ; FORCED

_6              lda CHOP_X
                sta TEMP1_I
                lda CHOP_Y
                sta TEMP2_I
                jsr COMPUTE_MAP_ADR_I
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
                bne _4
                lda CHOPPER_COL
                and #%00000010
                beq _9
                jsr PICK_UP_SLAVE
                bcc _9
                ldx #PICKUP
                jmp _5
_9              lda TEMP3_I
                cmp #3
                beq _4
                dec CHOPPER_Y
                ldx FUEL_STATUS
                lda CHOP_Y
                cmp #10+4
                blt _8
                cpx #EMPTY
                beq _4
_8              cpx #REFUEL
                beq _7
                lda TEMP4_I
                bne _7
                jsr RestorePoint
_7              ldx #LAND
                bne _5                  ; FORCED
_4              lda #20
                sta TIM3_VAL
                lda #1
                sta S3_VAL
                ldx #CRASH
_5              stx CHOPPER_STATUS
                rts


;=======================================
;
;=======================================
UPDATE_CHOPPER
                lda CHOPPER_STATUS
                cmp #BEGIN
                beq _20
                cmp #OFF
                bne _0
                lda #0
                sta HPOSP0
                sta HPOSP1
                rts
_20             lda #FLY
                sta CHOPPER_STATUS
                jmp CCXY

_0              ldy OCHOPPER_Y
                ldx #17
                lda #0
_1              sta PLAYER+PL0,Y
                sta PLAYER+PL1,Y
                iny
                dex
                bpl _1

                lda CHOPPER_X
                sta HPOSP0
                clc
                adc #8
                sta HPOSP1

                lda CHOPPER_ANGLE
                asl
                tax
                lda CHOPPER_SHAPES,X
                sta ADR1_I
                lda CHOPPER_SHAPES+1,X
                sta ADR1_I+1

                lda #0
                sta TEMP1_I
                lda #18
                sta TEMP2_I

                ldx CHOPPER_Y
                stx OCHOPPER_Y
_2              ldy TEMP1_I
                lda (ADR1_I),Y
                sta PLAYER+PL0,X
                ldy TEMP2_I
                lda (ADR1_I),Y
                sta PLAYER+PL1,X
                inc TEMP1_I
                inc TEMP2_I
                inx
                lda TEMP1_I
                cmp #18
                bne _2

                lda CHOPPER_STATUS
                cmp #CRASH
                bne _11
                ldx CHOPPER_Y
                ldy #18
_10             lda PLAYER+PL0,X
                and RANDOM
                sta PLAYER+PL0,X
                lda PLAYER+PL1,X
                and RANDOM
                sta PLAYER+PL1,X
                inx
                dey
                bne _10
                inc PCOLR0
                inc PCOLR1
                lda RANDOM
                ora #$F
                sta BAK2_COLOR
                lda MODE
                cmp #GO_MODE
                bne _11
                lda FRAME
                and #1
                bne _12
                inc CHOPPER_Y
_12             dec TIM3_VAL
                bne _11
                lda R_STATUS
                cmp #OFF
                beq _23
                jsr PositionRobot
                lda #OFF
                sta R_STATUS
_23             jsr POS_CHOPPER

                lda #NEW_PLAYER_MODE
                sta MODE

_11
                lda FRAME
                and #3
                bne _3
                lda CHOPPER_ANGLE
                eor #1
                sta CHOPPER_ANGLE

_3
                lda MODE
                cmp #GO_MODE
                bne CCEND
                jsr POS_CHOPPER
CCXY
                lda CHOPPER_X
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
                bpl _1
                lda #0
_1              clc
                adc TEMP1_I
                sta CHOP_Y

                jmp POS_CHOPPER
CCEND           rts


;=======================================
;
;=======================================
UPDATE_ROCKETS

                ldx #2
NXT_RCK         lda ROCKET_STATUS,X
                bne _23
_9              jmp _6
_23             cmp #7
                beq _9
                lda ROCKET_X,X
                sec
                sbc #32+1
                lsr
                lsr
                clc
                adc SX
                sta TEMP1_I
                sta ROCKET_TEMPX,X
                lda #0
                ldy SY
                bmi _0
                lda SY_F
                and #7
_0              clc
                adc ROCKET_Y,X
                sec
                sbc #82+12
                lsr
                lsr
                lsr
                sta TEMP2_I
                lda SY
                bpl _1
                lda #0
_1              clc
                adc TEMP2_I
                sta TEMP2_I
                sta ROCKET_TEMPY,X
                jsr CHECK_CHR_I
                bcc _6
                ldy #1
                sty S3_VAL
                dey                     ; Y=0
                sty S2_VAL
                lda (ADR1_I),Y
                sta ROCKET_TEMP,X
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
                bne _3                  ; FORCED
_4              cmp #EXP_WALL
                bne _10
                stx TEMP1_I
                lda #$10
                sta BAK2_COLOR
                ldx #$20
                ldy #$00
                jsr INC_SCORE
                ldx TEMP1_I
                lda #0
                sta ROCKET_TEMP,X
                beq _21                 ; FORCED
_10             ldy #HIT_LIST_LEN
_2              cmp HIT_LIST,Y
                beq _3
                dey
                bpl _2
_21             lda #7
                bne _5                  ; FORCED
_3              lda #0
_5              sta ROCKET_STATUS,X
                ldy #0
                lda #EXP
                sta (ADR1_I),Y
                lda #7
                sta ROCKET_TIM,X
_6

MOVE_ROCKETS ;unused
                lda ROCKET_STATUS,X
                beq _2
                cmp #7                  ; EXP
                beq _3
                lda SSIZEM
                sta SIZEM
                lda ROCKET_X,X
                cmp #0+4
                blt _2
                cmp #255-4
                bge _2
                lda ROCKET_Y,X
                cmp #MAX_DOWN+18
                bge _2
                cmp #MAX_UP
                bge _5
_2              lda #0                  ; OFF
                sta ROCKET_STATUS,X
_3              lda #0
                sta ROCKET_X,X
                lda #$F0
                sta ROCKET_Y,X
_5              ldy OROCKET_Y,X
                lda PLAYER+MIS+0,Y
                and ROCKET1_MASK,X
                sta PLAYER+MIS+0,Y
                lda PLAYER+MIS+1,Y
                and ROCKET1_MASK,X
                sta PLAYER+MIS+1,Y
                lda PLAYER+MIS+4,Y
                and ROCKET1_MASK,X
                sta PLAYER+MIS+4,Y
                lda PLAYER+MIS+5,Y
                and ROCKET1_MASK,X
                sta PLAYER+MIS+5,Y
                lda ROCKET_Y,X
                sta OROCKET_Y,X
                tay
                lda ROCKET2_MASK,X
                pha
                ora PLAYER+MIS+0,Y
                sta PLAYER+MIS+0,Y
                pla
                ora PLAYER+MIS+1,Y
                sta PLAYER+MIS+1,Y
                lda SSIZEM
                and ROCKET1_MASK,X
                sta SSIZEM
                lda ROCKET_STATUS,X
                cmp #3
                beq _10
                lda SSIZEM
                ora ROCKET3_MASK,X
                sta SSIZEM
                lda ROCKET2_MASK,X
                pha
                ora PLAYER+MIS+4,Y
                sta PLAYER+MIS+4,Y
                pla
                ora PLAYER+MIS+5,Y
                sta PLAYER+MIS+5,Y
_10             ldy ROCKET_STATUS,X
                beq _4
                cpy #7                  ; EXP
                beq _4
                lda ROCKET_X,X
                clc
                adc ROCKET_DX-1,Y
                sta ROCKET_X,X
                lda ROCKET_Y,X
                clc
                adc ROCKET_DY-1,Y
                sta ROCKET_Y,X
_4              dex
                bmi ROCKET_EXP
                jmp NXT_RCK


;=======================================
;
;=======================================
ROCKET_EXP
                ldx #2
_1              lda ROCKET_STATUS,X
                cmp #7                  ; EXP
                bne _2
                dec ROCKET_TIM,X
                bne _2
                lda ROCKET_TEMPX,X
                sta TEMP1_I
                lda ROCKET_TEMPY,X
                sta TEMP2_I
                lda #0
                sta BAK2_COLOR
                jsr COMPUTE_MAP_ADR_I
                lda ROCKET_TEMP,X
                cmp #EXP
                beq _4
                ldy #HIT_LIST_LEN
_0              cmp HIT_LIST,Y
                beq _4
                dey
                bpl _0
                iny                             ; Y=0
                sta (ADR1_I),Y
_4              lda #0                          ; OFF
                sta ROCKET_STATUS,X
_2              dex
                bpl _1
_3              rts

;---------------------------------------
;---------------------------------------

HIT_LIST        .byte $40,$5B,$5C,$5D,$5E,$5F
                .byte $3B,$3C,$3D,$3E,$49,$4A

HIT_LIST_LEN    = *-HIT_LIST-1
                .byte $61,$00                   ; 'a ' atari-ascii
                .byte EXP
HIT_LIST2_LEN   = *-HIT_LIST-1

ROCKET_DX
                .char -4,-4,0,4,4
ROCKET_DY
                .byte 2,0,2,0,2

ROCKET1_MASK
                .byte %11111100
                .byte %11110011
                .byte %11001111
;               .byte %00111111
ROCKET2_MASK
                .byte %00000011
                .byte %00001100
                .byte %00110000
;               .byte %11000000
ROCKET3_MASK
                .byte %00000001
                .byte %00000100
                .byte %00010000
;               .byte %01000000

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
