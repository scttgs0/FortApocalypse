;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: options.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
CHECK_OPTIONS   .proc
v_posX          .var TEMP1
v_posY          .var TEMP2
;---

                lda CONSOL
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
                jsr PRINT               ; (13, 1) 'OPTIONS'

                lda #0
                sta v_posX
                lda #3
                sta v_posY
                ldx #<txtOptTitle2
                ldy #>txtOptTitle2
                jsr PRINT               ; (0, 3) 'OPTION'

                lda #28
                sta v_posX
                ldx #<txtOptTitle3
                ldy #>txtOptTitle3
                jsr PRINT               ; (28, 3) 'SELECT'

PRINT_OPTS      .block
                lda #0
                sta v_posX
                lda #7
                sta v_posY
                ldx #<txtOptGravity
                ldy #>txtOptGravity
                jsr PRINT               ; (0, 7) 'GRAVITY SKILL'

                inc v_posY
                inc v_posY
                ldx #<txtOptPilot
                ldy #>txtOptPilot
                jsr PRINT               ; (0, 9) 'PILOT SKILL'

                inc v_posY
                inc v_posY
                ldx #<txtOptRobo
                ldy #>txtOptRobo
                jsr PRINT               ; (0, 11) 'ROBO PILOTS'

                lda OPT_NUM
                asl
                clc
                adc #7                  ; OPTION
                sta v_posY
                lda OPT_NUM
                asl
                tax
                lda OptTable,X
                sta ADR2
                lda OptTable+1,X
                sta ADR2+1
                jsr CCL

                ldy #0
                sty TEMP5
                sty TEMP6
_1              ldy TEMP5
                lda (ADR2),Y
                beq _3
                cmp #$FF
                beq _2

                ora #$80
                ldy TEMP6
                sta (ADR1),Y
                inc TEMP6
                clc
                adc #32
_3              ldy TEMP6
                sta (ADR1),Y
                inc TEMP6
                inc TEMP5
                bne _1                  ; FORCED

_2              lda #28
                sta v_posX
                lda #7
                sta v_posY
                lda GRAV_SKILL
                asl
                tay
                ldx OptGravityTable,Y
                lda OptGravityTable+1,Y
                tay
                jsr PRINT               ; (28, 7) 'WEAK|NORMAL|STRONG'

                inc v_posY
                inc v_posY
                lda PILOT_SKILL
                asl
                tay
                ldx OptPilotTable,Y
                lda OptPilotTable+1,Y
                tay
                jsr PRINT               ; (28, 9) 'NOVICE|PRO|EXPERT'

                inc v_posY
                inc v_posY
                lda CHOPS
                asl
                tay
                ldx OptRoboTable,Y
                lda OptRoboTable+1,Y
                tay
                jmp PRINT               ; (28, 11) 'SEVEN|NINE|ELEVEN'

                .endblock
                .endproc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
