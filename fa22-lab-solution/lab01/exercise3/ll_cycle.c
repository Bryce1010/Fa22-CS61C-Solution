#include <stddef.h>
#include<stdbool.h>
#include "ll_cycle.h"

bool ll_has_cycle(node *head) {
    /* TODO: Implement ll_has_cycle */
    node *fast=head, *slow=head;
    while (fast&&fast->next&&fast->next->next) {
        fast = fast->next->next;
        slow = slow->next;
        if (fast == slow) {
            return true;
        }
    }
    return false;
}
