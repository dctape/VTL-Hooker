#include <linux/bpf.h>
#include <bcc/helpers.h>

#define bpf_printk(fmt, ...)					\
({								\
	       char ____fmt[] = fmt;				\
	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
				##__VA_ARGS__);			\
}) 



/* programme sockops */
 BPF_HASH(counter, int, int, 1);

int sockops(struct bpf_sock_ops * skops)
{
    __u32 family, op;
    int *cnt, key = 0, init = 0;


    family = skops->family;
    op = skops->op;

    /* surveillance des connexions socket TCP| uniquement TCP... */
    switch(op){

        case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
        case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:

               cnt = counter.lookup_or_init(&key, &init);
               if(cnt)
                    *cnt += 1;
               bpf_printk("ajout d'une socket %i dans la sockmap !\n",
                    skops->local_port);
            break;
        default:
            break;
    }

    return 0;
}