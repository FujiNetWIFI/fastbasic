;
; FastBasic - Fast basic interpreter for the Atari 8-bit computers
; Copyright (C) 2017,2018 Daniel Serpell
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License along
; with this program.  If not, see <http://www.gnu.org/licenses/>
;
; In addition to the permissions in the GNU General Public License, the
; authors give you unlimited permission to link the compiled version of
; this file into combinations with other programs, and to distribute those
; combinations without any restriction coming from the use of this file.
; (The General Public License restrictions do apply in other respects; for
; example, they cover modification of the file, and distribution when not
; linked into a combine executable.)


; Boolean constants and conversion
; --------------------------------

        .export EXE_COMP_0, EXE_1, EXE_0

        ; From interpreter.asm
        .import         pushAX
        .importzp       next_instruction

        .segment        "RUNTIME"

.proc   EXE_1
        jsr     pushAX
ret_1:  lda     #1
ret_0:  ldx     #0
        jmp     next_instruction
.endproc

.proc   EXE_0
        jsr     pushAX
        lda     #0
        beq     EXE_1::ret_0
.endproc

.proc   EXE_COMP_0  ; AX = AX != 0
        tay
        bne     EXE_1::ret_1
        txa
        bne     EXE_1::ret_1
        jmp     next_instruction
.endproc

; vi:syntax=asm_ca65