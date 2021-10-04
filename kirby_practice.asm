CUR_ROM_BANK                    equ     $d02c
SELECT_ROM_BANK                 equ     $2000

CUR_LEVEL                       equ     $d03b

BIT_BUTTON_A                    equ     0
BIT_BUTTON_B                    equ     1
BIT_BUTTON_SELECT               equ     2
BIT_BUTTON_START                equ     3
BIT_BUTTON_RIGHT                equ     4
BIT_BUTTON_LEFT                 equ     5
BIT_BUTTON_UP                   equ     6
BIT_BUTTON_DOWN                 equ     7

TILE_CURSOR                     equ     $b8
TILE_0                          equ     $ba
TILE_1                          equ     $bc
TILE_VERSION                    equ     $da

TILE_0_IN_GAME                  equ     $72
TILE_A_IN_GAME                  equ     $6b
TILE_B_IN_GAME                  equ     $6c
TILE_C_IN_GAME                  equ     $6d
TILE_D_IN_GAME                  equ     $6f
TILE_E_IN_GAME                  equ     $70
TILE_F_IN_GAME                  equ     $71

JOYPAD_0                        equ     $d04f
JOYPAD_1                        equ     $ff8b

SPRITE_BUFFER                   equ     $c000

SEED_1                          equ     $d02f
SEED_2                          equ     $d030

NUM_SELECTIONS                  equ     5

BUTTON_FRAMES_1                 equ     22
BUTTON_FRAMES_2                 equ     5

SECTION "protected1", ROM0[$0040]
        db      $c3

SECTION "protected2", ROM0[$3fe0]
        db      $ff

SECTION "overwrite_status_lives_1", ROM0[$1c20]
        ld      a, $7f
SECTION "overwrite_status_lives_2", ROM0[$1c25]
        ld      a, $67

SECTION "overwrite_left_status_1", ROM0[$2013]
        ld      a, $7f
SECTION "overwrite_left_status_2", ROM0[$2018]
        nop
SECTION "overwrite_left_status_3", ROM0[$1c2f]
        ld      a, $7f
SECTION "overwrite_left_status_4", ROM0[$1c34]
        nop

SECTION "overwrite_tile_loading_in_game", ROMX[$4153], BANK[6]
        call    tile_loading_in_game

SECTION "overwrite_status_bar", ROM0[$2033]
        call    my_status_bar

SECTION "overwrite_title_copyright", ROMX[$413a], BANK[3]
        ds      5, 0

SECTION "overwrite_title_hal_laboratory", ROMX[$4148], BANK[3]
        db      0
        db      "S" + $9e
        db      "T" + $9e
        db      "A" + $9f
        db      "G" + $9f
        db      "E" + $9f
        ;db      TILE_UP_DOWN_ARROWS
        ds      4, 0
        db      "R" + $9e
        db      "N" + $9f
        db      "G" + $9f
        ds      7, 0

SECTION "overwrite_title_nintendo", ROMX[$4165], BANK[3]
        ds      8, 0

SECTION "overwrite_ram_wipe", ROMX[$4ad6], BANK[5]
        call    ram_wipe

SECTION "overwrite_first_boot", ROM0[$0101]
        call    first_boot

SECTION "overwrite_num_lives", ROM0[$01ba]
        ld      a, 100

SECTION "overwrite_button_presses", ROMX[$4093], BANK[6]
        call    jump_main

SECTION "overwrite_tile_loading", ROMX[$4051], BANK[6]
        call    tile_loading

SECTION "code1", ROM0[$0000]
jump_main::
        ld      a, 1
        ld      [CUR_ROM_BANK], a
        ld      [SELECT_ROM_BANK], a
        call    main
        ld      a, 6
        ld      [CUR_ROM_BANK], a
        ld      [SELECT_ROM_BANK], a

        ; replace original instruction
        ld      a, [JOYPAD_1]
        ret

tile_array::
        db      TILE_0_IN_GAME+0
        db      TILE_0_IN_GAME+1
        db      TILE_0_IN_GAME+2
        db      TILE_0_IN_GAME+3
        db      TILE_0_IN_GAME+4
        db      TILE_0_IN_GAME+5
        db      TILE_0_IN_GAME+6
        db      TILE_0_IN_GAME+7
        db      TILE_0_IN_GAME+8
        db      TILE_0_IN_GAME+9
        db      TILE_A_IN_GAME
        db      TILE_B_IN_GAME
        db      TILE_C_IN_GAME
        db      TILE_D_IN_GAME
        db      TILE_E_IN_GAME
        db      TILE_F_IN_GAME


SECTION "code2", ROM0[$3dae]
digits:
        incbin  "gfx/digits.bin"
