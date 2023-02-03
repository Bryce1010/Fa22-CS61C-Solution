.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue

    # Exceptions
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

    slli s0, t0, 2
    add t1, a0, s0
    lw t3, 0(t1)    # max = t3 = a0[0]
    li t4, 0        # res = t4 = 0

loop_start:
    bge t0, a1, loop_end

    slli s0, t0, 2
    add t1, a0, s0
    lw t2, 0(t1)

    # max >= cur ?  
    bge t3, t2, loop_continue
    add t4, t0, zero # res = t0
    add t3, t2, zero # max = t2

loop_continue:

    # Counter self increasement
    addi t0, t0, 1
    jal loop_start

loop_end:
    add a0, t4, zero

    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8

    # Epilogue

    jr ra