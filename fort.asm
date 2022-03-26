;***************************
;*     Fort Apocalypse     *
;*                         *
;*     By Steve Hales      *
;*                         *
;*     Copyright           *
;*     September 1 1982    *
;*     Synapse Software    *
;*                         *
;*     Febuary 8, 1983     *
;*                         *
;***************************

;=======================================
;=======================================
;* Port to Foenix Retro Systems C256
;*            JANUARY 2022
;=======================================
; Memory Structure
;=======================================
; Static Usage      15.9 K
; Dynamic Usage     ??? K
;
; Unpacked...
; Level             $03:4000 - ???
; Font1
; Font2
;
; Packed...
; Level             $03:8000 - $03:9220
; Font1             $03:9300 - $02:95c8
; Font2             $03:9600 - $03:988f
;
; Code              $03:a000 - $03:c810
;=======================================

                .cpu "65816"

                ;.include "equates_system_atari8.asm"
                .include "equates_system_c256.asm"
                .include "equates_directpage.asm"
                .include "equates_game.asm"
                .include "macros.asm"

                * = $03_8000
                .include "level.asm"

                .align $100
                .include "font1.asm"

                .align $100
                .include "font2.asm"

                .align $1000
                clc
                xce
                .m8i8
                .setdp $B000
                .setbank $03

                jml CartridgeStart

                ; Engine
                .include "engine_main.asm"
                .include "displaylist.asm"
                .include "input.asm"
                .include "miscellaneous.asm"
                .include "sound.asm"
                .include "text.asm"

                ; Interrupts
                .include "lineinterrupts.asm"
                .include "vbinterrupts.asm"

                ; Mode Screens
                .include "options.asm"
                .include "title.asm"

                ; Protagonist
                .include "chopper.asm"

                ; Baddies
                .include "cruisemissile.asm"
                .include "pod.asm"
                .include "robot.asm"
                .include "rocket.asm"
                .include "tank.asm"

                ; Environment
                .include "elevator.asm"
                .include "fuel.asm"
                .include "hyperchamber.asm"
                .include "landingpad.asm"
                .include "laser.asm"
                .include "navatron.asm"
                .include "slaves.asm"
                .include "world.asm"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; EOF
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
