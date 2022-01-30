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
                lda CM_STATUS,x
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
                lda TANK_STATUS,x
                cmp #ON
                bne _2
                lda TANK_Y,x
                sec
                sbc CHOP_Y
                bmi _2
                cmp #14
                bge _2
                lda CM_STATUS,x
                cmp #OFF
                bne _2
                lda CHOP_X
                sec
                sbc #2
                sbc TANK_X,x
                bpl _1
                eor #-2
_1              cmp #9
                bge _2
                lda #BEGIN
                sta CM_STATUS,x

_2              dex
                bpl M_ST
                .endblock


MCE             .block
                ldx #MAX_TANKS-1
_next1          lda CM_STATUS,x
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
                lda CM_X,x
                sta TEMP1
                lda CM_Y,x
                sta TEMP2
                jmp ComputeMapAddr

                .endproc


;=======================================
;
;=======================================
MissileBegin    .proc
                ldy TANK_X,x
                iny
                tya
                sta CM_X,x
                lda TANK_Y,x
                sec
                sbc #2
                sta CM_Y,x
                ldy #LEFT
                lda CHOP_X
                sec
                sbc TANK_X,x
                bmi _1

                ldy #RIGHT
_1              tya
                sta CM_STATUS,x
                lda #0
                sta CM_TEMP,x
                lda #20
                sta CM_TIME,x
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
                lda (ADR1),y
                cmp #EXP
                beq M_COL2

                clc
                rts

M_COL2          jsr MissileErase

                lda #1
                sta S3_VAL
                lda #OFF
                sta CM_STATUS,x
                lda #-1
                sta CM_TIME,x
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

                lda CM_TEMP,x
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
                sta (ADR1),y
_XIT            rts
                .endproc


;=======================================
;
;=======================================
MissileMove     .proc
                lda CM_STATUS,x
                cmp #LEFT
                beq _1

                inc CM_X,x
                jmp _2

_1              dec CM_X,x
_2              lda CM_TIME,x
                bpl _3

_4              inc CM_Y,x
                jmp _8

_3              lda CHOP_X
                sec
                sbc CM_X,x
                sta TEMP1
                lda CM_STATUS,x
                cmp #LEFT
                bne _5

                lda TEMP1
                bpl _4
                bra _6

_5              lda TEMP1
                bmi _4

_6              lda CM_X,x
                cmp #$D8
                bge _4

                cmp #$2D
                blt _4

                ldy CHOP_Y
                iny
                tya
                sec
                sbc CM_Y,x
                beq _8
                bpl _7

                dec CM_Y,x
                jmp _8

_7              inc CM_Y,x
_8              jsr GetMissileAddr

                ldy #0
                lda (ADR1),y
                cmp #MISS_LEFT
                beq _7

                cmp #MISS_RIGHT
                beq _7

_9              lda CM_TIME,x
                bmi _XIT

                dec CM_TIME,x
_XIT             rts
                .endproc


;=======================================
;
;=======================================
MissileDraw     .proc
                jsr GetMissileAddr

                ldy #0
                lda (ADR1),y
                sta CM_TEMP,x
                lda #MISS_LEFT
                ldy CM_STATUS,x
                cpy #LEFT
                beq _1

                lda #MISS_RIGHT
_1              ldy #0
                sta (ADR1),y
                lda CM_TEMP,x
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
_1              lda (ADR2),y
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
