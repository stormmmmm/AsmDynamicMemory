
.model small
stack 100h

MALLOC_ID   = 00000001h

_char       equ         1
_short      equ         2
_word       equ         2
_int        equ         4
_dword      equ         4
_df         equ         6
_long       equ         8
_dt         equ         10
_fpu        equ         10

.code

__setname   macro       mid, type_, val
            __malloc_&mid&  type_  val
            mov         ax, offset __malloc_&mid&
            endm

movstack    macro
            push        bp
            mov         bp, sp
            endm
           
popstack    macro
            pop         bp
            endm
            
param       macro       name, num
            &name&      equ        [bp+4+2*num]
            endm

malloc      proc
            param       blocksize, 0
            movstack
            push        cx
            mov         cx, blocksize
            cmp         cx, 1
            je          equal_1
            cmp         cx, 2
            je          equal_2
            cmp         cx, 4
            je          equal_4
            cmp         cx, 6
            je          equal_6
            cmp         cx, 8
            je          equal_8
            cmp         cx, 10
            je          equal_10
            jmp         short equal_2
            endcmp:
            pop         cx
            MALLOC_ID   = MALLOC_ID + 6
            popstack
            ret         2
            
            equal_1:
            __setname   %MALLOC_ID, db, ?
            jmp         short endcmp
            equal_2:
            __setname   %MALLOC_ID+1, dw, ?
            jmp         short endcmp
            equal_4:
            __setname   %MALLOC_ID+2, dd, ?
            jmp         short endcmp
            equal_6:
            __setname   %MALLOC_ID+3, df, ?
            jmp         short endcmp
            equal_8:
            __setname   %MALLOC_ID+4, dq, ?
            jmp         short endcmp
            equal_10:
            __setname   %MALLOC_ID+5, dt, ?
            jmp         short endcmp
            
            endp

start:
    ; выделить 2 байта:
    push    2
    call    malloc
    ; и самое главное - не нужна функция освобождения памяти, ибо все реализовано на основе стека!
.data

end start
