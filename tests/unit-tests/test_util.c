#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#include "../../src/common/util.h"

#define LEN 100

struct data_buf
{
        uint8_t *msg;
};

struct data
{
        struct data_buf *buf;
};

void allocate(struct data *data, int len)
{

        data->buf->msg = allocate_ustrmem(len);
}

struct data *
new_data(int len)
{
        struct data *d = malloc(sizeof(struct data));
        d->buf = malloc(sizeof(struct data_buf));
        allocate(d, len);
        return d;
}

/** Test de fonction de rappel **/
typedef void (*fn_cb)(void *ctx, char *str);
struct callback
{
        void *ctx;
        fn_cb cb;
};

void print_str(char *str, struct callback *c)
{
        c->cb(c->ctx, str);
}

void test_cb(void *ctx, char *str)
{
        printf("From Callback : %s\n", str);
}

int main(int argc, char const *argv[])
{

        // struct data *data = new_data(LEN);

        // strcpy(data->buf->msg, "Success");
        // printf("%s\n", data->buf->msg);

        struct callback c = {
            .cb = test_cb,
        };
        char *str = "Success";
        print_str(str, &c);
        return 0;
}
