
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>  


// Computing the internet checksum (RFC 1071).
uint16_t
checksum (uint16_t *addr, int len)
{
        int count = len;
        register uint32_t sum = 0;
        uint16_t answer = 0;

        // Sum up 2-byte values until none or only one byte left.
        while (count > 1) {
                sum += *(addr++);
                count -= 2;
        }

        // Add left-over byte, if any.
        if (count > 0) {
              sum += *(uint8_t *) addr;  
        }

        // Fold 32-bit sum into 16 bits; we lose information by doing this,
        // increasing the chances of a collision.
        // sum = (lower 16 bits) + (upper 16 bits shifted right 16 bits)
        while (sum >> 16) {
        sum = (sum & 0xffff) + (sum >> 16);
        }

        // Checksum is one's compliment of sum.
        answer = ~sum;

        return (answer);
}


// Allocate memory for an array of chars.
char *
allocate_strmem (int len)
{
        void *tmp;
        if (len <= 0) {
                fprintf (stderr, "ERR: Cannot allocate memory because len = %i in allocate_strmem().\n", len);
                exit (EXIT_FAILURE);
        }

        tmp = (char *) malloc (len * sizeof (char));
        if (tmp != NULL) {
                memset (tmp, 0, len * sizeof (char));
                return (tmp);
        } else {
                fprintf (stderr, "ERR: Cannot allocate memory for array allocate_strmem().\n");
                exit (EXIT_FAILURE);
        }
}


// Allocate memory for an array of unsigned chars.
uint8_t *
allocate_ustrmem (int len)
{
        void *tmp;

        if (len <= 0) {
                fprintf (stderr, 
                        "ERR: Cannot allocate memory because len = %i in allocate_ustrmem().\n", 
                        len);
                exit (EXIT_FAILURE);
        }

        tmp = (uint8_t *) malloc (len * sizeof (uint8_t));

        if (tmp == NULL) {
                fprintf (stderr, 
                        "ERR: Cannot allocate memory for array allocate_ustrmem().\n");
                exit (EXIT_FAILURE);
        }
        memset (tmp, 0, len * sizeof (uint8_t));
        
        return tmp;     
}


// Allocate memory for an array of ints.
int *
allocate_intmem (int len)
{
        void *tmp;

        if (len <= 0) {
                fprintf (stderr, 
                         "ERR: Cannot allocate memory because len = %i in allocate_intmem().\n", 
                        len);
                exit (EXIT_FAILURE);
        }

        tmp = (int *) malloc (len * sizeof (int));

        if (tmp == NULL) {
                fprintf (stderr, 
                         "ERR: Cannot allocate memory for array allocate_intmem().\n");
                exit (EXIT_FAILURE);
        } 

        memset (tmp, 0, len * sizeof (int));
        return tmp;      
}