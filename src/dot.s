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

    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4

    li t0, 0 # Resulting dot product value
    li t1, 0 # initialize loop index

loop_start:
    bge t1, s2, loop_end    # End loop if index >= element count

    # Calculate offset for each element based on the stride
    
    # mul t2, t1, s3          # Offset for first array = t1 * stride0
    mv a0, t1
    mv a1, s3
    addi sp, sp, -20
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    jal multiply
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    lw t3, 16(sp)
    addi sp, sp, 20
    mv t2, a0

    slli t2, t2, 2          # Scale offset by 4 (int size in bytes)
    add t3, s0, t2          # t3 = address of arr0[t1 * stride0]

    # mul t4, t1, s4          # Offset for second array = t1 * stride1
    mv a0, t1
    mv a1, s4
    addi sp, sp, -20
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    jal multiply
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    lw t3, 16(sp)
    addi sp, sp, 20
    mv t4, a0

    slli t4, t4, 2          # Scale offset by 4 (int size in bytes)
    add t5, s1, t4          # t5 = address of arr1[t1 * stride1]

    # Load elements from both arrays
    lw t6, 0(t3)            # Load arr0[t1 * stride0]
    lw t2, 0(t5)            # Load arr1[t1 * stride1]

    # Perform multiplication and add to result
    # mul t3, t6, t2          # t3 = arr0[t1 * stride0] * arr1[t1 * stride1]
    mv a0, t6
    mv a1, t2
    addi sp, sp, -20
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    jal multiply
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    lw t3, 16(sp)
    addi sp, sp, 20
    mv t3, a0

    add t0, t0, t3          # Accumulate the product into the result

    addi t1, t1, 1          # Increment loop index
    j loop_start            # Jump back to loop start

loop_end:
    mv a0, t0
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
    jr ra

error_terminate:
    blt a2, t0, set_error_36
    li a0, 37
    j exit

set_error_36:
    li a0, 36
    j exit

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