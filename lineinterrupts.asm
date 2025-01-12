
; SPDX-FileName: lineinterrupts.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; DLI (Head)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dliLINE1        .proc
                pha
                txa
                pha

                lda #<dliLINE2
                ;!! sta VDSLST
                lda #>dliLINE2
                ;!! sta VDSLST+1

                ldx #$00
_next1          txa
                ;!! sta WSYNC

                asl
                ora #$E0
                ;!! sta COLBK

                inx
                cpx #$08
                bne _next1
                bra dliLINE2.LINEC

                .endproc


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; DLI (Stage 2)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dliLINE2        .proc
                pha
                txa
                pha

                lda #<dliLINE3
                ;!! sta VDSLST
                lda #>dliLINE3
                ;!! sta VDSLST+1

                ldx #$02
_next1          lda ROCKET_X,X
                .frsSpriteSetX_ix       ; missiles = sprint 5+

                dex
                bpl _next1

                ldx #$07
_next2          txa
                ;!! sta WSYNC

                asl
                ora #$E0
                ;!! sta COLBK

                dex
                bpl _next2

LINEC           lda #$00
                ;!! sta COLBK

                pla
                tax
                pla
                rti
                .endproc


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; DLI (Stage 3)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dliLINE3        .proc
                pha
                php
                cld

                lda #<dliLINE4
                ;!! sta VDSLST
                lda #>dliLINE4
                ;!! sta VDSLST+1

                lda ROBOT_X
                sta SPR(sprite_t.X, 2)
                clc
                adc #$08
                sta SPR(sprite_t.X, 3)

                lda #>CHR_SET2
                ;!! sta WSYNC
                ;!! sta CHBASE

                lda BAK_COLOR
                ;!! sta COLPF0
                lda #$0A
                ;!! sta COLPF1
                lda #$93
                ;!! sta COLPF2
                lda FRAME
                ;!! sta COLPF3

                ;!! sta WSYNC

                lda BAK2_COLOR
                ;!! sta COLBK

                plp
                pla
                rti
                .endproc


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; DLI (Tail)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dliLINE4        .proc
                pha
                txa
                pha
                tya
                pha
                php

                cld
                lda #<dliLINE1
                ;!! sta VDSLST
                lda #>dliLINE1
                ;!! sta VDSLST+1

                ldx #$07
                lda #$00
_next1          .frsSpriteSetX_ix

                dex
                bpl _next1

                ;!! sta WSYNC
                ;!! sta COLBK

                lda MODE
                cmp #STOP_MODE
                beq _1

                cmp #GO_MODE
                bne _2

_1              jsr DoSounds

_2              plp
                pla
                tay
                pla
                tax
                pla
                rti
                .endproc
