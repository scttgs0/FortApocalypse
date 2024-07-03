
; SPDX-FileName: options.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;======================================
;
;======================================
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

_8              lda #13                 ; (13,1)
                sta v_posX
                lda #1
                sta v_posY
                ldx #<txtOptTitle1      ; "OPTIONS"
                ldy #>txtOptTitle1
                jsr Print

                lda #0                  ; (0,3)
                sta v_posX
                lda #3
                sta v_posY
                ldx #<txtOptTitle2      ; "OPTION"
                ldy #>txtOptTitle2
                jsr Print

                lda #28                 ; (28,3)
                sta v_posX
                ldx #<txtOptTitle3      ; "SELECT"
                ldy #>txtOptTitle3
                jsr Print

PrintOptions      .block
                lda #0                  ; (0,7)
                sta v_posX
                lda #7
                sta v_posY
                ldx #<txtOptGravity     ; "GRAVITY SKILL"
                ldy #>txtOptGravity
                jsr Print

                inc v_posY              ; (0,9)
                inc v_posY
                ldx #<txtOptPilot       ; "PILOT SKILL"
                ldy #>txtOptPilot
                jsr Print

                inc v_posY              ; (0,11)
                inc v_posY
                ldx #<txtOptRobo        ; "ROBO PILOTS"
                ldy #>txtOptRobo
                jsr Print

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
                jsr CalcCursorLoc

                ldy #0
                sty TEMP5
                sty TEMP6
_next1          ldy TEMP5
                lda (ADR2),Y
                beq _1
                cmp #$FF
                beq _2

                ora #$80
                ldy TEMP6
                sta (ADR1),Y
                inc TEMP6
                clc
                adc #32
_1              ldy TEMP6
                sta (ADR1),Y
                inc TEMP6
                inc TEMP5
                bra _next1

_2              lda #28                 ; (28,7)
                sta v_posX
                lda #7
                sta v_posY
                lda GRAV_SKILL
                asl
                tay
                ldx OptGravityTable,Y   ; "WEAK|NORMAL|STRONG"
                lda OptGravityTable+1,Y
                tay
                jsr Print

                inc v_posY              ; (28,9)
                inc v_posY
                lda PILOT_SKILL
                asl
                tay
                ldx OptPilotTable,Y     ; "NOVICE|PRO|EXPERT"
                lda OptPilotTable+1,Y
                tay
                jsr Print

                inc v_posY              ; (28,11)
                inc v_posY
                lda CHOPS
                asl
                tay
                ldx OptRoboTable,Y      ; "SEVEN|NINE|ELEVEN"
                lda OptRoboTable+1,Y
                tay
                jmp Print

                .endblock
                .endproc
