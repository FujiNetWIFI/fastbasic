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


; INPUT string
; ------------

        .export EXE_INPUT_STR

        ; From runtime.asm
        .importzp       IOCHN, IOERROR

        ; From interpreter.asm
        .import         pushAX
        .importzp       next_instruction

        .include "atari.inc"

        .segment        "RUNTIME"

line_buf        = LBUFF

.proc   EXE_INPUT_STR   ; INPUT to string buffer (INBUFF)
        jsr     pushAX
        ldx     IOCHN

        lda     #>line_buf
        sta     ICBAH, x
.assert (>line_buf) = GETREC, error, "invalid optimization"
        ;lda     #GETREC
        sta     ICCOM, x
        lda     #<line_buf
        sta     ICBAL, x
.assert (<line_buf) = $80, error, "invalid optimization"
        ;lda     #$80
        sta     ICBLL, x
        lda     #0
        sta     ICBLH, x
        jsr     CIOV
        lda     ICBLL, x

        sty     IOERROR
        sta     line_buf - 1    ; Assume that this location is available
        beq     no_eol  ; EOF
        cpy     #$88
        beq     no_eol
        tya
        bmi     no_eol  ; TODO: ERROR!?
        dec     line_buf - 1
no_eol:
        lda     #<(line_buf-1)
        ldx     #>(line_buf-1)
        jmp     next_instruction
.endproc

; vi:syntax=asm_ca65