
; SPDX-FileName: rocket.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;======================================
;
;======================================
UpdateRockets   .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                ldx #2


NXT_RCK         .block
                lda ROCKET_STATUS,X
                bne _1

_next1          jmp _XIT

_1              cmp #7
                beq _next1

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
                bmi _2

                lda SY_F
                and #7
_2              clc
                adc ROCKET_Y,X
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
                sta ROCKET_TEMPY,X
                jsr CheckChrI
                bcc _XIT

                ldy #1
                sty SND3_VAL
                dey                     ; Y=0
                sty SND2_VAL
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
                lda #kEXPLODE
                sta FORT_STATUS
                bra _7

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
                sta ROCKET_TEMP,X
                bra _6

_5              ldy #HIT_LIST_LEN
_next2          cmp HIT_LIST,Y
                beq _7

                dey
                bpl _next2

_6              lda #7
                bra _8

_7              lda #0
_8              sta ROCKET_STATUS,X
                ldy #0
                lda #EXP
                sta (ADR1_I),Y
                lda #7
                sta ROCKET_TIM,X
_XIT            .endblock


MOVE_ROCKETS    .block
                lda ROCKET_STATUS,X
                beq _1

                cmp #STOP_MODE
                beq _2

                lda SSIZEM
                ;!! sta SIZEM
                lda ROCKET_X,X
                cmp #0+4
                blt _1

                cmp #255-4
                bge _1

                lda ROCKET_Y,X
                cmp #MAX_DOWN+18
                bge _1

                cmp #MAX_UP
                bge _3

_1              lda #0                  ; OFF
                sta ROCKET_STATUS,X
_2              lda #0
                sta ROCKET_X,X
                lda #$F0
                sta ROCKET_Y,X
_3              ldy OROCKET_Y,X
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
                beq _4

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
_4              ldy ROCKET_STATUS,X
                beq _5

                cpy #7                  ; EXP
                beq _5

                lda ROCKET_X,X
                clc
                adc ROCKET_DX-1,Y
                sta ROCKET_X,X
                lda ROCKET_Y,X
                clc
                adc ROCKET_DY-1,Y
                sta ROCKET_Y,X
_5              dex
                bmi RocketExplode

                jmp NXT_RCK

                .endblock
                .endproc


;======================================
;
;======================================
RocketExplode   .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                ldx #2
_next1          lda ROCKET_STATUS,X
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
                jsr ComputeMapAddrI

                lda ROCKET_TEMP,X
                cmp #EXP
                beq _1

                ldy #HIT_LIST_LEN
_next2          cmp HIT_LIST,Y
                beq _1

                dey
                bpl _next2
                iny                     ; Y=0
                sta (ADR1_I),Y
_1              lda #0                  ; OFF
                sta ROCKET_STATUS,X
_2              dex
                bpl _next1

                rts
                .endproc
