#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define DATA_SIZE       30

void sub_cpy(char **str, int *len, FILE *rx_file){

        char cpy_str[] = "Copie depuis cpy!!!\n";
        *len = strlen(cpy_str) + 1;
        //memcpy(str, cpy_str, *len);
        *str = cpy_str;
        fwrite(*str, 1, *len , rx_file);
        fflush(rx_file);
}

void cpy(char **str, int *len)
{
        FILE *rx_file = NULL;
	rx_file = fopen("file.txt", "ab");
	if (rx_file == NULL) {
		fprintf(stderr, "ERR: failed to open test file\n");
                exit(EXIT_FAILURE);
	}
        sub_cpy(str, len, rx_file);
        

}

int main(int argc, char const *argv[])
{
        char *str = NULL;
        int str_len = 0;
        //str = malloc(DATA_SIZE * sizeof(char));
        
        cpy(&str, &str_len);

        printf("len :%d\nstr: %s\n", str_len, str);
        return 0;
}
