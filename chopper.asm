
; SPDX-FileName: chopper.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;======================================
; at exit:
;   C           completion status
;======================================
CheckChrI       .proc
;v_???          .var ADR1_I
;v_???          .var ADR2_I
;---

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
_next1          lda (ADR2_I),Y
                bne _XIT

                dey
                bpl _next1

                clc
                rts

_XIT            sec
                rts
                .endproc


;======================================
;
;======================================
DoChopper       .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;v_???          .var TEMP3_I
;v_???          .var TEMP4_I
;---

                lda CHOPPER_STATUS
                cmp #kOFF
                bne _1

_XIT            rts

_leap           jmp _8

_1              cmp #kCRASH
                beq _XIT

                cmp #kLAND
                beq _2

                cmp #kPICKUP
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
_3              ldx #kFLY
                bra _9

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

                ldx #kPICKUP
                jmp _9

_5              lda TEMP3_I
                cmp #3
                beq _8

                dec CHOPPER_Y
                ldx FUEL_STATUS
                lda CHOP_Y
                cmp #10+4
                blt _6

                cpx #kEMPTY
                beq _8

_6              cpx #kREFUEL
                beq _7

                lda TEMP4_I
                bne _7

                jsr RestorePoint

_7              ldx #kLAND
                bra _9

_8              lda #20
                sta TIM3_VAL
                lda #1
                sta SND3_VAL
                ldx #kCRASH
_9              stx CHOPPER_STATUS
                rts
                .endproc


;======================================
;
;======================================
UpdateChopper   .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                lda CHOPPER_STATUS
                cmp #kBEGIN
                beq _1

                cmp #kOFF
                bne _2

                lda #0
                sta SPR(sprite_t.X, 0)
                sta SPR(sprite_t.X, 1)
                rts

_1              lda #kFLY
                sta CHOPPER_STATUS
                jmp _CCXY

_2              ldy OCHOPPER_Y
                ldx #17
                lda #0
_next1          sta PLAYER+PL0,Y
                sta PLAYER+PL1,Y
                iny
                dex
                bpl _next1

                lda CHOPPER_X
                sta SPR(sprite_t.X, 0)
                clc
                adc #8
                sta SPR(sprite_t.X, 1)

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

_next2          ldy TEMP1_I
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
                bne _next2

                lda CHOPPER_STATUS
                cmp #kCRASH
                bne _5

                ldx CHOPPER_Y
                ldy #18
_next3          lda PLAYER+PL0,X
                and frsRandomREG
                sta PLAYER+PL0,X
                lda PLAYER+PL1,X
                and frsRandomREG
                sta PLAYER+PL1,X
                inx
                dey
                bne _next3

                ;!! inc PCOLR0
                ;!! inc PCOLR1
                .frsRandomByte
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
                cmp #kOFF
                beq _4

                jsr PositionRobot

                lda #kOFF
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
Hover           .proc
                lda FRAME
                and #7
                bne _XIT

                lda CHOPPER_ANGLE
                cmp #4
                blt _1

                cmp #14
                blt _XIT

_1              cmp #8
                bge _2

                inc CHOPPER_ANGLE
                inc CHOPPER_ANGLE
                rts

_2              dec CHOPPER_ANGLE
                dec CHOPPER_ANGLE
_XIT            rts
                .endproc
