
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>


char *
concat (const char *str, ...) // appel à free sur le résultat.
{
  va_list ap;
  size_t allocated = 100;
  char *result = (char *) malloc (allocated);

  if (result != NULL)
    {
      char *newp;
      char *wp;
      const char *s;

      va_start (ap, str);

      wp = result;
      for (s = str; s != NULL; s = va_arg (ap, const char *))
        {
          size_t len = strlen (s);

          /* Resize the allocated memory if necessary.  */
          if (wp + len + 1 > result + allocated)
            {
              allocated = (allocated + len) * 2;
              newp = (char *) realloc (result, allocated);
              if (newp == NULL)
                {
                  free (result);
                  return NULL;
                }
              wp = newp + (wp - result);
              result = newp;
            }

          wp = mempcpy (wp, s, len);
        }

      /* Terminate the result string.  */
      *wp++ = '\0';

      /* Resize memory to the optimal size.  */
      newp = realloc (result, wp - result);
      if (newp != NULL)
        result = newp;

      va_end (ap);
    }

  return result;
}

struct s_test 
{
    int hdr;
};

struct test
{
   struct s_test first;
   void *data;
    
};





int main()
{
    char *res;
    char str1[100];
    str1[0] = 'H';
    str1[1] = 'e';
    str1[2] = 'l';
    str1[3] = 'l';
    str1[4] = 'o';
    
    char *str2 = " World";

    
    struct test tst = {};
    tst.first.hdr = 18;
    tst.data = str2;

    char *buffer = (char *)malloc(sizeof(tst));
    memcpy(buffer, (char *)&tst, sizeof(tst));
    
    printf("struct to string \n");
    for(int i=0;i<sizeof(tst);i++)
		printf("%02X ",buffer[i]);
	printf("\n");
    
    printf("string to struct\n");

    struct test tst2;
    //tst2 = (struct test *)malloc(sizeof(test));

    memcpy(&tst2, (struct test *)buffer, sizeof(struct test));
    printf("hdr : %d\tdata: %s\n", tst2.first.hdr, tst2.data);
    
    free(buffer);


    return 0;


}