.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)

    # Prologue
# ==============================================================================
#   1. Open the file with read permissions. 
# ==============================================================================
    addi sp, sp, -8
    sw a1, 0(sp)
    sw a2, 4(sp)
    addi a1, zero, 0

    jal fopen

    lw a1, 0(sp)
    lw a2, 4(sp)
    addi sp, sp, 8

    addi t0, zero, -1
    beq a0, t0, fopen_error
# ==============================================================================


# ==============================================================================
#   2.1 Malloc the memory for the number of row and column
# ==============================================================================
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)

    addi a0, zero, 8
    jal malloc

    beq a0, zero, malloc_error

    mv t0, a0
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12
# ==============================================================================


# ==============================================================================
#   2.2 Read the number of rows and columns from the file
# ==============================================================================
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw t0, 12(sp)

    addi a2, zero, 8
    mv a1, t0
    jal fread
    addi a2, zero, 8  
    bne a0, a2, fread_error

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw t0, 12(sp)
    addi sp, sp, 16

    lw s1, 0(t0)        # row
    lw s2, 4(t0)        # column
    sw s1, 0(a1)
    sw s2, 0(a2)
    mv t1, s1
    mv t2, s2
# ==============================================================================


# ==============================================================================
#   3. Allocate space on the heap to store the matrix.
# ==============================================================================
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)

    mul t0, t1, t2
    addi t1, zero, 4
    mul a0, t0, t1
    add s0, a0, zero
    jal malloc
    beq a0, zero, malloc_error

    add t0, a0, zero
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    addi sp, sp, 12
# ==============================================================================


# ==============================================================================
#   4. Read the matrix from the file to the memory allocated in the previous step.
# ==============================================================================
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw t0, 12(sp)

    addi a1, t0, 0       # t0 is the address of the matrix
    addi a2, s0, 0
    jal fread
    addi a2, s0, 0
    bne a0, a2, fread_error

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw t0, 12(sp)
    addi sp, sp, 16
# ==============================================================================


# ==============================================================================
#   5. Close the file.
# ==============================================================================
    addi sp, sp, -8
    sw a0, 0(sp)
    sw t0, 4(sp)

    jal fclose
    bne a0, zero, fclose_error

    lw a0, 0(sp)
    lw t0, 4(sp)
    addi sp, sp, 8
# ==============================================================================

    # Epilogue

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 16

#   6. Return a pointer to the matrix in memory.
    add a0, t0, zero

    jr ra

malloc_error:
    li a0, 26
    j exit


fopen_error:
    li a0, 27
    j exit


fclose_error:
    li a0, 28
    j exit


fread_error:
    li a0, 29
    j exit