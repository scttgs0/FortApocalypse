
; SPDX-FileName: tank.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


MAX_TANKS       = 6

TANK_SHAPE      .byte $EC,$ED,$EE,$EF,$F0
                .byte MISS_LEFT,MISS_RIGHT


;======================================
;
;======================================
PositionTank    .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda TANK_X,X
                sta TEMP1

                ldy TANK_Y,X
                dey
                sty TEMP2

                jsr PositionIt

                lda TANK_Y,X
                sta TEMP2

                rts
                .endproc


;======================================
;
;======================================
MoveTanks       .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

MT1             .block
                dec TANK_SPD
                beq _1
                jmp MT2

_1              lda TANK_SPEED
                sta TANK_SPD

                ldx #MAX_TANKS-1
_next1          lda TANK_Y,X
                sta TEMP2

                lda TANK_STATUS,X
                cmp #kOFF
                bne _2
                jmp _9

_2              cmp #kBEGIN
                bne _4

                lda #kON
                sta TANK_STATUS,X

                lda TANK_START_X,X
                sta TANK_X,X
                lda TANK_START_Y,X
                sta TANK_Y,X

                lda #-1
                ;--.setbank $AF
                .frsRandomByteY
                ;--.setbank $03
                bpl _3

                lda #$01
_3              sta TANK_DX,X

                jsr PositionTank
                bra _next4

_4              cmp #kCRASH
                bne _5
                jmp _9

;   RESTORE OLD POS
_5              lda TANK_X,X
                sta TEMP1

                jsr ComputeMapAddr
                stx TEMP1

                ldy #$00
                txa
                asl
                adc TEMP1
                tax

_next2          lda (ADR1),Y
                cmp #EXP
                beq _6

                cmp #MISS_LEFT
                beq _6

                cmp #MISS_RIGHT
                bne _7

_6              ldx TEMP1
                lda #kCRASH
                sta TANK_STATUS,X

                ldy #$02
                lda #EXP
_next3          sta (ADR1),Y

                dey
                bpl _next3

                lda #$0A
                sta TIM5_VAL

                jmp _9

_7              lda TANK_TEMP,X
                sta (ADR1),Y

                inx
                iny
                cpy #$03
                bne _next2

                ldy #$01
                dec ADR1+1

                lda #$00
                sta (ADR1),Y

;   MOVE X
                ldx TEMP1
_next4          jsr PositionTank

                lda TANK_X,X
                clc
                adc TANK_DX,X
                sta TANK_X,X

;   SAVE NEW POS
                jsr PositionTank

                lda TANK_X,X
                sta TEMP1

                jsr ComputeMapAddr
                stx TEMP1

                ldy #$00
                txa
                asl
                adc TEMP1
                tax

_next5          lda (ADR1),Y
                sta TANK_TEMP,X
                inx

                iny
                cpy #$03
                bne _next5

; check for collision
                ldx TEMP1
                ldy #$00
                jsr CheckTankCollision
                bcs _next4

                ldy #$02
                jsr CheckTankCollision
                bcs _next4

; DRAW TANK
                ldy #$02
_next6          lda TANK_SHAPE,Y
                sta (ADR1),Y

                dey
                bpl _next6

                dec ADR1+1

                ldy #$6F+128            ; 'o'
                lda CHOP_X
                sec
                sbc TANK_X,X
                bpl _8

                ldy #$70+128            ; 'p'
_8              tya
                ldy #$01
                sta (ADR1),Y

_9              dex
                bmi MT2
                jmp _next1

                .endblock

; - - - - - - - - - - - - - - - - - - -
_XIT            rts

; - - - - - - - - - - - - - - - - - - -
MT2             .block
                dec TIM5_VAL
                bne MoveTanks._XIT

                lda #$0A
                sta TIM5_VAL

                ldx #MAX_TANKS-1
_next1          lda TANK_STATUS,X
                cmp #kCRASH
                bne _1

                lda #kOFF
                sta TANK_STATUS,X

                lda TANK_X,X
                sta TEMP1
                lda TANK_Y,X
                sta TEMP2

                jsr ComputeMapAddr
                stx TEMP1

                ldy #$00
                txa
                asl
                adc TEMP1
                tax

_next2          lda TANK_TEMP,X
                sta (ADR1),Y
                inx

                iny
                cpy #$03
                bne _next2

                dec ADR1+1

                ldy #$01
                lda #$00
                sta (ADR1),Y

                ldx #$50
                ldy #$02
                jsr IncreaseScore

                ldx TEMP1
                jsr PositionTank

_1              lda TANK_STATUS,X
                cmp #kOFF
                bne _2

                lda CHOP_Y
                cmp #$03
                bcc _2

                sec
                sbc #$03
                cmp TANK_START_Y,X
                bcc _2

                lda TANK_START_X,X
                sec
                sbc #$05
                sta TEMP1
                lda TANK_START_Y,X
                sta TEMP2

                jsr ComputeMapAddr

                ldy #$0D-1
_next3          lda (ADR1),Y
                bmi _2

                dey
                bpl _next3

                lda #kBEGIN
                sta TANK_STATUS,X

_2              dex
                bpl _next1

                rts
                .endblock
                .endproc


;======================================
;
;======================================
CheckTankCollision .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;---

                ldx #HIT_LIST2_LEN
_next1          lda (ADR1),Y
                cmp HIT_LIST,X
                beq _1

                dex
                bpl _next1

                ldx TEMP1

                clc
                rts

_1              ldx TEMP1
                lda TANK_DX,X
                eor #-2
                sta TANK_DX,X

                sec
                rts
                .endproc
