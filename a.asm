; Disassembly of file: a.o
; Fri Mar 31 21:48:02 2023
; Type: ELF64
; Syntax: NASM
; Instruction set: Pentium Pro, x64

default rel

global load_kernel: function

extern read                                             ; near


SECTION .text   align=1 exec                            ; section number 1, code

load_kernel:; Function begin
        push    rbp                                     ; 0000 _ 55
        mov     rbp, rsp                                ; 0001 _ 48: 89. E5
        sub     rsp, 64                                 ; 0004 _ 48: 83. EC, 40
        mov     qword [rbp-10H], 1048576                ; 0008 _ 48: C7. 45, F0, 00100000
        mov     rax, qword [rbp-10H]                    ; 0010 _ 48: 8B. 45, F0
        movzx   eax, byte [rax+1H]                      ; 0014 _ 0F B6. 40, 01
        cmp     al, 69                                  ; 0018 _ 3C, 45
        jz      ?_001                                   ; 001A _ 74, 0C
        mov     rax, qword [rbp-10H]                    ; 001C _ 48: 8B. 45, F0
        movzx   eax, byte [rax+2H]                      ; 0020 _ 0F B6. 40, 02
        cmp     al, 76                                  ; 0024 _ 3C, 4C
        jnz     ?_002                                   ; 0026 _ 75, 0C
?_001:  mov     rax, qword [rbp-10H]                    ; 0028 _ 48: 8B. 45, F0
        movzx   eax, byte [rax+3H]                      ; 002C _ 0F B6. 40, 03
        cmp     al, 70                                  ; 0030 _ 3C, 46
        jz      ?_003                                   ; 0032 _ 74, 0A
?_002:  mov     eax, 0                                  ; 0034 _ B8, 00000000
        jmp     ?_007                                   ; 0039 _ E9, 000000AF

?_003:  mov     rax, qword [rbp-10H]                    ; 003E _ 48: 8B. 45, F0
        movzx   eax, word [rax+2CH]                     ; 0042 _ 0F B7. 40, 2C
        cwde                                            ; 0046 _ 98
        mov     dword [rbp-14H], eax                    ; 0047 _ 89. 45, EC
        mov     dword [rbp-4H], 0                       ; 004A _ C7. 45, FC, 00000000
        jmp     ?_006                                   ; 0051 _ E9, 0000008B

?_004:  mov     rax, qword [rbp-10H]                    ; 0056 _ 48: 8B. 45, F0
        mov     eax, dword [rax+1CH]                    ; 005A _ 8B. 40, 1C
        add     eax, 1048576                            ; 005D _ 05, 00100000
        cdqe                                            ; 0062 _ 48: 98
        mov     edx, dword [rbp-4H]                     ; 0064 _ 8B. 55, FC
        movsxd  rdx, edx                                ; 0067 _ 48: 63. D2
        shl     rdx, 5                                  ; 006A _ 48: C1. E2, 05
        add     rax, rdx                                ; 006E _ 48: 01. D0
        mov     qword [rbp-20H], rax                    ; 0071 _ 48: 89. 45, E0
        mov     rax, qword [rbp-20H]                    ; 0075 _ 48: 8B. 45, E0
        mov     eax, dword [rax+8H]                     ; 0079 _ 8B. 40, 08
        cdqe                                            ; 007C _ 48: 98
        mov     qword [rbp-28H], rax                    ; 007E _ 48: 89. 45, D8
        mov     rax, qword [rbp-20H]                    ; 0082 _ 48: 8B. 45, E0
        mov     eax, dword [rax+4H]                     ; 0086 _ 8B. 40, 04
        add     eax, 512                                ; 0089 _ 05, 00000200
        cdqe                                            ; 008E _ 48: 98
        mov     qword [rbp-30H], rax                    ; 0090 _ 48: 89. 45, D0
        mov     rax, qword [rbp-20H]                    ; 0094 _ 48: 8B. 45, E0
        mov     eax, dword [rax+10H]                    ; 0098 _ 8B. 40, 10
        mov     dword [rbp-34H], eax                    ; 009B _ 89. 45, CC
        mov     eax, dword [rbp-34H]                    ; 009E _ 8B. 45, CC
        lea     edx, [rax+1FFH]                         ; 00A1 _ 8D. 90, 000001FF
        test    eax, eax                                ; 00A7 _ 85. C0
        cmovs   eax, edx                                ; 00A9 _ 0F 48. C2
        sar     eax, 9                                  ; 00AC _ C1. F8, 09
        mov     dword [rbp-38H], eax                    ; 00AF _ 89. 45, C8
        mov     eax, dword [rbp-34H]                    ; 00B2 _ 8B. 45, CC
        and     eax, 1FFH                               ; 00B5 _ 25, 000001FF
        test    eax, eax                                ; 00BA _ 85. C0
        jz      ?_005                                   ; 00BC _ 74, 04
        add     dword [rbp-38H], 1                      ; 00BE _ 83. 45, C8, 01
?_005:  mov     edx, dword [rbp-34H]                    ; 00C2 _ 8B. 55, CC
        mov     rcx, qword [rbp-30H]                    ; 00C5 _ 48: 8B. 4D, D0
        mov     rax, qword [rbp-28H]                    ; 00C9 _ 48: 8B. 45, D8
        mov     rsi, rcx                                ; 00CD _ 48: 89. CE
        mov     rdi, rax                                ; 00D0 _ 48: 89. C7
        mov     eax, 0                                  ; 00D3 _ B8, 00000000
        call    read                                    ; 00D8 _ E8, 00000000(PLT r)
        add     dword [rbp-4H], 1                       ; 00DD _ 83. 45, FC, 01
?_006:  mov     eax, dword [rbp-4H]                     ; 00E1 _ 8B. 45, FC
        cmp     eax, dword [rbp-14H]                    ; 00E4 _ 3B. 45, EC
        jl      ?_004                                   ; 00E7 _ 0F 8C, FFFFFF69
?_007:  leave                                           ; 00ED _ C9
        ret                                             ; 00EE _ C3
; load_kernel End of function


SECTION .data   align=1 noexec                          ; section number 2, data


SECTION .bss    align=1 noexec                          ; section number 3, bss


