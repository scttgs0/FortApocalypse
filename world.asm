;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: world.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
DrawMap         .proc
DO_X            .block
                ldx CHOPPER_X
                cpx #MIN_RIGHT+1
                blt _2

                ldx #MIN_RIGHT
                stx CHOPPER_X
                lda SX
                cmp #$D8+1
                blt _1

                lda #1+1
                sta SX
_1              dec SX_F
                lda SX_F
                and #3
                eor #3
                bne _2

                inc SX
_2              cpx #MIN_LEFT
                bge _XIT

                ldx #MIN_LEFT
                stx CHOPPER_X
                lda SX
                cmp #1+1+1
                bge _3

                lda #$D8+1
                sta SX
_3              inc SX_F
                lda SX_F
                and #3
                bne _XIT

                dec SX
_XIT            .endblock

DO_Y            .block
                lda SY
                cmp #24
                beq _80

                ldx CHOPPER_Y
                cpx #MIN_DOWN+1
                blt _80

                ldx #MIN_DOWN
                stx CHOPPER_Y
                bne _21                 ; FORCED

_80             ldx CHOPPER_Y
                cpx #MAX_DOWN+1
                blt _3

                lda #MAX_DOWN
                sta CHOPPER_Y
                lda SY_F
                and #7
                bne _21

                lda SY
                cmp #24
                beq _3

_21             inc SY_F
                lda SY_F
                and #7
                bne _3

                inc SY
_3              lda SY
                cmp #-1
                beq _81

                cpx #MIN_UP
                bge _81

                ldx #MIN_UP
                stx CHOPPER_Y
                bne _31                 ; FORCED

_81             cpx #MAX_UP
                bge _4

                lda #MAX_UP
                sta CHOPPER_Y
                lda SY_F
                and #7
                eor #7
                bne _31

                lda SY
                cmp #-1
                beq _4

_31             dec SY_F
                lda SY_F
                and #7
                eor #7
                bne _4

                dec SY
_4              lda SX_F
                and #3
                sta HSCROL
                lda SY_F
                and #7
                sta VSCROL
                lda SX
                sta TEMP1_I
                lda SY
                sta TEMP2_I
                jsr ComputeMapAddrI

                ldx #0
                ldy #MAP_LINES
_5              inx
                lda ADR1_I
                sta DSP_MAP,X
                inx
                lda ADR1_I+1
                sta DSP_MAP,X
                inc ADR1_I+1
                inx
                dey
                bne _5

                rts
                .endblock
                .endproc


;=======================================
;
;=======================================
ComputeMapAddrI .proc
                lda #<MAP-5
                clc
                adc TEMP1_I
                sta ADR1_I
                lda #>MAP-5
                adc #0
                sta ADR1_I+1
                lda TEMP2_I
                clc
                adc ADR1_I+1
                sta ADR1_I+1
                rts
                .endproc


;=======================================
;
;=======================================
ComputeMapAddr  .proc
                lda #<MAP-5
                clc
                adc TEMP1
                sta ADR1
                lda #>MAP-5
                adc #0
                sta ADR1+1
                lda TEMP2
                clc
                adc ADR1+1
                sta ADR1+1
                rts
                .endproc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
