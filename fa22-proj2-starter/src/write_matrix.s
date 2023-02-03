.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Prologue
# ==============================================================================
#   1. Open the file with read permissions. 
# ==============================================================================
    addi sp, sp, -12
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)

    addi a1, zero, 1

    jal fopen

    addi t0, zero, -1
    beq a0, t0, fopen_error

    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    addi sp, sp, 12
# ==============================================================================


# ==============================================================================
#   2.1 Store the number of rows and columns to the memory. 
# ==============================================================================
    addi sp, sp, -20
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)

    addi t0, zero, 4
    add a0, t0, zero
    jal malloc
    beq a0, zero, malloc_error
    mv t1, a0
    sw t1, 16(sp)

    addi t0, zero, 4
    add a0, t0, zero
    jal malloc
    beq a0, zero, malloc_error
    mv t2, a0

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw t1, 16(sp)
    addi sp, sp, 20

    sw a2, 0(t1)
    sw a3, 0(t2)
# ==============================================================================


# ==============================================================================
#   2.2 Write the number of rows and columns to the file. 
# ==============================================================================
    addi sp, sp, -24
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw t1, 16(sp)
    sw t2, 20(sp)


    mv a1, t1
    li a2, 1
    li a3, 4
    jal fwrite


    li a2, 1
    bne a0, a2, fwrite_error


    lw a0, 0(sp)
    lw t2, 20(sp)

    mv a1, t2
    li a2, 1
    li a3, 4
    jal fwrite


    li a2, 1
    bne a0, a2, fwrite_error

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw t1, 16(sp)
    lw t2, 20(sp)
    addi sp, sp, 24
# ==============================================================================


# ==============================================================================
#   3. Write the data to the file.
# ==============================================================================
    addi sp, sp, -20
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)

    mul t0, a2, a3
    sw t0, 16(sp)
    mv a2, t0
    li a3, 4
    jal fwrite
    lw t0, 16(sp)
    bne a0, t0, fwrite_error

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    addi sp, sp, 20
# ==============================================================================


# ==============================================================================
#   4. Close the file.
# ==============================================================================
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    
    sw t0, 4(sp)

    jal fclose
    bne a0, zero, fclose_error

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    addi sp, sp, 16
# ==============================================================================

    # Epilogue

    lw ra, 0(sp)
    addi sp, sp, 4

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


fwrite_error:
    li a0, 30
    j exit