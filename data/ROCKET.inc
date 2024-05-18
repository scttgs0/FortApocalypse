
; SPDX-FileName: ROCKET.inc
; SPDX-FileCopyrightText: Fort Apocalypse © 1995, 2007, 2015 Steve Hales.
; SPDX-FileContributor: Modified by Scott Giese 2023
; SPDX-License-Identifier: CC-BY-NC-ND-2.5



ROCKET_DX       .char -4,-4,0,4,4
ROCKET_DY       .byte 2,0,2,0,2

ROCKET1_MASK    .byte %11111100
                .byte %11110011
                .byte %11001111
;               .byte %00111111
ROCKET2_MASK    .byte %00000011
                .byte %00001100
                .byte %00110000
;               .byte %11000000
ROCKET3_MASK    .byte %00000001
                .byte %00000100
                .byte %00010000
;               .byte %01000000
