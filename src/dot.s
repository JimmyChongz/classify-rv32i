.globl dot

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
    mv t3, t1
    mv t4, a3
    li t2, 0

mul_loopA:
    beqz t4, doneA
    andi t5, t4, 1
    beqz t5, skipA
    add t2, t2, t3

skipA:
    slli t3, t3, 1
    srli t4, t4, 1
    j mul_loopA

doneA:
# ============ mul end ==============
    slli t2, t2, 2
    add t2, a0, t2 # caculate the address of current value in arr1
    lw t3, 0(t2) # t3 -> current value in arr1
    beqz t3, next_round

# mul t2, t1, a4
# =========== mul start =============
    mv t5, t1
    mv t4, a4
    li t2, 0

mul_loopB:
    beqz t4, doneB
    andi t6, t4, 1
    beqz t6, skipB
    add t2, t2, t5

skipB:
    slli t5, t5, 1
    srli t4, t4, 1
    j mul_loopB

doneB:
# ============ mul end ==============
    slli t2, t2, 2
    add t2, a1, t2
    lw t4, 0(t2)
    beqz t4, next_round
 
# mul t2, t3, t4
# =========== mul start =============
    li t2, 0

mul_loopC:
    beqz t4, doneC
    andi t5, t4, 1
    beqz t5, skipC
    add t2, t2, t3

skipC:
    slli t3, t3, 1
    srli t4, t4, 1
    j mul_loopC

doneC:
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