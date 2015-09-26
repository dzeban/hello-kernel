global start                    ; the entry symbol for ELF

MAGIC_NUMBER equ 0x1BADB002     ; define the magic number constant
FLAGS        equ 0x0            ; multiboot flags
CHECKSUM     equ -MAGIC_NUMBER  ; calculate the checksum
                                ; (magic number + checksum + flags should equal 0)

section .text:                  ; start of the text (code) section
align 4                         ; the code must be 4 byte aligned
    dd MAGIC_NUMBER             ; write the magic number to the machine code,
    dd FLAGS                    ; the flags,
    dd CHECKSUM                 ; and the checksum

start:                          ; the loader label (defined as entry point in linker script)
	mov ebx, 0xb8000 ; VGA area base
	mov ecx, 80*25 ; console size

	; Clear screen
	mov edx, 0x0020;  space symbol (0x20) on black background
clear_loop:
	mov [ebx + ecx], edx
	dec ecx
	cmp ecx, -1
	jnz clear_loop
	
	; Print red 'A'
	mov eax, ( 4 << 8 | 0x41) ; 'A' symbol (0x41) print in red (0x4)
	mov [ebx], eax

.loop:
    jmp .loop                   ; loop forever
