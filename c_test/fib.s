init:
    add t0, zero, zero
    addi t1, zero, 1

start:
    add t2, t1, t0
    add t0, zero, t1
    add t1, zero, t2
    jal zero, start
