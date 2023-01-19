#include <stdio.h>
#include "bit_ops.h"

/* Returns the Nth bit of X. Assumes 0 <= N <= 31. */
unsigned get_bit(unsigned x, unsigned n) {
    /* YOUR CODE HERE */
    int tmp = 31 - n;
    return (x<<tmp)>>31;
}

/* Set the nth bit of the value of x to v. Assumes 0 <= N <= 31, and V is 0 or 1 */
void set_bit(unsigned *x, unsigned n, unsigned v) {
    int tmp = get_bit(*x, n);
    tmp = tmp << n;
    *x= (*x ^ tmp) + (v << n);
    /* YOUR CODE HERE */
}

/* Flips the Nth bit in X. Assumes 0 <= N <= 31.*/
void flip_bit(unsigned *x, unsigned n) {
    unsigned tmp = ~get_bit(*x, n);
    tmp = get_bit(tmp, 0);
    set_bit(x, n, tmp);
    /* YOUR CODE HERE */
}

