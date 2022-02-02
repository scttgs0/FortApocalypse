;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: rocket.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
UpdateRockets   .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                ldx #2


NXT_RCK         .block
                lda ROCKET_STATUS,x
                bne _1

_next1          jmp _XIT

_1              cmp #7
                beq _next1

                lda ROCKET_X,x
                sec
                sbc #32+1
                lsr
                lsr
                clc
                adc SX
                sta TEMP1_I
                sta ROCKET_TEMPX,x
                lda #0
                ldy SY
                bmi _2

                lda SY_F
                and #7
_2              clc
                adc ROCKET_Y,x
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
                sta ROCKET_TEMPY,x
                jsr CheckChrI
                bcc _XIT

                ldy #1
                sty SND3_VAL
                dey                     ; Y=0
                sty SND2_VAL
                lda (ADR1_I),y
                sta ROCKET_TEMP,x
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
                sta ROCKET_TEMP,x
                bra _6

_5              ldy #HIT_LIST_LEN
_next2          cmp HIT_LIST,y
                beq _7

                dey
                bpl _next2

_6              lda #7
                bra _8

_7              lda #0
_8              sta ROCKET_STATUS,x
                ldy #0
                lda #EXP
                sta (ADR1_I),y
                lda #7
                sta ROCKET_TIM,x
_XIT            .endblock


MOVE_ROCKETS    .block
                lda ROCKET_STATUS,x
                beq _1

                cmp #7                  ; EXP
                beq _2

                lda SSIZEM
                sta SIZEM
                lda ROCKET_X,x
                cmp #0+4
                blt _1

                cmp #255-4
                bge _1

                lda ROCKET_Y,x
                cmp #MAX_DOWN+18
                bge _1

                cmp #MAX_UP
                bge _3

_1              lda #0                  ; OFF
                sta ROCKET_STATUS,x
_2              lda #0
                sta ROCKET_X,x
                lda #$F0
                sta ROCKET_Y,x
_3              ldy OROCKET_Y,x
                lda PLAYER+MIS+0,y
                and ROCKET1_MASK,x
                sta PLAYER+MIS+0,y
                lda PLAYER+MIS+1,y
                and ROCKET1_MASK,x
                sta PLAYER+MIS+1,y
                lda PLAYER+MIS+4,y
                and ROCKET1_MASK,x
                sta PLAYER+MIS+4,y
                lda PLAYER+MIS+5,y
                and ROCKET1_MASK,x
                sta PLAYER+MIS+5,y
                lda ROCKET_Y,x
                sta OROCKET_Y,x
                tay
                lda ROCKET2_MASK,x
                pha
                ora PLAYER+MIS+0,y
                sta PLAYER+MIS+0,y
                pla
                ora PLAYER+MIS+1,y
                sta PLAYER+MIS+1,y
                lda SSIZEM
                and ROCKET1_MASK,x
                sta SSIZEM
                lda ROCKET_STATUS,x
                cmp #3
                beq _4

                lda SSIZEM
                ora ROCKET3_MASK,x
                sta SSIZEM
                lda ROCKET2_MASK,x
                pha
                ora PLAYER+MIS+4,y
                sta PLAYER+MIS+4,y
                pla
                ora PLAYER+MIS+5,y
                sta PLAYER+MIS+5,y
_4              ldy ROCKET_STATUS,x
                beq _5

                cpy #7                  ; EXP
                beq _5

                lda ROCKET_X,x
                clc
                adc ROCKET_DX-1,y
                sta ROCKET_X,x
                lda ROCKET_Y,x
                clc
                adc ROCKET_DY-1,y
                sta ROCKET_Y,x
_5              dex
                bmi RocketExplode

                jmp NXT_RCK

                .endblock
                .endproc


;=======================================
;
;=======================================
RocketExplode   .proc
;v_???          .var ADR1_I
;v_???          .var TEMP1_I
;v_???          .var TEMP2_I
;---

                ldx #2
_next1          lda ROCKET_STATUS,x
                cmp #7                  ; EXP
                bne _2

                dec ROCKET_TIM,x
                bne _2

                lda ROCKET_TEMPX,x
                sta TEMP1_I
                lda ROCKET_TEMPY,x
                sta TEMP2_I
                lda #0
                sta BAK2_COLOR
                jsr ComputeMapAddrI

                lda ROCKET_TEMP,x
                cmp #EXP
                beq _1

                ldy #HIT_LIST_LEN
_next2          cmp HIT_LIST,y
                beq _1

                dey
                bpl _next2
                iny                     ; Y=0
                sta (ADR1_I),y
_1              lda #0                  ; OFF
                sta ROCKET_STATUS,x
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