letters:
        incbin  "gfx/abcdef.bin", 0, 16*6
cur_version:
        incbin  "gfx/version_v10.2bpp"

first_boot::
        xor     a
        ld      [BUTTON_COUNTER], a
        ld      [UP_FLAG], a
        ld      [DOWN_FLAG], a
        ld      [JOYPAD_LAST], a
        ld      [JOYPAD_DELTA], a
        ld      [MY_CUR_STAGE], a
        ld      [CUR_SELECTION], a
        ld      [MY_SEED_1_HI], a
        ld      [MY_SEED_2_HI], a
        inc     a
        ld      [MY_SEED_1_LO], a
        inc     a
        ld      [MY_SEED_2_LO], a

        ; replace original instruction
        jp      $150
        ret

ram_wipe::
        ld      hl, $c000
        ld      b, start_of_variables-$c000
        xor     a
.loop
        ld      [hl+], a
        dec     b
        jr      nz, .loop

        ; replace original instruction
        ld      hl, end_of_variables
        jp      $4ad9
        ret

tile_loading_in_game::
        ; replace original instruction
        call    $4285

        ld      hl, letters
        ld      de, $96b0
        ld      b, 16*3
        call    copy8

        ld      hl, letters+16*3
        ld      de, $96b0+16*4
        ld      b, 16*3
        call    copy8

        ret

tile_loading::
        ; replace original instruction
        call    $20c1

.version
        ld      hl, cur_version
        ld      de, $8da0
        ld      b, 32
        call    copy8

        ld      hl, $9812
        ld      a, TILE_VERSION
        ld      [hl+], a
        inc     a
        ld      [hl], a

.cursor
        ld      hl, cursor
        ld      de, $8b80
        ld      b, $10
        call    copy8

        ld      c, 16
        ld      hl, digits
        ld      de, $8ba0
.loop
        ld      b, $10
        call    copy8
        ld      b, $10
        call    clear8
        dec     c
        jr      nz, .loop

        ret

my_status_bar::
.seed_1
        ld      d, 0
.seed_1_high_nibble
        ld      a, [SEED_1]
        swap    a
        and     $0f
        ld      e, a
        ld      hl, tile_array
        add     hl, de
        ld      a, [hl]
        ld      [$9c02], a
.seed_1_low_nibble
        ld      a, [SEED_1]
        and     $0f
        ld      e, a
        ld      hl, tile_array
        add     hl, de
        ld      a, [hl]
        ld      [$9c03], a
.seed_2
.seed_2_high_nibble
        ld      a, [SEED_2]
        swap    a
        and     $0f
        ld      e, a
        ld      hl, tile_array
        add     hl, de
        ld      a, [hl]
        ld      [$9c22], a
.seed_2_low_nibble
        ld      a, [SEED_2]
        and     $0f
        ld      e, a
        ld      hl, tile_array
        add     hl, de
        ld      a, [hl]
        ld      [$9c23], a

        ; replace original instruction
        ld      a, [$d086]
        ret

copy8::
        ld      a, [hl+]
        ld      [de], a
        inc     de
        dec     b
        jr      nz, copy8
        ret

clear8::
        xor     a
.loop
        ld      [de], a
        inc     de
        dec     b
        jr      nz, .loop
        ret

cursor:
        incbin  "gfx/cursor.2bpp"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SECTION "code3", ROMX[$5000], BANK[1]
main::
        ld      a, [JOYPAD_0]
        ld      c, a                    ; c = current joypad
        ld      a, [JOYPAD_LAST]
        and     c
        xor     c
        ld      [JOYPAD_DELTA], a
        ld      a, c
        ld      [JOYPAD_LAST], a
        call    check_left
        call    check_right
        call    check_down
        call    check_up
        call    update_seed
        ld      a, [MY_CUR_STAGE]
        ld      [CUR_LEVEL], a
        call    update_sprites
        ret

update_seed::
.seed_1
        ld      a, [MY_SEED_1_HI]
        swap    a
        ld      b, a
        ld      a, [MY_SEED_1_LO]
        or      b
        ld      [SEED_1], a
.seed_2
        ld      a, [MY_SEED_2_HI]
        swap    a
        ld      b, a
        ld      a, [MY_SEED_2_LO]
        or      b
        ld      [SEED_2], a
        ret

check_left::
        ld      a, [JOYPAD_0]
        bit     BIT_BUTTON_LEFT, a
        ret     z
        ld      a, [JOYPAD_DELTA]
        bit     BIT_BUTTON_LEFT, a
        ret     z
.pressed_left
        xor     a
        ld      [UP_FLAG], a
        ld      [DOWN_FLAG], a
        ld      a, [CUR_SELECTION]
        and     a
        jr      z, .go_back
.normal
        dec     a
        jr      .cont
