.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    li t0, 1
    blt a1, t0, error
    blt a2, t0, error
    blt a4, t0, error
    blt a5, t0, error
    bne a2, a4, error

    j normal

error:
    li a0, 38
    j exit

    # Prologue
normal:
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    li t1, 0                # i = t1 = 0

###########################################################################   
#  print rows and columns of m0
#  print rows and columns of m1
###########################################################################  
    # addi sp, sp, -16
    # sw a0, 0(sp)
    # sw a1, 4(sp)
    # sw t1, 8(sp)
    # sw t2, 12(sp)

    # add a1, a1, zero 
    # li a0, 1
    # ecall

    # li a1, ' '
    # li a0, 11
    # ecall

    # add a1, a2, zero 
    # li a0, 1
    # ecall

    # li a1, ' '
    # li a0, 11
    # ecall

    # add a1, a4, zero 
    # li a0, 1
    # ecall

    # li a1, ' '
    # li a0, 11
    # ecall

    # add a1, a5, zero 
    # li a0, 1
    # ecall

    # li a1, '\n'
    # li a0, 11
    # ecall

    # lw a0, 0(sp)
    # lw a1, 4(sp)
    # lw t1, 8(sp)
    # lw t2, 12(sp)
    # addi sp, sp, 16

###########################################################################  

outer_loop_start:

    bge t1, a1, outer_loop_end
    li t2, 0                # j = t2 = 0

inner_loop_start:

    bge t2, a5, inner_loop_end

###########################################################################   
#  print current i and j
###########################################################################  

    # addi sp, sp, -16
    # sw a0, 0(sp)
    # sw a1, 4(sp)
    # sw t1, 8(sp)
    # sw t2, 12(sp)

    # add a1, t1, zero 
    # li a0, 1
    # ecall

    # li a1, ' '
    # li a0, 11
    # ecall

    # add a1, t2, zero 
    # li a0, 1
    # ecall

    # li a1, '\n'
    # li a0, 11
    # ecall

    # lw a0, 0(sp)
    # lw a1, 4(sp)
    # lw t1, 8(sp)
    # lw t2, 12(sp)
    # addi sp, sp, 16

###########################################################################  

###########################################################################   
#  call the dot function
###########################################################################
    addi sp, sp, -36
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw t1, 28(sp)
    sw t2, 32(sp)

    add s0, a0, zero
    add s1, a1, zero
    add s2, a2, zero
    add s3, a3, zero
    add s4, a4, zero

    mul t3, t1, a2
    slli s0, t3, 2
    add a0, a0, s0

    slli s0, t2, 2
    add a1, a3, s0

    add a2, a2, zero
    addi a3, zero, 1
    add a4, zero, a5

    jal dot
    add s0, a0, zero

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)
    lw t1, 28(sp)
    lw t2, 32(sp)
    addi sp, sp, 36

###########################################################################  

    mul t3, t1, a5          # t3 = i * m1.columns 
    add t3, t3, t2          # t3 = t3 + j
    slli t4, t3, 2
    add s1, a6, t4          # s1 = &m2[i][j]
    sw s0, 0(s1)

###########################################################################   
#  print m2[i][j]
########################################################################### 
    # addi sp, sp, -12
    # sw a0, 0(sp)
    # sw a1, 4(sp)
    # sw s1, 8(sp)

    # add a1, s0, zero 
    # li a0, 1
    # ecall

    # li a1, '\n'
    # li a0, 11
    # ecall

    # lw a0, 0(sp)
    # lw a1, 4(sp)
    # lw s1, 8(sp)
    # addi sp, sp, 12
########################################################################### 

    addi t2, t2, 1          # j ++
    jal inner_loop_start

inner_loop_end:

    addi t1, t1, 1          # i ++
    jal outer_loop_start

outer_loop_end:

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24

    # Epilogue


    jr ra