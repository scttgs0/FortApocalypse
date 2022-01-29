;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: pod.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MAX_PODS        = 39


;=======================================
;
;=======================================
MovePods        .proc
                lda #POD_SPEED
_next1          pha
                jsr MovePods1

                pla
                sec
                sbc #1
                bne _next1

_2              rts
                .endproc


;=======================================
;
;=======================================
MovePods1       .proc
                ldx POD_NUM

                lda POD_STATUS,X
                sta POD_COM
                and #$0F
                cmp #OFF
                beq PodsEnd

                cmp #BEGIN
                bne _1

                jmp PodBegin

_1              jsr PodCollision
                bcs PodsEnd

                jsr PodErase
                jsr PodMove
                jsr PodDraw
                .endproc

                ;[fall-through]


;=======================================
;
;=======================================
PodsEnd         .proc
                ldx POD_NUM
                inx
                cpx #MAX_PODS
                blt _1

                ldx #0
_1              stx POD_NUM
                rts
                .endproc


;=======================================
;
;=======================================
GetPodAddr      .proc
;---

                lda POD_X,X
                sta TEMP1
                lda POD_Y,X
                sta TEMP2
                jmp COMPUTE_MAP_ADR

                .endproc

;=======================================
;
;=======================================
GetPodValue     .proc
                jsr GetPodAddr

                ldy #0
                lda (ADR1),Y
                sta TEMP1
                iny
                lda (ADR1),Y
                sta TEMP2
                rts
                .endproc


;=======================================
;
;=======================================
PutPodValue     .proc
                jsr GetPodAddr

                ldy #0
                lda TEMP3
                sta (ADR1),Y
                iny
                lda TEMP4
                sta (ADR1),Y
                rts
                .endproc


;=======================================
;
;=======================================
PositionPod     .proc
                lda POD_X,X
                sta TEMP1
                lda POD_Y,X
                sta TEMP2
                jmp POS_IT

                .endproc


;=======================================
;
;=======================================
PodBegin        .proc
_next1          lda RANDOM
                cmp #50
                blt _next1

                cmp #256-50
                bge _next1

                sta POD_X,X
_next2          lda RANDOM
                cmp #40
                bge _next2

                sta POD_Y,X
                jsr GetPodAddr

                ldy #0
                lda (ADR1),Y
                iny
                ora (ADR1),Y
                bne _next1

                lda #ON
                sta POD_STATUS,X
                sta POD_COM
                jsr PodDraw

                lda #$01
                sta POD_DX,X
                jmp PodsEnd

                .endproc


;=======================================
;
;=======================================
PodCollision    .proc
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

                lda #OFF
                sta POD_STATUS,X
                ldx #$50
                ldy #$00
                jsr INC_SCORE

                sec
                rts
                .endproc


;=======================================
;
;=======================================
PodErase        .proc
                jsr PositionPod

                lda POD_TEMP1,X
                sta TEMP3
                lda POD_TEMP2,X
                sta TEMP4
                jmp PutPodValue

                .endproc


;=======================================
;
;=======================================
PodDraw         .proc
                jsr PositionPod
                jsr GetPodValue

                lda TEMP1
                sta POD_TEMP1,X
                lda TEMP2
                sta POD_TEMP2,X
                lda POD_COM
                lsr
                lsr
                lsr
                tay
                lda POD_CHR,Y
                sta TEMP3
                lda POD_CHR+1,Y
                sta TEMP4
                jmp PutPodValue

                .endproc


;=======================================
;
;=======================================
PodMove         .proc
_next1          lda POD_DX,X
                bpl _1

                lda POD_COM
                sec
                sbc #$10
                and #$3F
                sta POD_COM
                and #$F0
                cmp #$30
                bne _2

                dec POD_X,X
                jmp _2

_1              lda POD_COM
                clc
                adc #$10
                and #$3F
                sta POD_COM
                and #$F0
                bne _2

                inc POD_X,X
_2              lda POD_X,X
                sta TEMP1
                lda POD_Y,X
                sta TEMP2
                jsr COMPUTE_MAP_ADR

                ldy #0
                lda (ADR1),Y
                iny
                ora (ADR1),Y
                bne _3

                lda POD_X,X
                cmp #50
                blt _3

                cmp #256-50
                blt _4

_3              lda POD_DX,X
                eor #-2
                sta POD_DX,X
                bra _next1

_4              lda POD_COM
                sta POD_STATUS,X
                rts
                .endproc


;---------------------------------------
;---------------------------------------

POD_CHR         .byte $40,$00
                .byte $5B,$5C
                .byte $5D,$5E
                .byte $00,$5F

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
