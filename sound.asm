
; SPDX-FileName: sound.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;=======================================
;
;=======================================
DoSounds        .proc

S1              .block                  ; CHOPPER SOUND
                lda CHOPPER_STATUS
                cmp #kOFF
                beq _XIT

                lda FRAME
                and #2
                bne _XIT

                lda #$83
                sta SID_CTRL1
                lda SND1_1_VAL
                bpl _1

                lda SND1_2_VAL
_1              sec
                sbc #4
                sta SND1_1_VAL
                sta SID_FREQ1
_XIT            .endblock


S2              .block                  ; MISSILE SOUND
                lda SND2_VAL
                bmi _XIT

                eor #$3F
                clc
                adc #16
                sta SID_FREQ2
                ldx #$86
                cmp #$3F+16
                bne _1

                ldx #0
_1              .setbank $AF
                stx SID_CTRL2
                .setbank $03
                dec SND2_VAL
_XIT            .endblock


S3              .block                  ; EXPLOSION SOUND
                lda SND3_VAL
                beq _XIT

                lda SID_RANDOM
                and #3
                ora SND3_VAL
                adc #$10
                sta SID_FREQ3
                inc SND3_VAL
                lda SND3_VAL
                cmp #$31
                bne _1

                lda #0
                sta SND3_VAL
_1              ldx #$48
                cmp #0
                bne _2

                tax                     ; X=0
_2              .setbank $AF
                stx SID_CTRL3
                .setbank $03
_XIT            .endblock


S4              .block                  ; RE-FUEL SOUND
                lda SND4_VAL
                beq _XIT

                ldx #0
                lda FRAME
                and #7
                beq _1

                ldx #$18
_1              ldy #$00
                lda FUEL1
                cmp #<MAX_FUEL
                lda FUEL2
                sbc #>MAX_FUEL
                bcs _2

                ldy #$A6
                sed
                lda FUEL1
                clc
                adc #4
                sta FUEL1
                lda FUEL2
                adc #0
                sta FUEL2
                cld
_2              .setbank $AF
                stx SID_FREQ2
                sty SID_CTRL2
                .setbank $03
_XIT            .endblock


S5              .block                  ; HYPER CHAMBER SOUND
                lda SND5_VAL
                beq _XIT

                inc SND5_VAL
                cmp #$50
                bne _1

                lda #0
                sta SND5_VAL
_1              sta SID_FREQ2
                lda #$A8
                sta SID_CTRL2
_XIT            .endblock


S6              .block                  ; CRUISE MISSILE SOUND
                lda FRAME
                and #1
                bne _XIT

                lda SND6_VAL
                beq _XIT

                inc SND6_VAL
                cmp #$20
                blt _1

                ldx #0
                stx SND6_VAL
_1              sta SID_FREQ3
                lda #$07
                sta SID_CTRL3
_XIT            rts
                .endblock
                .endproc


;=======================================
;
;=======================================
ClearSounds     .proc
                lda #0
                sta SID_CTRL1
                sta SID_CTRL2
                sta SID_CTRL3
                rts
                .endproc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
