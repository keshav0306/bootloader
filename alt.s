BITS 16
org 0x7c00

; jumping to the main function is the first instruction in the bootloader code
; the 85 times 0 represents the fat32 bootloader metadata segment which
; the actual machine modifies a bit, but the qemu vm doesnt act upon it

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

; lets try to read from a storage device
; bios has 0x13 call for that and dl register contains the drive number

read:
    mov ah, 0x02    ; function for the bios call
    mov al, 0x02    ; number of sectors to read
    mov ch, 0x00    ; addressing scheme -> cylinder
    mov cl, 0x02    ; addressing scheme -> sector
    mov dh, 0x00    ; addressing scheme -> head
    mov bx, 0x7E00  ; ES:BX contains the buffer pointer (ES is init to 0 in the beginning)
    int 0x13
    jnc .after
    mov si, error
    ;call print
    ret
.after:
    ret



; number of sectors : ax
; starting of disk sector (zero indexing) : bx
; where to load : cx

read_ext:
    push bx

    mov bx, 0x7000

    ; 1 byte size of dap = 16
    mov byte [bx], 16

    ; 1 byte reserved
    inc bx
    mov byte [bx], 0

    ; 2 bytes number of sectors
    inc bx
    ;mov word [bx], 2
    mov word [bx], ax

    ;2 bytes offset
    add bx, 2
    ;mov word [bx], 0x7e00
    mov word [bx], cx

    ; 2 bytes segment
    add bx, 2
    mov word [bx], 0

    pop ax
    ; 8 bytes for lba
    add bx, 2
    ;mov word [bx], 1
    mov word [bx], ax
    add bx, 2
    mov word [bx], 0
    add bx, 2
    mov word [bx], 0
    add bx, 2
    mov word [bx], 0

    mov ah, 0x42    ; function for the bios call
    mov si, 0x7000
    int 0x13
    jnc .after_ext
    mov si, error
    call print
    ret
.after_ext:
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
    ; the stack grows upward starting from the lowest address set to 0xFFFF
    mov sp, 0xFFFF

    mov ax, 1
    mov bx, 1
    mov cx, 0x7e00
    call read_ext
    
    mov si, text
    call print
    ;mov ax, 16
    ;mov ss, ax

    call parse_elf

    hlt         ; halts the cpu till an interrupt ?
    mov ax, 16
    mov ss, ax
    cli

    lgdt [gdt_desc] ; square brackets means the address of the val inside the brackets

    mov eax, cr0
    or eax, 1
    mov cr0, eax
    ;call infinity

    ; the start address, to be changed here if the kernel is to be loaded at a different address
    jmp 8:0x1000


text db "hi there"
db 0

parse_elf:
    ; the elf file is loaded at 0x7e00
    ; store the number of phdrs and the phdr offset

    mov bx, 0x7e00
    add bx, 28 ; phdr offset in file
    mov eax, dword [bx]
    add eax, 0x7e00 

    mov ecx, dword [0x7e2c] ; offset of 44
    ; ecx contains the number of program headers
    ; mov ecx, 1

elf_rep:
    cmp cx, 0
    je .loaded
    dec cx
    push eax
    push cx

    ; eax contains the address of the current program header
    ; now load the program header 
    ; (assume for now that only 2 program headers exist
    ; one for code and other for data), to change later

    mov ebx, dword [eax + 4]

    ; ebx contains the file offset of the first segment to be loaded
    ; before calling the bios call
    ; ebx should contain 1 + ebx / 512
    ; assume 512 byte-aligned
    ; use the div instruction

    push eax
    push ebx
    push ecx
    push edx

    mov eax, ebx
    mov ecx, 512
    div ecx
    ; ax contains the quotient and dx contains the remainder
    inc ax
    
    pop edx
    pop ecx
    pop ebx
    mov ebx, eax    ; ebx containing right data
    pop eax

    mov ecx, dword [eax + 8] ; ecx containing right data

    push ecx
    push edx
    push ebx
    push eax

    mov eax, dword [eax + 20]
    mov ecx, 512
    div ecx
    inc ax

    pop ebx ; cant pop into eax, as eax now contains right data
    pop ebx
    pop edx
    pop ecx

    ; For read_ext
    ; number of sectors : ax
    ; starting of disk sector (zero indexing) : bx
    ; where to load : cx

    call read_ext

    pop cx
    pop eax
    add eax, 32
    
    jmp elf_rep
    
.loaded:
    mov si, text
    call print
    ret

; the gdt begins here

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
; for 32 bit code from here
; since 32-bit protected bit mode is enabled

; let the second sector begin

;mov al, 'K'
;mov ah, 0x0a
;mov [0xb8000], ax