.go_back
        ld      a, NUM_SELECTIONS-1
.cont
        ld      [CUR_SELECTION], a
        ret

check_right::
        ld      a, [JOYPAD_0]
        bit     BIT_BUTTON_RIGHT, a
        ret     z
        ld      a, [JOYPAD_DELTA]
        bit     BIT_BUTTON_RIGHT, a
        ret     z
.pressed_right
        xor     a
        ld      [UP_FLAG], a
        ld      [DOWN_FLAG], a
        ld      a, [CUR_SELECTION]
        inc     a
        cp      NUM_SELECTIONS
        jr      nz, .cont
.go_back
        xor     a
.cont
        ld      [CUR_SELECTION], a
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_up::
        ld      a, [JOYPAD_0]
        bit     BIT_BUTTON_UP, a
        jr      z, .no_up
        ld      a, [JOYPAD_DELTA]
        bit     BIT_BUTTON_UP, a
        jr      z, .no_new_up
.new_up
        ld      a, BUTTON_FRAMES_1
        ld      [BUTTON_COUNTER], a
        ld      [UP_FLAG], a
        jr      process_up
.no_new_up
        ld      a, [UP_FLAG]
        and     a
        jr      nz, .have_up_flag
.no_up_flag
        ld      a, [BUTTON_COUNTER]
        and     a
        jr      z, .set_up_flag
        ret
.set_up_flag
        ld      a, 1
        ld      [UP_FLAG], a
        ld      a, BUTTON_FRAMES_2
        ld      [BUTTON_COUNTER], a
        ret
.have_up_flag
        ld      a, [BUTTON_COUNTER]
        and     a
        jr      z, .reset_counter
.decrement_counter
        dec     a
        ld      [BUTTON_COUNTER], a
        ret
.reset_counter
        ld      a, BUTTON_FRAMES_2
        ld      [BUTTON_COUNTER], a
        call    process_up
.no_up
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_down::
        ld      a, [JOYPAD_0]
        bit     BIT_BUTTON_DOWN, a
        jr      z, .no_down
        ld      a, [JOYPAD_DELTA]
        bit     BIT_BUTTON_DOWN, a
        jr      z, .no_new_down
.new_down
        ld      a, BUTTON_FRAMES_1
        ld      [BUTTON_COUNTER], a
        ld      [DOWN_FLAG], a
        jr      process_down
.no_new_down
        ld      a, [DOWN_FLAG]
        and     a
        jr      nz, .have_down_flag
.no_down_flag
        ld      a, [BUTTON_COUNTER]
        and     a
        jr      z, .set_down_flag
        ret
.set_down_flag
        ld      a, 1
        ld      [DOWN_FLAG], a
        ld      a, BUTTON_FRAMES_2
        ld      [BUTTON_COUNTER], a
        ret
.have_down_flag
        ld      a, [BUTTON_COUNTER]
        and     a
        jr      z, .reset_counter
.decrement_counter
        dec     a
        ld      [BUTTON_COUNTER], a
        ret
.reset_counter
        ld      a, BUTTON_FRAMES_2
        ld      [BUTTON_COUNTER], a
        call    process_down
.no_down
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

process_up::
        ld      a, [CUR_SELECTION]
        and     a
        jp      z, stage_down
        dec     a
        jp      z, seed_1_hi_up
        dec     a
        jp      z, seed_1_lo_up
        dec     a
        jp      z, seed_2_hi_up
        dec     a
        jp      z, seed_2_lo_up
        ret

process_down::
        ld      a, [CUR_SELECTION]
        and     a
        jp      z, stage_up
        dec     a
        jp      z, seed_1_hi_down
        dec     a
        jp      z, seed_1_lo_down
        dec     a
        jp      z, seed_2_hi_down
        dec     a
        jp      z, seed_2_lo_down
        ret

stage_down::
        ld      a, [MY_CUR_STAGE]
        inc     a
        cp      5
        jr      nz, .finish_down
.back_up
        xor     a
.finish_down
        ld      [MY_CUR_STAGE], a
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
seed_1_hi_up::
        ld      a, [MY_SEED_1_HI]
        inc     a
        cp      16
        jr      nz, .finish
.back
        xor     a
.finish
        ld      [MY_SEED_1_HI], a
        ret

seed_1_lo_up::
        ld      a, [MY_SEED_1_LO]
        inc     a
        cp      16
        jr      nz, .finish
.back
        xor     a
.finish
        ld      [MY_SEED_1_LO], a
        ret

seed_2_hi_up::
        ld      a, [MY_SEED_2_HI]
        inc     a
        cp      16
        jr      nz, .finish
.back
        xor     a
.finish
        ld      [MY_SEED_2_HI], a
        ret

