;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: cruisemissile.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
MoveCruiseMissiles .proc
                dec MISSILE_SPD
                bne MCE
                lda MISSILE_SPEED
                sta MISSILE_SPD

                ldx #MAX_TANKS-1


M_ST            .block
                lda CM_STATUS,X
                cmp #OFF
                beq M_END
                cmp #BEGIN
                bne _1
                jmp MissileBegin

_1              jsr MissileCollision
                bcs M_END
                jsr MissileErase
                jsr MissileMove
                jsr MissileDraw
                .endblock


M_END           .block
                lda TANK_STATUS,X
                cmp #ON
                bne _2
                lda TANK_Y,X
                sec
                sbc CHOP_Y
                bmi _2
                cmp #14
                bge _2
                lda CM_STATUS,X
                cmp #OFF
                bne _2
                lda CHOP_X
                sec
                sbc #2
                sbc TANK_X,X
                bpl _1
                eor #-2
_1              cmp #9
                bge _2
                lda #BEGIN
                sta CM_STATUS,X

_2              dex
                bpl M_ST
                .endblock


MCE             .block
                ldx #MAX_TANKS-1
_next1          lda CM_STATUS,X
                cmp #OFF
                bne _XIT
                dex
                bpl _next1
                lda #0
                sta AUDC4
                sta S6_VAL
_XIT            rts
                .endblock
                .endproc


;=======================================
;
;=======================================
GetMissileAddr  .proc
                lda CM_X,X
                sta TEMP1
                lda CM_Y,X
                sta TEMP2
                jmp ComputeMapAddr

                .endproc


;=======================================
;
;=======================================
MissileBegin    .proc
                ldy TANK_X,X
                iny
                tya
                sta CM_X,X
                lda TANK_Y,X
                sec
                sbc #2
                sta CM_Y,X
                ldy #LEFT
                lda CHOP_X
                sec
                sbc TANK_X,X
                bmi _1

                ldy #RIGHT
_1              tya
                sta CM_STATUS,X
                lda #0
                sta CM_TEMP,X
                lda #20
                sta CM_TIME,X
                lda #1
                sta S6_VAL
                jmp MoveCruiseMissiles.M_END

                .endproc


;=======================================
;
;=======================================
MissileCollision .proc
                jsr GetMissileAddr

                ldy #0
                lda (ADR1),Y
                cmp #EXP
                beq M_COL2

                clc
                rts

M_COL2          jsr MissileErase

                lda #1
                sta S3_VAL
                lda #OFF
                sta CM_STATUS,X
                lda #-1
                sta CM_TIME,X
                stx TEMP1
                ldx #$10
                ldy #$00
                jsr IncreaseScore

                ldx TEMP1
                sec
                rts
                .endproc


;=======================================
;
;=======================================
MissileErase    .proc
                jsr GetMissileAddr

                lda CM_TEMP,X
                cmp #EXP_WALL
                beq _2

                cmp #$60+128
                bge _XIT

                cmp #$40
                beq _XIT

                cmp #$5B
                blt _2

                cmp #$5F+1
                blt _XIT

_2              ldy #0
                sta (ADR1),Y
_XIT            rts
                .endproc


;=======================================
;
;=======================================
MissileMove     .proc
                lda CM_STATUS,X
                cmp #LEFT
                beq _1

                inc CM_X,X
                jmp _2

_1              dec CM_X,X
_2              lda CM_TIME,X
                bpl _3

_4              inc CM_Y,X
                jmp _8

_3              lda CHOP_X
                sec
                sbc CM_X,X
                sta TEMP1
                lda CM_STATUS,X
                cmp #LEFT
                bne _5

                lda TEMP1
                bpl _4
                bra _6

_5              lda TEMP1
                bmi _4

_6              lda CM_X,X
                cmp #$D8
                bge _4

                cmp #$2D
                blt _4

                ldy CHOP_Y
                iny
                tya
                sec
                sbc CM_Y,X
                beq _8
                bpl _7

                dec CM_Y,X
                jmp _8

_7              inc CM_Y,X
_8              jsr GetMissileAddr

                ldy #0
                lda (ADR1),Y
                cmp #MISS_LEFT
                beq _7

                cmp #MISS_RIGHT
                beq _7

_9              lda CM_TIME,X
                bmi _XIT

                dec CM_TIME,X
_XIT             rts
                .endproc


;=======================================
;
;=======================================
MissileDraw     .proc
                jsr GetMissileAddr

                ldy #0
                lda (ADR1),Y
                sta CM_TEMP,X
                lda #MISS_LEFT
                ldy CM_STATUS,X
                cpy #LEFT
                beq _1

                lda #MISS_RIGHT
_1              ldy #0
                sta (ADR1),Y
                lda CM_TEMP,X
                jsr CheckChr

                bcc _XIT
                jmp MissileCollision.M_COL2

_XIT            rts
                .endproc


;=======================================
;
;=======================================
CheckChr        .proc
                ldy #0
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
                ldy #7
_1              lda (ADR2),Y
                bne _2

                dey
                bpl _1

                clc
                rts

_2              sec
                rts
                .endproc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
