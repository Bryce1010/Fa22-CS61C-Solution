.import ../src/utils.s
.import ../src/matmul.s
.import ../src/dot.s

.data
.align 4
m0: .word 1 2 3 4 5 6 7 8 9 10
.align 4
m1: .word 1 2 3 4 5 6 7 8 9 10
.align 4
m2: .word -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1
.align 4
m3: .word 13 16 19 22 25 27 34 41 48 55 41 52 63 74 85 55 70 85 100 115 69 88 107 126 145
msg0: .asciiz "Expected m2 to be:\n13 16 19 22 25 27 34 41 48 55 41 52 63 74 85 55 70 85 100 115 69 88 107 126 145\nInstead it is:\n"

.globl main_test
.text
# main_test function for testing
main_test:

    # load address to array m0 into a0
    la a0 m0

    # load 5 into a1
    li a1 5

    # load 2 into a2
    li a2 2

    # load address to array m1 into a3
    la a3 m1

    # load 2 into a4
    li a4 2

    # load 5 into a5
    li a5 5

    # load address to array m2 into a6
    la a6 m2

    # call matmul function
    jal ra matmul

    ##################################
    # check that m2 == [13, 16, 19, 22, 25, 27, 34, 41, 48, 55, 41, 52, 63, 74, 85, 55, 70, 85, 100, 115, 69, 88, 107, 126, 145]
    ##################################
    # a0: exit code
    li a0, 2
    # a1: expected data
    la a1, m3
    # a2: actual data
    la a2, m2
    # a3: length
    li a3, 25
    # a4: error message
    la a4, msg0
    jal compare_int_array

    # exit normally
    li a0 0
    jal exit