seed_2_lo_up::
        ld      a, [MY_SEED_2_LO]
        inc     a
        cp      16
        jr      nz, .finish
.back
        xor     a
.finish
        ld      [MY_SEED_2_LO], a
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
seed_1_hi_down::
        ld      a, [MY_SEED_1_HI]
        and     a
        jr      nz, .normal
.back
        ld      a, 15
        jr      .finish
.normal
        dec     a
.finish
        ld      [MY_SEED_1_HI], a
        ret

seed_1_lo_down::
        ld      a, [MY_SEED_1_LO]
        and     a
        jr      nz, .normal
.back
        ld      a, 15
        jr      .finish
.normal
        dec     a
.finish
        ld      [MY_SEED_1_LO], a
        ret

seed_2_hi_down::
        ld      a, [MY_SEED_2_HI]
        and     a
        jr      nz, .normal
.back
        ld      a, 15
        jr      .finish
.normal
        dec     a
.finish
        ld      [MY_SEED_2_HI], a
        ret

seed_2_lo_down::
        ld      a, [MY_SEED_2_LO]
        and     a
        jr      nz, .normal
.back
        ld      a, 15
        jr      .finish
.normal
        dec     a
.finish
        ld      [MY_SEED_2_LO], a
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

stage_up::
        ld      a, [MY_CUR_STAGE]
        and     a
        jr      z, .back_down
        dec     a
        jr      .finish_up
.back_down
        ld      a, 4
.finish_up
        ld      [MY_CUR_STAGE], a
        ret

update_sprites::
        xor     a
        ld      [SPRITE_BUFFER+$80+4*0+3], a
        ld      [SPRITE_BUFFER+$80+4*1+3], a
        ld      [SPRITE_BUFFER+$80+4*2+3], a
        ld      [SPRITE_BUFFER+$80+4*3+3], a
        ld      [SPRITE_BUFFER+$80+4*4+3], a
        ld      [SPRITE_BUFFER+$80+4*5+3], a
        ld      a, $90
        ld      [SPRITE_BUFFER+$80+4*0+0], a
        ld      [SPRITE_BUFFER+$80+4*2+0], a
        ld      [SPRITE_BUFFER+$80+4*3+0], a
        ld      [SPRITE_BUFFER+$80+4*4+0], a
        ld      [SPRITE_BUFFER+$80+4*5+0], a
.stage
        ld      a, $40
        ld      [SPRITE_BUFFER+$80+4*0+1], a
        ld      a, [CUR_LEVEL]
        sla     a
        add     TILE_1
        ld      [SPRITE_BUFFER+$80+4*0+2], a
.cursor
        ld      a, $98
        ld      [SPRITE_BUFFER+$80+4*1+0], a
        ld      d, 0
        ld      a, [CUR_SELECTION]
        ld      e, a
        ld      hl, cursor_array
        add     hl, de
        ld      a, [hl]
        ld      [SPRITE_BUFFER+$80+4*1+1], a
        ld      a, TILE_CURSOR
        ld      [SPRITE_BUFFER+$80+4*1+2], a
.seed_1_high
        ld      a, $78
        ld      [SPRITE_BUFFER+$80+4*2+1], a
        ld      a, [MY_SEED_1_HI]
        sla     a
        add     TILE_0
        ld      [SPRITE_BUFFER+$80+4*2+2], a
.seed_1_low
        ld      a, $80
        ld      [SPRITE_BUFFER+$80+4*3+1], a
        ld      a, [MY_SEED_1_LO]
        sla     a
        add     TILE_0
        ld      [SPRITE_BUFFER+$80+4*3+2], a
.seed_2_high
        ld      a, $90
        ld      [SPRITE_BUFFER+$80+4*4+1], a
        ld      a, [MY_SEED_2_HI]
        sla     a
        add     TILE_0
        ld      [SPRITE_BUFFER+$80+4*4+2], a
.seed_2_low
        ld      a, $98
        ld      [SPRITE_BUFFER+$80+4*5+1], a
        ld      a, [MY_SEED_2_LO]
        sla     a
        add     TILE_0
        ld      [SPRITE_BUFFER+$80+4*5+2], a
        ret

cursor_array:
        db      $40, $78, $80, $90, $98


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SECTION "variables", WRAM0[$c0a0]
start_of_variables:
JOYPAD_LAST:            db
JOYPAD_DELTA:           db
MY_CUR_STAGE:           db
CUR_SELECTION:          db
MY_SEED_1_HI:           db
MY_SEED_1_LO:           db
MY_SEED_2_HI:           db
MY_SEED_2_LO:           db
BUTTON_COUNTER:         db
UP_FLAG:                db
DOWN_FLAG:              db
end_of_variables:
