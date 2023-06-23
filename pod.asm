
; SPDX-FileName: pod.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


MAX_PODS        = 39


;======================================
;
;======================================
MovePods        .proc
                lda #POD_SPEED
_next1          pha
                jsr MovePods1

                pla
                sec
                sbc #1
                bne _next1

                rts
                .endproc


;======================================
;
;======================================
MovePods1       .proc
                ldx POD_NUM

                lda POD_STATUS,x
                sta POD_COM
                and #$0F
                cmp #kOFF
                beq PodsEnd

                cmp #kBEGIN
                bne _1

                jmp PodBegin

_1              jsr PodCollision
                bcs PodsEnd

                jsr PodErase
                jsr PodMove
                jsr PodDraw
                .endproc

                ;[fall-through]


;======================================
;
;======================================
PodsEnd         .proc
                ldx POD_NUM
                inx
                cpx #MAX_PODS
                blt _1

                ldx #0
_1              stx POD_NUM
                rts
                .endproc


;======================================
;
;======================================
GetPodAddr      .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda POD_X,x
                sta TEMP1
                lda POD_Y,x
                sta TEMP2
                jmp ComputeMapAddr

                .endproc


;======================================
;
;======================================
GetPodValue     .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                jsr GetPodAddr

                ldy #0
                lda (ADR1),y
                sta TEMP1
                iny
                lda (ADR1),y
                sta TEMP2
                rts
                .endproc


;======================================
;
;======================================
PutPodValue     .proc
;v_???          .var ADR1
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                jsr GetPodAddr

                ldy #0
                lda TEMP3
                sta (ADR1),y
                iny
                lda TEMP4
                sta (ADR1),y
                rts
                .endproc


;======================================
;
;======================================
PositionPod     .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                lda POD_X,x
                sta TEMP1
                lda POD_Y,x
                sta TEMP2
                jmp PositionIt

                .endproc


;======================================
;
;======================================
PodBegin        .proc
;v_???          .var ADR1
;---

_next1          lda SID_RANDOM
                cmp #50
                blt _next1

                cmp #256-50
                bge _next1

                sta POD_X,x
_next2          lda SID_RANDOM
                cmp #40
                bge _next2

                sta POD_Y,x
                jsr GetPodAddr

                ldy #0
                lda (ADR1),y
                iny
                ora (ADR1),y
                bne _next1

                lda #kON
                sta POD_STATUS,x
                sta POD_COM
                jsr PodDraw

                lda #$01
                sta POD_DX,x
                jmp PodsEnd

                .endproc


;======================================
;
;======================================
PodCollision    .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

                jsr GetPodValue

                lda TEMP1
                cmp #MISS_LEFT
                beq _1

                cmp #MISS_RIGHT
                beq _1

                cmp #EXP
                beq _1

                lda TEMP2
                cmp #MISS_LEFT
                beq _1

                cmp #MISS_RIGHT
                beq _1

                cmp #EXP
                beq _1

                clc
                rts

_1              jsr PodErase

                lda #kOFF
                sta POD_STATUS,x
                ldx #$50
                ldy #$00
                jsr IncreaseScore

                sec
                rts
                .endproc


;======================================
;
;======================================
PodErase        .proc
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                jsr PositionPod

                lda POD_TEMP1,x
                sta TEMP3
                lda POD_TEMP2,x
                sta TEMP4
                jmp PutPodValue

                .endproc


;======================================
;
;======================================
PodDraw         .proc
;v_???          .var TEMP1
;v_???          .var TEMP2
;v_???          .var TEMP3
;v_???          .var TEMP4
;---

                jsr PositionPod
                jsr GetPodValue

                lda TEMP1
                sta POD_TEMP1,x
                lda TEMP2
                sta POD_TEMP2,x
                lda POD_COM
                lsr
                lsr
                lsr
                tay
                lda POD_CHR,y
                sta TEMP3
                lda POD_CHR+1,y
                sta TEMP4
                jmp PutPodValue

                .endproc


;======================================
;
;======================================
PodMove         .proc
;v_???          .var ADR1
;v_???          .var TEMP1
;v_???          .var TEMP2
;---

_next1          lda POD_DX,x
                bpl _1

                lda POD_COM
                sec
                sbc #$10
                and #$3F
                sta POD_COM
                and #$F0
                cmp #$30
                bne _2

                dec POD_X,x
                jmp _2

_1              lda POD_COM
                clc
                adc #$10
                and #$3F
                sta POD_COM
                and #$F0
                bne _2

                inc POD_X,x
_2              lda POD_X,x
                sta TEMP1
                lda POD_Y,x
                sta TEMP2
                jsr ComputeMapAddr

                ldy #0
                lda (ADR1),y
                iny
                ora (ADR1),y
                bne _3

                lda POD_X,x
                cmp #50
                blt _3

                cmp #256-50
                blt _4

_3              lda POD_DX,x
                eor #-2
                sta POD_DX,x
                bra _next1

_4              lda POD_COM
                sta POD_STATUS,x
                rts
                .endproc

;--------------------------------------
;--------------------------------------

POD_CHR         .byte $40,$00
                .byte $5B,$5C
                .byte $5D,$5E
                .byte $00,$5F
