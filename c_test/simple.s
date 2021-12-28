loop_start: addi t0, zero, 10
            addi t0, t0, 5
            addi t0, t0, -1
            addi t1, zero, 16
            xor t2, t1, t0
            jal zero, loop_start
            // rabotaet :)
