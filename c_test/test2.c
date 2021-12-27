void _start() {
    unsigned x = 0xDEADC0DE;
    unsigned y = 0xDEADBEEF;
    *(unsigned*)0x500 = x + y; 
}
