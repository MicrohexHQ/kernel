;This file initializes the stack the kernel will use, and calls “kmain,” which is a function defined in a C file.

global loader                           ;Making the entry point visible to the linker.
extern kmain                            ;Kernal main is defined in kmain.cpp

; Setting up the Multiboot header - see GRUB docs for details.

MODULEALIGN equ 1 << 0                  ;Align loaded modules on page boundaries.
MEMINFO     equ 1 << 1                  ;Provide memory map.
FLAGS       equ MODULEALIGN | MEMINFO   ;This is the multiboot flag field.
MAGIC       equ 0x1badb002              ;'Magic number' lets the bootloader find the header.
CHECKSUM    equ -(MAGIC + FLAGS)        ;Checksum required.

section .text
align 4
MultiBootHeader:
    dd Magic                            ;Double define word.
    dd FLAGS
    dd CHECKSUM

;Reserve initial kernel stack space.

STACKSIZE equ 0x4000

loader:
    mov esp, stack + STACKSIZE          ;Set up the stack
    push eax                            ;Multiboot magic number
    push ebx                            ;Multiboot info structure

    call kmain                          ; Call kernel.

    cli

;Hang the machine if the kernel returns
hang:
    hlt
    jmp hang

section .bss
align 4
stack:                                  ;Reserve 16k stack on a doubleword boundary.
    resb STACKSIZE

