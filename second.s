BITS 16
org 0x7E00
main:
    mov ax, 0
    mov ds, ax

    mov si, text
    call print
    hlt

print:
.loop:
    lodsb
    cmp al, 0
    je .out             ; check for null byte
    mov ah, 0x0E        ; teletype mode
    mov bh, 0           ; page = 0
    mov bl, 0x00        ; color in graphics mode

    int 0x10            ; bios int call for printing onto the screen
    jmp .loop

.out:
    ret

text db "second sector"