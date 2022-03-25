;---------------------------------------
; System Equates for Foenix C256
;---------------------------------------

BORDER_CTRL_REG         = $AF_0004              ; Bit[0] - Enable (1 by default)
bcEnable            = $01
                                                ; Bit[4..6]: X Scroll Offset (Will scroll Left)
BORDER_COLOR_B          = $AF_0005
BORDER_COLOR_G          = $AF_0006
BORDER_COLOR_R          = $AF_0007
BORDER_X_SIZE           = $AF_0008              ; Values: 0 - 32 (Default: 32)
BORDER_Y_SIZE           = $AF_0009              ; Values: 0 - 32 (Default: 32)

KBD_INPT_BUF            = $AF_1803
irqKBD              = $01                       ; keyboard Interrupt
KEYBOARD_SCAN_CODE      = $AF_115F

JOYSTICK0               = $AF_E800              ; (R) Joystick 0 - J7 (next to SD Card)
SIO_JOY                 = $AF_1200

FONT_MEMORY_BANK0       = $AF_8000              ; $AF8000 - $AF87FF

MASTER_CTRL_REG_L	    = $AF_0000
mcTextOn            = $01                       ; Enable the Text Mode
mcOverlayOn         = $02                       ; Enable the Overlay of the text mode on top of Graphic Mode (the Background Color is ignored)
mcGraphicsOn        = $04                       ; Enable the Graphic Mode
mcBitmapOn          = $08                       ; Enable the Bitmap Module In Vicky
mcTileMapOn         = $10                       ; Enable the Tile Module in Vicky
mcSpriteOn          = $20                       ; Enable the Sprite Module in Vicky
mcDisableVideo      = $80                       ; This will disable the Scanning of the Video hence giving 100% bandwith to the CPU

MASTER_CTRL_REG_H       = $AF_0001
mcVideoMode640      = $00                       ; 0 - 640x480 (Clock @ 25.175Mhz)
mcVideoMode800      = $01                       ; 1 - 800x600 (Clock @ 40Mhz)
mcVideoMode320      = $02                       ; 2 - 320x240 pixel-doubling (Clock @ 25.175Mhz)
mcVideoMode400      = $03                       ; 3 - 400x300 pixel-doubling (Clock @ 40Mhz)

C256F_MODEL_MAJOR       = $AF_070B
C256F_MODEL_MINOR       = $AF_070C
