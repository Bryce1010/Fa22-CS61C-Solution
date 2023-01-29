.globl f # this allows other files to find the function f

# f takes in two arguments:
# a0 is the value we want to evaluate f at
# a1 is the address of the "output" array (defined above).
# The return value should be stored in a0
f:
    slli a2, a0, 2
    add a2, a2, a1
    lw a0, 12(a2)
    # This is how you return from a function. You'll learn more about this later.
    # This should be the last line in your program.
    jr ra  