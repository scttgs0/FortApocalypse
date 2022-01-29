;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: input.asm
;---------------------------------------
; ReadKeyboard
; ReadJoystick
; ReadTrigger
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
ReadKeyboard    .proc
                lda CONSOL
                cmp CONSOL_FLAG
                beq _4

                sta CONSOL_FLAG

                ldx #0
                stx TIM6_VAL
                cmp #6                  ; START
                bne _1

                lda #START_MODE
                sta MODE
                sta DEMO_STATUS
                bra _XIT

_1              ldx MODE
                cpx #OPTION_MODE
                bne _2

                jsr CHECK_OPTIONS
                bra _XIT

_2              cmp #3                  ; OPTION
                beq _3

                cmp #5                  ; SELECT
                bne _4

_3              lda #OPTION_MODE
                sta MODE
                sta DEMO_STATUS
                jsr SCREEN_OFF

                lda #0
                sta OPT_NUM
                jsr CHECK_OPTIONS
                bra _XIT

_4              lda SKSTAT
                and #%00000100
                bne _XIT

                lda KBCODE
                cmp #$21                ; SPACE
                bne _XIT

                lda MODE
                pha
                lda #PAUSE_MODE
                sta MODE
                jsr CLEAR_SOUNDS

_wait1          lda SKSTAT
                and #%00000100
                beq _wait1

_next1          lda SKSTAT
                and #%00000100
                bne _5

                lda KBCODE
                cmp #$21                ; SPACE
                beq _wait2

_5              lda CONSOL
                cmp #7
                bne _wait2

                lda TRIG0
                bne _next1

_wait2          lda SKSTAT
                and #%00000100
                beq _wait2

                pla
                sta MODE
_XIT            rts
                .endproc


;=======================================
; 
;=======================================
ReadJoystick    .proc
                lda CHOPPER_STATUS      ; skip joystick read when off
                cmp #OFF
                beq _XIT

                cmp #CRASH              ; skip joystick read when crashed
                bne _doStick

_XIT            rts

_doStick        lda CHOPPER_ANGLE
                and #1
                sta TEMP1_I

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
                blt _1

                ldx #0
_1              stx DEMO_COUNT

_2              ldx STICK
                cpx #$F
                bne _3

                jsr Hover
                lda #20
                sta S1_2_VAL

_3              lda FUEL_STATUS
                cmp #EMPTY
                bne _4

                lda #60
                sta S1_2_VAL
_4              txa
                and #RIGHT
                bne _7

                lda #17
                sta S1_2_VAL

                lda CHOPPER_ANGLE
                cmp #14
                bge _5

                lda FRAME
                and #1
                bne _6

_5              inc CHOPPER_X

_6              lda FRAME
                and #3
                bne _7

                inc CHOPPER_ANGLE
                inc CHOPPER_ANGLE
_7              txa
                and #LEFT
                bne _10

                lda #17
                sta S1_2_VAL

                lda CHOPPER_ANGLE
                cmp #4
                blt _8

                lda FRAME
                and #1
                bne _9

_8              dec CHOPPER_X

_9              lda FRAME
                and #3
                bne _10

                dec CHOPPER_ANGLE
                dec CHOPPER_ANGLE

_10             lda FUEL_STATUS
                cmp #EMPTY
                beq _11

                txa
                and #UP
                bne _11

                lda #13
                sta S1_2_VAL

                dec CHOPPER_Y
                jsr Hover

_11             txa
                and #DOWN
                bne _12

                lda #26
                sta S1_2_VAL

                lda CHOPPER_STATUS
                cmp #LAND
                beq _12

                cmp #PICKUP
                beq _12

                inc CHOPPER_Y
                jsr Hover

_12             lda CHOPPER_ANGLE
                bpl _13

                lda #0
                sta CHOPPER_ANGLE
_13             cmp #18
                blt _14

                lda #16
                sta CHOPPER_ANGLE
_14             lda CHOPPER_ANGLE
                ora TEMP1_I
                sta CHOPPER_ANGLE

                rts
                .endproc


;=======================================
; 
;=======================================
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
                blt _7

                cmp #6
                bge _6

                lda #3
                bne _7

_6              sec
                sbc #2
_7              cmp #6
                blt _8

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
                sta S2_VAL

                rts
                .endproc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
