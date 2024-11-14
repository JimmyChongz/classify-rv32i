.globl multiply

multiply:
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    li t0, 0

mul_loop:
    beqz a1, done
    andi t1, a1, 1
    beqz t1, skip
    add t0, t0, a0

skip:
    slli a0, a0, 1
    srli a1, a1, 1
    j mul_loop

done:
    mv a0, t0
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    jr ra