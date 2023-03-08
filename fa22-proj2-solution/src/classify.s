.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
# ==============================================================================
# 1. Read three matrices m0, m1, and input from files. 
#    Their filepaths are provided as arguments. You will need to allocate space 
#    for the pointer arguments to read_matrix, since that function is expecting 
#    a pointer to allocated memory.
# 2. Compute h = matmul(m0, input). You will probably need to malloc space to fit h.
# 3. Compute h = relu(h). Remember that relu is performed in-place.
# 4. Compute o = matmul(m1, h) and write the resulting matrix to the output file. 
#    The output filepath is provided as an argument.
# 5. Compute and return argmax(o). If the print argument is set to 0, then also 
#    print out argmax(o) and a newline character.
# 6. Free any data you allocated with malloc. This includes any heap blocks 
#    allocated from calling read_matrix.
# 7. Remember to put the return value, argmax(o), in the appropriate register 
#    before returning.
# ==============================================================================
classify:
    addi sp, sp, -44
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)

# ==============================================================================
#   0.  Check the number of the arguments
# ==============================================================================
    addi t0, zero, 5
    bne a0, t0, arguments_error
# ==============================================================================

# ==============================================================================
#   1.1 Read pretrained m0
# ==============================================================================
    addi sp, sp, -24
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)

    lw t0, 4(a1)                # a1[1] is the filepath string of m0
    sw t0, 12(sp)

    addi t1, zero, 4
    add a0, t1, zero
    jal malloc
    beq a0, zero, malloc_error
    mv t1, a0                   # use the t1 to store the address of row

    sw t1, 16(sp)

    addi t2, zero, 4
    add a0, t2, zero
    jal malloc
    beq a0, zero, malloc_error
    mv t2, a0                   # use the t2 to store the address of column
    sw t2, 20(sp)


    lw t0, 12(sp)
    lw t1, 16(sp)

    mv a0, t0
    mv a1, t1
    mv a2, t2

    jal read_matrix
    mv s0, a0                   # use the s0 to store the address of m0
    lw s1, 16(sp)               # use the s1 to store the row number address
    lw s2, 20(sp)               # use the s2 to store the column number address


    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 24
# ==============================================================================


# ==============================================================================
#   1.2 Read pretrained m1
# ==============================================================================
    addi sp, sp, -24
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)

    lw t0, 8(a1)                # a1[2] is the filepath string of m1
    sw t0, 12(sp)

    addi t1, zero, 4
    add a0, t1, zero
    jal malloc
    beq a0, zero, malloc_error
    mv t1, a0                   # use the t1 to store the address of row

    sw t1, 16(sp)

    addi t2, zero, 4
    add a0, t2, zero
    jal malloc
    beq a0, zero, malloc_error
    mv t2, a0                   # use the t2 to store the address of column
    sw t2, 20(sp)


    lw t0, 12(sp)
    lw t1, 16(sp)

    mv a0, t0
    mv a1, t1
    mv a2, t2

    jal read_matrix
    mv s3, a0                   # use the s3 to store the address of m1
    lw s4, 16(sp)               # use the s4 to store the row number address
    lw s5, 20(sp)               # use the s5 to store the column number address


    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 24
# ==============================================================================


# ==============================================================================
#   1.3 Read input matrix
# ==============================================================================
    addi sp, sp, -24
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)

    lw t0, 12(a1)               # a1[3] is the filepath string of input matrix
    sw t0, 12(sp)

    addi t1, zero, 4
    add a0, t1, zero
    jal malloc
    beq a0, zero, malloc_error
    mv t1, a0                   # use the t1 to store the address of row

    sw t1, 16(sp)

    addi t2, zero, 4
    add a0, t2, zero
    jal malloc
    beq a0, zero, malloc_error
    mv t2, a0                   # use the t2 to store the address of column
    sw t2, 20(sp)


    lw t0, 12(sp)
    lw t1, 16(sp)

    mv a0, t0
    mv a1, t1
    mv a2, t2

    jal read_matrix
    mv s6, a0                   # use the s6 to store the address of input matrix
    lw s7, 16(sp)               # use the s7 to store the row number address
    lw s8, 20(sp)               # use the s8 to store the column number address


    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 24
# ==============================================================================


# ==============================================================================
#   2. Compute h = matmul(m0, input)
# ==============================================================================
    addi sp, sp, -20
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)

    lw a1, 0(s1)        # load the m0's row number
    lw a5, 0(s8)        # load the input's column number

