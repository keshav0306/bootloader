int a = 7;

int fun(){
    char * addr = 0xb8000;
    *(addr) = 'T';
    *(addr + 1) = a;
    char b = *(addr);
    *(addr + 2) = b;
    *(addr + 3) = ++a;
    for(;;){
        *(addr) = 'T';
        *(addr + 1) = a;
        addr += 2;
    }
    asm volatile("hlt");
}
