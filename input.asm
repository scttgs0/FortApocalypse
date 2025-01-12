
; SPDX-FileName: input.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;======================================
; Space = toggle Pause Mode
; Option (F2) = delegate to Opt handler
; Select (F3) = delegate to Opt handler
; Start  (F4) = switch to Start Mode
;--------------------------------------
; Any activity will cancel the Demo
; All key-presses are delegated to the
;   Option screen while in Option mode
; Capture (endless loop) while Paused
;======================================
ReadKeyboard    .proc
v_demoTimer     .var TIM6_VAL
;---

                ;!! lda CONSOL              ; read the console keys
                cmp CONSOL_FLAG         ; update consol_flag if it has changed
                beq _doSelect

                sta CONSOL_FLAG

                ldx #$00                ; reset inactivity timer
                stx v_demoTimer

                cmp #$06                ; START pressed? (0=pressed)
                bne _chk_mode

                lda #START_MODE         ; MODE=START
                sta MODE
                sta DEMO_STATUS         ; disable Demo

                bra _XIT

_chk_mode       ldx MODE                ; Options Screen has its own handler
                cpx #OPTION_MODE        ; continue if not on the Options screen
                bne _determine_key

                jsr CheckOptions        ; transfer to the Option handler
                bra _XIT

_determine_key  cmp #$03                ; OPTION pressed?
                beq _doOption

                cmp #$05                ; SELECT pressed?
                bne _doSelect

_doOption       lda #OPTION_MODE        ; switch to Options screen
                sta MODE
                sta DEMO_STATUS         ; disable Demo

                jsr ScreenOff           ; update display

                stz OPT_NUM
                jsr CheckOptions        ; transfer to the Option handler
                bra _XIT

_doSelect       ;!! lda SKSTAT              ; is the key still pressed?
                and #%00000100
                bne _XIT                ; still pressed then exit

                ;!! lda KBCODE              ; was it the spacebar?
                cmp #$21
                bne _XIT                ; ignore other keys... exit

                lda MODE                ; enter Pause mode
                pha

                lda #PAUSE_MODE         ; MODE=PAUSE
                sta MODE

                jsr ClearSounds         ; stop sounds

_wait1          ;!! lda SKSTAT              ; capture...
                and #%00000100
                beq _wait1              ; don't leave until we exist Pause mode

_next1          ;!! lda SKSTAT              ; is the key still pressed?
                and #%00000100
                bne _debounce

                ;!! lda KBCODE              ; was it the spacebar?
                cmp #$21
                beq _wait2              ; exit once the key is released

_debounce       ;!! lda CONSOL              ; debounce... ensure all three console keys are released
                cmp #$07
                bne _wait2

                ;!! lda TRIG0               ; exit after debounce if trigger is pressed
                bne _next1

_wait2          ;!! lda SKSTAT              ; debounce... wait for release
                and #%00000100
                beq _wait2

                pla
                sta MODE

_XIT            rts
                .endproc


;======================================
;
;======================================
ReadJoystick    .proc
v_angleBit0     .var TEMP1_I
;---

                lda CHOPPER_STATUS      ; skip joystick read when Off
                cmp #kOFF
                beq _XIT

                cmp #kCRASH              ; skip joystick read when Crashed
                bne _doStick

_XIT            rts

_doStick        lda CHOPPER_ANGLE
                and #$01
                sta v_angleBit0

                lda CHOPPER_ANGLE
                and #$FE
                sta CHOPPER_ANGLE

                lda DEMO_STATUS
                bne _2

                ldx DEMO_COUNT
                lda DEMO_STICK,X
                sta JOYSTICK0

                lda FRAME
                and #$0F
                bne _2

                inx
                cpx #$6C
                bcc _1

                ldx #$00
_1              stx DEMO_COUNT

_2              lda JOYSTICK0
                and #$1F
                tax
                cpx #$00
                bne _3

                jsr Hover

                lda #$14
                sta SND1_2_VAL

_3              lda FUEL_STATUS
                cmp #kEMPTY
                bne _chk_right

                lda #$3C
                sta SND1_2_VAL

_chk_right      txa
                and #kRIGHT
                beq _chk_left

                lda #$11
                sta SND1_2_VAL

                lda CHOPPER_ANGLE
                cmp #$0E
                bcs _4

                lda FRAME
                and #$01
                bne _5

_4              inc CHOPPER_X

_5              lda FRAME
                and #$03
                bne _chk_left

                inc CHOPPER_ANGLE
                inc CHOPPER_ANGLE

_chk_left       txa
                and #kLEFT
                beq _chk_up

                lda #$11
                sta SND1_2_VAL

                lda CHOPPER_ANGLE
                cmp #$04
                bcc _6

                lda FRAME
                and #$01
                bne _7

_6              dec CHOPPER_X

_7              lda FRAME
                and #$03
                bne _chk_up

                dec CHOPPER_ANGLE
                dec CHOPPER_ANGLE

_chk_up         lda FUEL_STATUS
                cmp #kEMPTY
                beq _chk_down

                txa
                and #kUP
                bne _chk_down

                lda #$0D
                sta SND1_2_VAL

                dec CHOPPER_Y

                jsr Hover

_chk_down       txa
                and #kDOWN
                beq _8

                lda #$1A
                sta SND1_2_VAL

                lda CHOPPER_STATUS
                cmp #kLAND
                beq _8

                cmp #kPICKUP
                beq _8

                inc CHOPPER_Y

                jsr Hover

_8              lda CHOPPER_ANGLE
                bpl _9

                lda #$00
                sta CHOPPER_ANGLE

_9              cmp #$12
                bcc _10

                lda #$10
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
                cmp #kCRASH
                beq _XIT

                lda DEMO_STATUS
                bne _1

                lda FRAME
                and #$0F
                beq _4

                rts

_1              ;!! ldx TRIG0
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

                ldx #$01
_next1          lda ROCKET_STATUS,X
                beq _5

                dex
                bpl _next1

_XIT            rts

_5              lda CHOPPER_ANGLE
                and #%00011110
                lsr
                cmp #$04
                bcc _7

                cmp #$06
                bcs _6

                lda #$03
                bne _7

_6              sec
                sbc #$02
_7              cmp #$06
                bcc _8

                lda #$05
_8              cmp #$00
                bne _9

                lda #$01
_9              sta ROCKET_STATUS,X

                lda CHOPPER_X
                and #$03
                clc
                adc CHOPPER_X
                adc #$08
                sta ROCKET_X,X

                lda CHOPPER_Y
                clc
                adc #$08
                sta ROCKET_Y,X

                lda #$3F
                sta SND2_VAL

                rts
                .endproc
