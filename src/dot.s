.globl dot
.import multiply.s
.text
# =======================================================
# FUNCTION: Strided Dot Product Calculator
#
# Calculates sum(arr0[i * stride0] * arr1[i * stride1])
# where i ranges from 0 to (element_count - 1)
#
# Args:
#   a0 (int *): Pointer to first input array
#   a1 (int *): Pointer to second input array
#   a2 (int):   Number of elements to process
#   a3 (int):   Skip distance in first array
#   a4 (int):   Skip distance in second array
#
# Returns:
#   a0 (int):   Resulting dot product value
#
# Preconditions:
#   - Element count must be positive (>= 1)
#   - Both strides must be positive (>= 1)
#
# Error Handling:
#   - Exits with code 36 if element count < 1
#   - Exits with code 37 if any stride < 1
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_terminate  
    blt a3, t0, error_terminate   
    blt a4, t0, error_terminate  

    li t0, 0 # result of product
    li t1, 0 # loop count

loop_start:
    bge t1, a2, loop_end
    # TODO: Add your own implementation
# mul t2, t1, a3
# =========== mul start =============
    addi sp, sp, -32
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw a0, 12(sp)
    sw a1, 16(sp)
    sw a2, 20(sp)
    sw a3, 24(sp)
    sw a4, 28(sp)

    mv a0, t1
    mv a1, a3
    jal multiply
    mv t2, a0

    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw a0, 12(sp)
    lw a1, 16(sp)
    lw a2, 20(sp)
    lw a3, 24(sp)
    lw a4, 28(sp)
    addi sp, sp, 32
# ============ mul end ==============
    slli t2, t2, 2
    add t2, a0, t2 # caculate the address of current value in arr1
    lw t3, 0(t2) # t3 -> current value in arr1
    beqz t3, next_round

# mul t2, t1, a4
# =========== mul start =============
addi sp, sp, -36
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw a0, 12(sp)
    sw a1, 16(sp)
    sw a2, 20(sp)
    sw a3, 24(sp)
    sw a4, 28(sp)
    sw t3, 32(sp)

    mv a0, t1
    mv a1, a4
    jal multiply
    mv t2, a0

    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw a0, 12(sp)
    lw a1, 16(sp)
    lw a2, 20(sp)
    lw a3, 24(sp)
    lw a4, 28(sp)
    lw t3, 32(sp)
    addi sp, sp, 36
# ============ mul end ==============
    slli t2, t2, 2
    add t2, a1, t2
    lw t4, 0(t2)
    beqz t4, next_round
 
# mul t2, t3, t4
# =========== mul start =============
addi sp, sp, -32
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw a0, 12(sp)
    sw a1, 16(sp)
    sw a2, 20(sp)
    sw a3, 24(sp)
    sw a4, 28(sp)

    mv a0, t3
    mv a1, t4
    jal multiply
    mv t2, a0

    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw a0, 12(sp)
    lw a1, 16(sp)
    lw a2, 20(sp)
    lw a3, 24(sp)
    lw a4, 28(sp)
    addi sp, sp, 32
# ============ mul end ==============

    add t0, t0, t2 # accumulate result of dot product

next_round:
    addi t1, t1, 1 # update loop counter
    j loop_start

loop_end:
    mv a0, t0
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit