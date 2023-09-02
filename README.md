# bootloader

This contatins the bootlader assembly file
alt.s
and other relevant files for booting from a x86 platform. The kernel is assumed to be present at the 513th byte from the start containing the
standard ELF file. The bootloader loads the kernel at a set address hardcoded currently in alt.s file.

Use the following to get the raw machine code from a gcc compiled file 
x86_64-elf-objcopy -O binary --only-section=.text prog.o foobar.text
