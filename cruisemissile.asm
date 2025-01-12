
; SPDX-FileName: cruisemissile.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;======================================
;
;======================================
MoveCruiseMissiles .proc
                dec MISSILE_SPD
                bne MCE

                lda MISSILE_SPEED
                sta MISSILE_SPD

                ldx #MAX_TANKS-1

; - - - - - - - - - - - - - - - - - - -
M_ST            .block
                lda CM_STATUS,X
                cmp #kOFF
                beq M_END

                cmp #kBEGIN
                bne _1
                jmp MissileBegin

_1              jsr MissileCollision
                bcs M_END

                jsr MissileErase
                jsr MissileMove
                jsr MissileDraw

                .endblock

; - - - - - - - - - - - - - - - - - - -
M_END           .block
                lda TANK_STATUS,X
                cmp #kON
                bne _2

                lda TANK_Y,X
                sec
                sbc CHOP_Y
                bmi _2

                cmp #$0E
                bcs _2

                lda CM_STATUS,X
                cmp #kOFF
                bne _2

                lda CHOP_X
                sec
                sbc #$02
                sbc TANK_X,X
                bpl _1

                eor #-2
_1              cmp #$09
                bcs _2

                lda #kBEGIN
                sta CM_STATUS,X

_2              dex
                bpl M_ST

                .endblock

; - - - - - - - - - - - - - - - - - - -
MCE             .block
                ldx #MAX_TANKS-1
_next1          lda CM_STATUS,X
                cmp #kOFF
                bne _XIT

                dex
                bpl _next1

                lda #$00
                sta SID1_CTRL3
                sta SND6_VAL

_XIT            rts
                .endblock
                .endproc


;======================================
;
;======================================
GetMissileAddr  .proc
v_posX          .var TEMP1
v_posY          .var TEMP2
;---

                lda CM_X,X
                sta v_posX
                lda CM_Y,X
                sta v_posY

                jmp ComputeMapAddr

                .endproc


;======================================
;
;======================================
MissileBegin    .proc
                ldy TANK_X,X
                iny
                tya
                sta CM_X,X

                lda TANK_Y,X
                sec
                sbc #$02
                sta CM_Y,X

                ldy #kLEFT
                lda CHOP_X
                sec
                sbc TANK_X,X
                bmi _1

                ldy #kRIGHT
_1              tya
                sta CM_STATUS,X

                lda #$00
                sta CM_TEMP,X

                lda #$14
                sta CM_TIME,X

                lda #$01
                sta SND6_VAL

                jmp MoveCruiseMissiles.M_END

                .endproc


;======================================
;
;======================================
MissileCollision .proc
;v_???          .var ADR1
v_preserveX     .var TEMP1
;---

                jsr GetMissileAddr

                ldy #$00
                lda (ADR1),Y
                cmp #EXP
                beq M_COL2

                clc
                rts

M_COL2          jsr MissileErase

                lda #$01
                sta SND3_VAL

                lda #kOFF
                sta CM_STATUS,X

                lda #-1
                sta CM_TIME,X
                stx v_preserveX

                ldx #$10
                ldy #$00
                jsr IncreaseScore

                ldx v_preserveX

                sec
                rts
                .endproc


;======================================
;
;======================================
MissileErase    .proc
;v_???          .var ADR1
;---

                jsr GetMissileAddr

                lda CM_TEMP,X
                cmp #EXP_WALL
                beq _1

                cmp #$60+128
                bcs _XIT

                cmp #$40
                beq _XIT

                cmp #$5B
                bcc _1

                cmp #$5F+1
                bcc _XIT

_1              ldy #$00
                sta (ADR1),Y

_XIT            rts
                .endproc


;======================================
;
;======================================
MissileMove     .proc
;v_???          .var ADR1
v_distance      .var TEMP1
;---

                lda CM_STATUS,X
                cmp #kLEFT
                beq _1

                inc CM_X,X

                bra _2

_1              dec CM_X,X

_2              lda CM_TIME,X
                bpl _3

_next1          inc CM_Y,X

                jmp _6

_3              lda CHOP_X
                sec
                sbc CM_X,X
                sta v_distance

                lda CM_STATUS,X
                cmp #kLEFT
                bne _4

                lda v_distance
                bpl _next1
                bra _5

_4              lda v_distance
                bmi _next1

_5              lda CM_X,X
                cmp #$D8
                bcs _next1

                cmp #$2D
                bcc _next1

                ldy CHOP_Y
                iny
                tya

                sec
                sbc CM_Y,X
                beq _6
                bpl _next2

                dec CM_Y,X

                bra _6

_next2          inc CM_Y,X

_6              jsr GetMissileAddr

                ldy #$00
                lda (ADR1),Y
                cmp #MISS_LEFT
                beq _next2

                cmp #MISS_RIGHT
                beq _next2

                lda CM_TIME,X
                bmi _XIT

                dec CM_TIME,X

_XIT            rts
                .endproc


;======================================
;
;======================================
MissileDraw     .proc
;v_???          .var ADR1
;---

                jsr GetMissileAddr

                ldy #$00
                lda (ADR1),Y
                sta CM_TEMP,X

                lda #MISS_LEFT
                ldy CM_STATUS,X
                cpy #kLEFT
                beq _1

                lda #MISS_RIGHT
_1              ldy #$00
                sta (ADR1),Y

                lda CM_TEMP,X
                jsr CheckChr

                bcc _XIT
                jmp MissileCollision.M_COL2

_XIT            rts
                .endproc


;======================================
;
;======================================
CheckChr        .proc
;v_???          .var ADR2
;---

                ldy #$00
                sty ADR2+1
                and #$7F
                asl
                rol ADR2+1
                asl
                rol ADR2+1
                asl
                rol ADR2+1

                clc
                adc #<CHR_SET2
                sta ADR2
                lda #>CHR_SET2
                adc ADR2+1
                sta ADR2+1

                ldy #$07
_next1          lda (ADR2),Y
                bne _XIT

                dey
                bpl _next1

                clc
                rts

_XIT            sec
                rts
                .endproc
