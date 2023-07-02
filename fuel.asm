
; SPDX-FileName: fuel.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;======================================
;
;======================================
CheckFuelBase   .proc
v_posX          .var TEMP1
v_posY          .var TEMP2
;---

                lda FUEL_STATUS
                cmp #kREFUEL
                bne _1

                jmp Refuel

_1              lda CHOPPER_STATUS
                cmp #kLAND
                bne _4

                lda CHOP_Y
                cmp #7+2
                blt _4

                cmp #11+2
                bge _4

                ldx CHOP_X
                lda LEVEL
                bne _2

                cpx #$15+2
                blt _4

                cpx #$EC+2+6
                bge _4

                jmp _3

_2              cpx #$82
                blt _4

                cpx #$82+6
                bge _4

_3              lda #kREFUEL
                sta FUEL_STATUS

                ;-----------------------
                ; Copy Protection
                ;-----------------------
                ; asl ComputeMapAddr
                ;-----------------------

                lda #1
                sta TIM4_VAL
                lda #4
                sta FUEL_TEMP
_4              lda #0
                ldx FUEL_STATUS
                cpx #kREFUEL
                beq _6

                lda FUEL2
                bne _XIT

                lda FRAME
                and #%00001000
                bne _5

                lda #9
                sta v_posX
                lda #0
                sta v_posY

                lda #$A4
                sta SID1_CTRL2
                sta SID1_FREQ2

                ldx #<txtLowOnFuel
                ldy #>txtLowOnFuel
                jsr Print

                jmp _XIT

_5              lda #$A4
_6              sta SID1_CTRL2
                lda #$88
                sta SID1_FREQ2
                jsr ClearInfo

_XIT            rts
                .endproc


;======================================
;
;======================================
Refuel          .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;v_???          .var TEMP3
;---

                dec TIM4_VAL
                bne FE

                lda #1
                sta TIM4_VAL
                lda FUEL_TEMP
                bmi F1

DF1             lda #9+2
                sta TEMP2
                lda FUEL_TEMP
                sta TEMP3
                ldx LEVEL
                dex                     ; X=1?
                beq _1

                lda #$15+2
                sta TEMP1
                jsr DrawBase

                lda #$EC+2
                bra _2

_1              lda #$82
_2              sta TEMP1
                jsr DrawBase

                dec FUEL_TEMP
FE              rts

F1              ldx #1
                lda CHOP_Y
                cmp #11+2
                bge _1

                ldx #0
                ;--.setbank $AF
                stx SID1_CTRL2
                ;--.setbank $03
_1              stx SND4_VAL
                lda CHOP_Y
                cmp #8+2
                bge FE

                lda #kFULL
                sta FUEL_STATUS
                lda #4
                sta FUEL_TEMP
                jsr DF1

                jmp RestorePoint

                .endproc


;======================================
;
;======================================
DrawBase        .proc
;v_???          .var ADR1
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                jsr ComputeMapAddr

                lda #4
                sta TEMP4

                lda TEMP3               ; x6
                asl
                clc
                adc TEMP3
                asl

                tax
_next1          ldy #0
_next2          lda BASE_SHAPE,X
                sta (ADR1),Y
                inx
                iny
                cpy #6
                bne _next2

                inc ADR1+1
                dec TEMP4
                bpl _next1

                rts
                .endproc
