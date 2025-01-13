#include <stdio.h>
#include <libpq-fe.h>

int main() {
    printf("LibPQ version: %d\n", PQlibVersion());
    return 0;
}
