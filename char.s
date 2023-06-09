BITS 16
org 0x7c00

<<<<<<< HEAD
; jumping to the main function is the first instruction in the bootloader code
; the 85 times 0 represents the fat32 bootloader metadata segment which
; the actual machine modifies a bit, but the qemu vm doesnt act upon it

=======
>>>>>>> c35949d32abc692c093553db3a95fdebbdd62f61
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

<<<<<<< HEAD
; lets try to read from a storage device
; bios has 0x13 call for that and dl register contains the drive number

read:
    mov ah, 0x02    ; function for the bios call
    mov al, 0x02    ; number of sectors to read
    mov ch, 0x00    ; addressing scheme -> cylinder
    mov cl, 0x02    ; addressing scheme -> sector
    mov dh, 0x00    ; addressing scheme -> head
    mov bx, 0x7E00  ; ES:BX contains the buffer pointer (ES is init to 0 in the beginning)
=======
; lets try to read from a stroage device
; bios has 0x13 call for that and dl register contains the drive number

read:
    mov ah, 0x02
    mov al, 0x01
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    mov bx, 0x7E00
>>>>>>> c35949d32abc692c093553db3a95fdebbdd62f61
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
<<<<<<< HEAD
    ;mov eax, 0x10000000
=======
>>>>>>> c35949d32abc692c093553db3a95fdebbdd62f61
    mov ax, 0
    ; cant move a constant to a segment register, owing to the design of the x86 machine
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xFFFF
<<<<<<< HEAD
    call read
    mov si, text
    call print
    ;hlt         ; halts the cpu till an interrupt ?
    ;mov ax, 16
    ;mov ss, ax
    ;cli
=======

    call read
    mov si, text
    call print

    
    cli
>>>>>>> c35949d32abc692c093553db3a95fdebbdd62f61
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
<<<<<<< HEAD
    mov eax, 0x80000006
    mov ecx, 0
    cpuid
    mov eax, ecx
    call print_word
    cli
    hlt
    ;test ebx, (1 << 24)
    jz noo
    hlt
noo:
    ;jmp amain
    mov ax, 16
    ;mov ss, ax
    ;mov bx, ds
    mov es, ax
    mov ds, ax

    mov al, 'K'
    mov ah, 0x0a
    mov [0xb8000], ax
    ;hlt
   
=======
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

>>>>>>> c35949d32abc692c093553db3a95fdebbdd62f61
    mov ebx, 0
    mov ecx, 0

looping:
    cmp bl, 0xFF
    je .outside
<<<<<<< HEAD
    mov cl, 0x6
=======
    mov cl, 0x3
>>>>>>> c35949d32abc692c093553db3a95fdebbdd62f61
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

<<<<<<< HEAD
=======

>>>>>>> c35949d32abc692c093553db3a95fdebbdd62f61
.jumptop:
    inc ebx
    jmp looping

looping.outside:
<<<<<<< HEAD
    call fun
    mov al, 'Q'
    mov ah, 0x0a
    mov [0xb8006], ax
    jmp look_for_ebda

fun:
    mov eax, esp
    call print_word
    mov al, 'H'
    mov ah, 0x0a
    mov [0xb8004], ax
    ret

=======
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
>>>>>>> c35949d32abc692c093553db3a95fdebbdd62f61
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
<<<<<<< HEAD
    ret

times 4 db 0

look_for_ebda:
    ; search for the pointer to the ebda at 0x40E
    ;mov ax, [0x40E]
    mov ebx, 0
    mov eax, 0xE0000
    mov ebx, eax
    ;shl ebx, 4
    ;mov ecx, ebx
    ;add ecx, 0x10000000
    ;mov edx, 0x50445352
    ;mov dword [ecx], edx

come_again:
    mov ecx, 0x20445352
    cmp dword [ebx], ecx
    je found
    add ebx, 4
    jmp come_again


found:
    add ebx, 4
    mov eax, dword [ebx]
    shr eax, 16
    call print_word
=======
>>>>>>> c35949d32abc692c093553db3a95fdebbdd62f61
    hlt

atext db "second sector"