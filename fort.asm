
; SPDX-FileName: fort.asm
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5


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

;======================================
;======================================
;* Port to Foenix Retro Systems F256
;*            June 2023
;======================================
; Memory Structure
;======================================
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
;======================================

                .cpu "65c02"

                .include "equates/system_f256jr.equ"
                .include "equates/zeropage.equ"
                .include "equates/game.equ"

                .include "macros/frs_jr_graphic.mac"
                .include "macros/frs_jr_mouse.mac"
                .include "macros/frs_jr_random.mac"
                .include "macros/frs_jr_sprite.mac"

            .enc "atari-screen"
                .cdef " Z",$00
                .cdef "az",$61
            .enc "atari-screen-inverse"
                .cdef "  ",$00
                .cdef "!Z",$81
                .cdef "az",$E1
            .enc "none"


;--------------------------------------
;--------------------------------------
                * = $2000
;--------------------------------------

                .include "LEVEL.inc"


;--------------------------------------
;--------------------------------------
                .align $100
;--------------------------------------

                .include "FONT1.inc"


;--------------------------------------
;--------------------------------------
                .align $100
;--------------------------------------

                .include "FONT2.inc"

;--------------------------------------
;--------------------------------------
                .align $1000
;--------------------------------------

                jmp CartridgeStart

                ; Engine
                .include "engine_main.asm"
                .include "DISPLAYLIST.inc"
                .include "input.asm"
                .include "miscellaneous.asm"
                .include "sound.asm"
                .include "TEXT.inc"

                ; Interrupts
                .include "lineinterrupts.asm"
                .include "vbinterrupts.asm"

                ; Mode Screens
                .include "options.asm"
                .include "title.asm"

                ; Protagonist
                .include "chopper.asm"
                .include "CHOPPER.inc"

                ; Baddies
                .include "cruisemissile.asm"
                .include "pod.asm"
                .include "robot.asm"
                .include "rocket.asm"
                .include "ROCKET.inc"
                .include "tank.asm"

                ; Environment
                .include "elevator.asm"
                .include "fuel.asm"
                .include "FUEL.inc"
                .include "hyperchamber.asm"
                .include "landingpad.asm"
                .include "laser.asm"
                .include "LASER.inc"
                .include "navatron.asm"
                .include "slaves.asm"
                .include "world.asm"

                .end
