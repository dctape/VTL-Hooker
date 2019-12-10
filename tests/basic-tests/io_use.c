#include <stdio.h>
#include <stdlib.h>

#define ERRBUF_SIZE     100


int main(int argc, char const *argv[])
{
        char err_buf[ERRBUF_SIZE];
        snprintf(err_buf, ERRBUF_SIZE, "Essai copie avec snprintf\n");
        printf("%s", err_buf);
        return 0;
}
