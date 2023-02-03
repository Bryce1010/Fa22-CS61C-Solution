.import ../src/utils.s
.import ../src/matmul.s
.import ../src/dot.s

.data
.align 4
m0: .word 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
.align 4
m1: .word 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
.align 4
m2: .word -1 -1 -1 -1 -1 -1 -1 -1 -1
.align 4
m3: .word 0 0 0 0 0 0 0 0 0
msg0: .asciiz "Expected m2 to be:\n0 0 0 0 0 0 0 0 0\nInstead it is:\n"

.globl main_test
.text
# main_test function for testing
main_test:

    # load address to array m0 into a0
    la a0 m0

    # load 5 into a1
    li a1 5

    # load 3 into a2
    li a2 3

    # load address to array m1 into a3
    la a3 m1

    # load 4 into a4
    li a4 4

    # load 5 into a5
    li a5 5

    # load address to array m2 into a6
    la a6 m2

    # call matmul function
    jal ra matmul

    ##################################
    # check that m2 == [0, 0, 0, 0, 0, 0, 0, 0, 0]
    ##################################
    # a0: exit code
    li a0, 2
    # a1: expected data
    la a1, m3
    # a2: actual data
    la a2, m2
    # a3: length
    li a3, 9
    # a4: error message
    la a4, msg0
    jal compare_int_array
    # we expect matmul to exit early with code 38

    # exit normally
    li a0 0
    jal exit
