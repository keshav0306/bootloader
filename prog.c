int a = 0xb;

int fun(){
    int b = 8;
    char * addr = 0xb8000;
    *(addr) = 'T';
    *(addr + 1) = a;
    a++;
    a %= 15;
}

int r(){
    char * addr = 0xb8000;
    *(addr) = 'Q';
    *(addr + 1) = 0x06;
    a++;
    a %= 15;
    asm volatile("hlt");
}