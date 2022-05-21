;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: options.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
CheckOptions   .proc
;v_???          .var ADR1
;v_???          .var ADR2
v_posX          .var TEMP1
v_posY          .var TEMP2
;v_???          .var TEMP5
;v_???          .var TEMP6
;---

                ;!! lda CONSOL
                cmp #3                  ; OPTION
                bne _2

                ldx OPT_NUM
                inx
                cpx #3
                blt _1

                ldx #0
_1              stx OPT_NUM
_2              cmp #5                  ; SELECT
                bne _8

                lda OPT_NUM
                bne _4
                ldx GRAV_SKILL
                inx
                cpx #3
                blt _3

                ldx #0
_3              stx GRAV_SKILL
_4              cmp #1
                bne _6

                ldx PILOT_SKILL
                inx
                cpx #3
                blt _5

                ldx #0
_5              stx PILOT_SKILL
_6              cmp #2
                bne _8

                ldx CHOPS
                inx
                cpx #3
                blt _7

                ldx #0
_7              stx CHOPS

_8              lda #13
                sta v_posX
                lda #1
                sta v_posY
                ldx #<txtOptTitle1
                ldy #>txtOptTitle1
                jsr Print               ; (13, 1) 'OPTIONS'

                lda #0
                sta v_posX
                lda #3
                sta v_posY
                ldx #<txtOptTitle2
                ldy #>txtOptTitle2
                jsr Print               ; (0, 3) 'OPTION'

                lda #28
                sta v_posX
                ldx #<txtOptTitle3
                ldy #>txtOptTitle3
                jsr Print               ; (28, 3) 'SELECT'

PrintOptions      .block
                lda #0
                sta v_posX
                lda #7
                sta v_posY
                ldx #<txtOptGravity
                ldy #>txtOptGravity
                jsr Print               ; (0, 7) 'GRAVITY SKILL'

                inc v_posY
                inc v_posY
                ldx #<txtOptPilot
                ldy #>txtOptPilot
                jsr Print               ; (0, 9) 'PILOT SKILL'

                inc v_posY
                inc v_posY
                ldx #<txtOptRobo
                ldy #>txtOptRobo
                jsr Print               ; (0, 11) 'ROBO PILOTS'

                lda OPT_NUM
                asl
                clc
                adc #7                  ; OPTION
                sta v_posY
                lda OPT_NUM
                asl
                tax
                lda OptTable,x
                sta ADR2
                lda OptTable+1,x
                sta ADR2+1
                jsr CalcCursorLoc

                ldy #0
                sty TEMP5
                sty TEMP6
_next1          ldy TEMP5
                lda (ADR2),y
                beq _1
                cmp #$FF
                beq _2

                ora #$80
                ldy TEMP6
                sta (ADR1),y
                inc TEMP6
                clc
                adc #32
_1              ldy TEMP6
                sta (ADR1),y
                inc TEMP6
                inc TEMP5
                bra _next1

_2              lda #28
                sta v_posX
                lda #7
                sta v_posY
                lda GRAV_SKILL
                asl
                tay
                ldx OptGravityTable,y
                lda OptGravityTable+1,y
                tay
                jsr Print               ; (28, 7) 'WEAK|NORMAL|STRONG'

                inc v_posY
                inc v_posY
                lda PILOT_SKILL
                asl
                tay
                ldx OptPilotTable,y
                lda OptPilotTable+1,y
                tay
                jsr Print               ; (28, 9) 'NOVICE|PRO|EXPERT'

                inc v_posY
                inc v_posY
                lda CHOPS
                asl
                tay
                ldx OptRoboTable,y
                lda OptRoboTable+1,y
                tay
                jmp Print               ; (28, 11) 'SEVEN|NINE|ELEVEN'

                .endblock
                .endproc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
