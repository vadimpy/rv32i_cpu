typedef struct {
    int div;
    int mod;
} div_res_t;

div_res_t div(int a, int b) {
    int i;
    for (i = 0; a > b; ++i)
        a -= b;
    div_res_t res = {i, a};
}

int mul(int a, int b) {
    int m = 0;
    for (; b >= 0; --b)
        m += a;
    return a;
}

void print(unsigned a) {
    *(unsigned*)0x7000 = a;
}

void _start() {
    int x = 16;
    int y = 5;
    int z = mul(x, y);
    div_res_t p = div(x, y);
    print(p.mod);
}
