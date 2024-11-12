.globl multiply

multiply:
    li t0, 0
    mv t1, a0
    mv t2, a1

mul_loop:
    beqz t2, done
    andi t3, t2, 1
    beqz t3, skip
    add t0, t0, t1

skip:
    slli t1, t1, 1
    srli t2, t2, 1
    j mul_loop

done:
    mv a0, t0
    jr ra