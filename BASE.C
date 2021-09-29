#include <stdio.h>
#include <string.h>

char String1[256],String2[256];                /* The two input strings */
int  Used1[26], Used2[26];                     /* Stores what is used   */
FILE *F;                                       /* The input file        */



/* void ClearUsed(void);

  This procedure clears the two used arrays.

  INPUT
    none

  RETURNS
    nothing
*/
void ClearUsed(void)
{
int Count;
  for (Count = 0; Count < 26; Count++)
  {
    Used1[Count] = 0;
    Used2[Count] = 0;
  }
}


/* void PrintShared(void);

  This loops through Used1 and outputs if true, thus outputing all
of the letters used by String1. It prints the letters out with commas
inbetween them, and does NOT add a carriage return

  INPUT
    none

  RETURNS
    nothing
*/
void PrintShared(void)
{
  char Count;
  int First;

  First = 1;
  for (Count = 'a'; Count <= 'z'; Count++)
    if (Used1[Count - 'a'])
    {
      if (!First)
        printf(", ");
      printf("%c",Count);
      First = 0;
    }
}


void main()
{
int Count;
int same;            /* used to store if the two strings use the same alpha. */

  F = fopen("Base.in","rt");
  while (!feof(F))
  {
    /* Read in the two strings, remove the CR of the end if it's there,
       and then print it. */
    fgets(String1,255,F);
    Count = strlen(String1) - 1;
    if (String1[Count] == '\n')
      String1[Count] = 0;
    printf("%s\n",String1);

    fgets(String2,255,F);
    Count = strlen(String2) - 1;
    if (String2[Count] == '\n')
      String2[Count] = 0;
    printf("%s\n",String2);

    /* Make sure all is in readiness */
    ClearUsed();

    /* Set the values in the Used arrays */
    for (Count = 0; String1[Count]; Count++)
      Used1[String1[Count] - 'a'] = 1;
    for (Count = 0; String2[Count]; Count++)
      Used2[String2[Count] - 'a'] = 1;

    /* Determine sameness of alphabet by determining if the two
       Used arrays are equal */

    same = 1;
    for (Count = 0; Count < 26; Count++)
      if (Used1[Count] != Used2[Count])
        same = 0;
    if (same)
    {
      printf("The words share the base alphabet (");
      PrintShared();
      printf(").\n");
    }
    else
      printf("The words do not share the same base alphabet.\n");
    printf("\n");;
  }
  fclose(F);
}