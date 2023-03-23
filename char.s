BITS 16
org 0x7c00

jmp main
times 85 db 0x0000

; lodsb loads byte at ds:[si] to al register and increments si based on df flag
; hence put the address of the text to si before calling the function

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

; lets try to read from a stroage device
; bios has 0x13 call for that and dl register contains the drive number

read:
    mov ah, 0x02
    mov al, 0x01
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    mov bx, 0x7E00
    int 0x13
    jnc .after
    mov si, error
    ;call print
    ret
.after:
    ret

write:
    mov ah, 0x03
    mov al, 0x01
    mov ch, 0x00
    mov cl, 0x01
    mov dh, 0x00
    mov bx, 0x7E00
    int 0x13
    jnc .next
    mov si, error
    call print
    ret
.next:
    ret

infinity:
    jmp infinity

main:
    mov ax, 0
    ; cant move a constant to a segment register, owing to the design of the x86 machine
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xFFFF

    call read
    mov si, text
    call print

    
    cli
    lgdt [gdt_desc] ; square brackets means the address of the val inside the brackets

    mov eax, cr0
    or eax, 1
    mov cr0, eax
    
    jmp 8:0x7E00
    call infinity


text db "hi there"

gdt:
    ;null segment
    dd 0
    dd 0

code_seg:
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10011010b ;change later prsent, privelege and type
    db 11001111b ; others + limit
    db 0x00

data_seg:
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10010000b ;change later prsent, privelege and type 
    db 11001111b ; others + limit
    db 0x00
gdt_end:

gdt_desc :
    dw gdt_end - gdt - 1
    dd gdt



db 0
error db "konoha"
times 510-($-$$) db 0   ; Pad remainder of boot sector with 0s
dw 0xAA55
[bits 32]
amain:
    ;jmp amain
    mov ax, $16
    ;mov ss, ax
    ;mov es, ax
    ;mov ds, ax
    ;mov ss, ax
    ;mov ds, ax
    mov al, 'K'
    mov ah, 0x0a
    mov [0xb8000], ax

    mov ebx, 0
    mov ecx, 0

looping:
    cmp bl, 0xFF
    je .outside
    mov cl, 0x3
inner_loop:
    cmp cl, 0x20
    je .jumptop

    mov eax, 0x80000000

    mov edx, ebx
    shl edx, 16
    or eax, edx

    mov edx, ecx
    shl edx, 11
    or eax, edx

    mov dx, 0x0CF8
    out dx, eax
    mov dx, 0x0CFC
    in eax, dx
    cmp ax, 0xFFFF

    je .haiku
    ;mov eax, 0xFFFFFFFF
    ;out dx, eax
    in eax, dx
    ;shr eax, 16
    call print_word
    mov al, 'K'
    mov ah, 0x0a
    mov [0xb8002], ax
    hlt

.haiku:
    inc ecx
    jmp inner_loop


.jumptop:
    inc ebx
    jmp looping

looping.outside:
    mov al, 'K'
    mov ah, 0x0a
    mov [0xb8004], ax
    hlt

dataing db "data"

aprint:
.aloop:
    lodsb
    cmp al, 0
    je .aout             ; check for null byte
    mov ah, 0x0E        ; teletype mode
    mov bh, 0           ; page = 0
    mov bl, 0x00        ; color in graphics mode

    ;int 0x10            ; bios int call for printing onto the screen
    jmp .aloop

.aout:
    ret
print_word:
    mov edx, 0
    mov ebx, 0
    mov ebx, 0xb8000
    mov dx, ax
    mov edi, edx
    mov ecx, 0x0000000F
again:
    cmp ecx, 0xFFFFFFFF
    je .out_again
    mov esi , 1
    shl esi, cl
    and edi, esi
    add ebx, 2
    cmp edi, 0
    je zero
    mov al, '1'
    mov ah, 0x0a
    mov [ebx], ax
    mov edi, edx
    dec ecx
    jmp again
zero:
    mov al, '0'
    mov ah, 0x0a
    mov [ebx], ax
    mov edi, edx
    dec ecx
    jmp again

again.out_again:
    hlt

atext db "second sector"