lui t0, 0x5
sw t0, 0x200(zero)
nop
nop
nop
lw t1, 0x200(zero)
stall:
jal zero, stall
