;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: FORT3.S
;---------------------------------------
; MAIN INTERUPT DRIVER
;       PART (I)
; UPDATE_CHOPPER
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
                jsr DrawMap
                jsr UPDATE_CHOPPER
                jsr UpdateRobotChopper
                jsr ReadTrigger
                jsr DO_EXP

                lda MODE
                cmp #GO_MODE
                bne _1

                jsr DoRobotChopper
                jsr UpdateRockets
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
                jsr ComputeMapAddrI
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
                bne _4
                lda CHOPPER_COL
                and #%00000010
                beq _9
                jsr SlavePickUp
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

;---------------------------------------
;---------------------------------------

HIT_LIST        .byte $40,$5B,$5C,$5D,$5E,$5F
                .byte $3B,$3C,$3D,$3E,$49,$4A

HIT_LIST_LEN    = *-HIT_LIST-1
                .byte $61,$00                   ; 'a ' atari-ascii
                .byte EXP
HIT_LIST2_LEN   = *-HIT_LIST-1

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
