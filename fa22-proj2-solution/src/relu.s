.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    li t0, 1
    bge a1, t0, normal
    li a0, 36
    j exit

normal:
    # Push the callee registers into the stack
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)

    # Init a counter
    li t0, 0

loop_start:
    # If the counter greater or equal than a1
    bge t0, a1, loop_end

    slli s0, t0, 2
    add t1, a0, s0
    lw t2, 0(t1)

    # If the target number greater than 0
    bge t2, zero, loop_continue
    add t2, x0, x0
    sw t2, 0(t1)

loop_continue:
    # Counter self increasement
    addi t0, t0, 1
    jal loop_start

loop_end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    
    # Epilogue
    jr ra
