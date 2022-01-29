;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: rocket.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
UpdateRockets   .proc
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
                jsr CHECK_CHR_I
                bcc _XIT

                ldy #1
                sty S3_VAL
                dey                     ; Y=0
                sty S2_VAL
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
                lda #EXPLODE
                sta FORT_STATUS
                bne _7                  ; FORCED

_4              cmp #EXP_WALL
                bne _5

                stx TEMP1_I
                lda #$10
                sta BAK2_COLOR
                ldx #$20
                ldy #$00
                jsr INC_SCORE
                ldx TEMP1_I
                lda #0
                sta ROCKET_TEMP,X
                beq _6                 ; FORCED

_5              ldy #HIT_LIST_LEN
_next2          cmp HIT_LIST,Y
                beq _7

                dey
                bpl _next2

_6              lda #7
                bne _8                  ; FORCED

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

                cmp #7                  ; EXP
                beq _2

                lda SSIZEM
                sta SIZEM
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

;=======================================
;
;=======================================
RocketExplode   .proc
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

;---------------------------------------
;---------------------------------------

ROCKET_DX       .char -4,-4,0,4,4
ROCKET_DY       .byte 2,0,2,0,2

ROCKET1_MASK    .byte %11111100
                .byte %11110011
                .byte %11001111
;               .byte %00111111
ROCKET2_MASK    .byte %00000011
                .byte %00001100
                .byte %00110000
;               .byte %11000000
ROCKET3_MASK    .byte %00000001
                .byte %00000100
                .byte %00010000
;               .byte %01000000

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
