;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; FILE: elevator.asm
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;=======================================
;
;=======================================
DoElevator      .proc
                dec ELEVATOR_TIM
                bne _XIT

                lda ELEVATOR_SPD
                sta ELEVATOR_TIM

                ldx #32-1
                lda #0
_next1          sta BLOCK_5,X
                dex
                bpl _next1

                lda ELEVATOR_NUM
                clc
                adc ELEVATOR_DX
                and #3
                sta ELEVATOR_NUM

                asl
                tax
                lda ELEVATORS,X
                sta ADR1_I
                lda ELEVATORS+1,X
                sta ADR1_I+1

                ldy #7
                lda #$55
_next2          sta (ADR1_I),Y
                dey
                bpl _next2

_XIT            rts
                .endproc

;---------------------------------------
;---------------------------------------

ELEVATORS       .addr BLOCK_5,BLOCK_6
                .addr BLOCK_7,BLOCK_8

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
