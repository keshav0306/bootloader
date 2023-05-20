nasm -f bin alt.s
x86_64-elf-gcc video.c -m32 -c
x86_64-elf-ld -m elf_i386 -T ls.ld video.o -o prog
#x86_64-elf-objcopy -O binary --only-section=.text prog foobar.text
cat prog >> alt
