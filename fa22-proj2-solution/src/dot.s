.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue

    li t0, 1
    blt a2, t0, length_error
    blt a3, t0, stride_error
    blt a4, t0, stride_error
    j normal

length_error:
    li a0, 36
    j exit

stride_error:
    li a0, 37
    j exit

normal:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)

    li t0, 0            # cnt = 0
    li t1, 0            # sum = 0

loop_start:

    bge t0, a2, loop_end

    mul t2, t0, a3
    slli s0, t2, 2
    add t3, a0, s0      # cur_0 = t3 = &arr0[stride * cnt]
    lw t3, 0(t3)        # cur_0 = t3 =  arr0[stride * cnt]

    mul t2, t0, a4
    slli s0, t2, 2
    add t4, a1, s0      # cur_1 = t4 = &arr1[stride * cnt]
    lw t4, 0(t4)        # cur_1 = t4 =  arr1[stride * cnt]

    mul t5, t3, t4      # tmp = t5 = t3 * t4 = cur_0 * cur_1
    add t1, t1, t5      # sum = sum + tmp

    addi t0, t0, 1      # cnt ++ 
    jal loop_start

loop_end:
    add a0, t1, zero

    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8

    # Epilogue


    jr ra
