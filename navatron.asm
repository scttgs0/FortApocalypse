;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: navatron.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
SetScanner      .proc
;v_???          .var ADR1
;v_???          .var ADR2
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda #0
                sta TEMP1
                sta TEMP2

                ;-----------------------
                ; Copy Protection
                ;-----------------------
                ; inc DrawMap
                ;-----------------------

                lda SY
                beq _2
                bmi _2

                cmp #17
                blt _1

                lda #16
_1              jsr MULT_BY_40

_2              lda SX
                lsr
                lsr
                lsr
                clc
                adc #<SCANNER
                adc TEMP1
                sta ADR1
                lda #>SCANNER
                adc TEMP2
                sta ADR1+1

                lda ADR1
                sta SCAN_ADR1
                lda ADR1+1
                sta SCAN_ADR1+1

                lda #<S_LINE1
                sta SCAN_ADR2
                sta ADR2
                lda #>S_LINE1
                sta SCAN_ADR2+1
                sta ADR2+1
                jsr DO_LINE

                lda #<S_LINE2
                sta SCAN_ADR2
                sta ADR2
                lda #>S_LINE2
                sta SCAN_ADR2+1
                sta ADR2+1
                jsr DO_LINE

                lda #<S_LINE3
                sta SCAN_ADR2
                sta ADR2
                lda #>S_LINE3
                sta SCAN_ADR2+1
                sta ADR2+1
                jmp DO_LINE

_3              rts
                .endproc


;=======================================
;
;=======================================
DO_LINE         .proc
;v_???          .var ADR1
;v_???          .var ADR2
;v_???          .var TEMP1
;---

                lda #7
                sta TEMP1
_0              ldx #12
                ldy #0
_1              lda (ADR1),y
                sta (ADR2),y
                inc ADR1
                bne _2

                inc ADR1+1
_2              lda ADR2
                clc
                adc #8
                sta ADR2
                lda ADR2+1
                adc #0
                sta ADR2+1
                dex
                bne _1

                lda SCAN_ADR1
                clc
                adc #40
                sta SCAN_ADR1
                sta ADR1
                lda SCAN_ADR1+1
                adc #0
                sta SCAN_ADR1+1
                sta ADR1+1
                inc SCAN_ADR2
                bne _3

                inc SCAN_ADR2+1
_3              lda SCAN_ADR2
                sta ADR2
                lda SCAN_ADR2+1
                sta ADR2+1
                dec TEMP1
                bpl _0

                rts
                .endproc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