##############################################################
#   2.1 Allocate the memory for the h
##############################################################
    mul t0, a1, a5
    sw t0, 12(sp)       # number of the elements
    li t1, 4
    mul t0, t0, t1


    mv a0, t0
    jal malloc
    beq a0, zero, malloc_error

    mv t0, a0           # t0 store the address of h
##############################################################

    mv a0, s0           # a0 point to m0's address
    lw a1, 0(s1)        # load the row number
    lw a2, 0(s2)        # load the column number

    mv a3, s6           # a0 point to input's address
    lw a4, 0(s7)        # load the row number
    lw a5, 0(s8)        # load the column number

    mv a6, t0
    sw t0, 16(sp)

    jal matmul


    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw t1, 12(sp)       # the number of the elements
    lw t0, 16(sp)       # the address of h
    addi sp, sp, 20
# ==============================================================================


# ==============================================================================
#   3. Compute h = relu(h)
# ==============================================================================
    addi sp, sp, -20
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw t0, 12(sp)
    sw t1, 16(sp)

    mv a0, t0
    mv a1, t1
    jal relu


    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw t0, 12(sp)
    lw t1, 16(sp)
    addi sp, sp, 20
# ==============================================================================


# ==============================================================================
#   4. Compute o = matmul(m1, h)
# ==============================================================================
    addi sp, sp, -28
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw t0, 12(sp)
    sw t1, 16(sp)

    lw a1, 0(s4)        # load the m1's row number
    lw a5, 0(s8)        # load the h's column number

##############################################################
#   4.1 Allocate the memory for the o
##############################################################
    mul t2, a1, a5
    sw t2, 24(sp)       # number of the elements
    li t3, 4
    mul t2, t2, t3


    mv a0, t2
    jal malloc
    beq a0, zero, malloc_error

    mv t2, a0           # t2 store the address of o
##############################################################

    mv a0, s3           # a0 point to m1's address
    lw a1, 0(s4)        # load the row number
    lw a2, 0(s5)        # load the column number

    lw t0, 12(sp)
    mv a3, t0           # a0 point to h's address
    lw a4, 0(s1)        # load the row number
    lw a5, 0(s8)        # load the column number

    mv a6, t2
    sw t2, 20(sp)

    jal matmul


    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw t0, 12(sp)
    lw t1, 16(sp)
    lw t2, 20(sp)       # the address of o
    lw t3, 24(sp)       # the number of elements in o
    addi sp, sp, 28
# ==============================================================================

#   m1 x h = m1 x m0 x input
# ==============================================================================
#   4.2 Write output matrix o
# ==============================================================================
    addi sp, sp, -28
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw t0, 12(sp)
    sw t1, 16(sp)
    sw t2, 20(sp)
    sw t3, 24(sp)

    lw t3, 16(a1)                # a1[4] is the filepath string of output file

    mv a0, t3
    mv a1, t2
    lw a2, 0(s4)
    lw a3, 0(s8)

    ebreak

    jal write_matrix

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw t0, 12(sp)
    lw t1, 16(sp)
    lw t2, 20(sp)
    lw t3, 24(sp)
    addi sp, sp, 28
# ==============================================================================


# ==============================================================================
#   5.1 Compute and return argmax(o)
# ==============================================================================
    addi sp, sp, -28
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw t0, 12(sp)
    sw t1, 16(sp)
    sw t2, 20(sp)
    sw t3, 24(sp)

    mv a0, t2
    mv a1, t3
    jal argmax
    mv s9, a0

# ==============================================================================
#   5.2 If enabled, print argmax(o) and newline
# ==============================================================================
    lw a2, 8(sp)

    bne a2, zero, not_print

    jal print_int
    li a0, '\n'
    jal print_char

not_print:
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw t0, 12(sp)

    mv a0, t0
    jal free

    lw t1, 16(sp)
    lw t2, 20(sp)

    mv a0, t2
    jal free

    lw t3, 24(sp)
    addi sp, sp, 28
# ==============================================================================

# ==============================================================================
#   6. Free any data you allocated with malloc.
# ==============================================================================
    mv a0, s1
    jal free

    mv a0, s2
    jal free

    mv a0, s4
    jal free

    mv a0, s5
    jal free

    mv a0, s7
    jal free

    mv a0, s8
    jal free
# ==============================================================================

    mv a0, s9

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    addi sp, sp, 44

    jr ra


malloc_error:
    li a0, 26
    j exit


arguments_error:
    li a0, 31
    j exit