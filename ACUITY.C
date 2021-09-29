#include <stdio.h>
#include <stdlib.h>

/* Define some useful format strings */
#define invalid_msg 	"Ali does not see a valid number.\n"
#define smaller_msg	"Ali sees %s, which is not bigger than %s.\n"
#define bigger_msg	"Ali sees %s, which is bigger than %s.\n"

/* Variables */
FILE *fp_input;
int valid,end,bigger;

/* Prototypes */
int is_valid(char *);
void get_flipped(char *, char *);


void main()
{
   char number[22], flipped[22];

   /* Open input file */
   fp_input = fopen("acuity.in","r");

   /* Read and process until end-of-file is reached */
   while ((end=fscanf(fp_input, "%s", number))!= EOF)
   {
      /* Check if it's a valid number */
      valid= is_valid(number);

      /* If so, then figure out if it's bigger or not */
      if (valid)
      {
	 get_flipped(number, flipped);
	 bigger= strcmp(flipped, number);

	 /* Print the appropriate message */
	 if (bigger > 0)
	 {      if (number[0] != '-')
		   printf(bigger_msg, flipped, number);
		else
		   printf(smaller_msg, flipped, number);
	 }
	 else
	 {
	       if ((number[0] == '-') && (bigger != 0))
		   printf(bigger_msg, flipped, number);
	       else
		   printf(smaller_msg, flipped, number);
	 }
      }
      else
	 printf(invalid_msg);

      /* Clear the number and its flipped representation */
      memset(number, '\0', strlen(number));
      memset(flipped, '\0', strlen(flipped));

   }

   /* Close the input file */
   fclose(fp_input);
}


int is_valid(char *number)
{
   int i=0;
   while(number[i] != '\0')
   {
      if((number[i]=='4') || (number[i]=='6') ||
	 (number[i]=='7') || (number[i]=='9') )
	 return 0;
      i++;
   }
   return 1;
}

void get_flipped(char *num, char *flip)
{
   int i=0;

   while(num[i] != '\0')
   {
      switch(num[i])
      {
	 case '2': flip[i] = '5';
		   break;
	 case '5': flip[i] = '2';
		   break;
	 default:  flip[i] = num[i];
      }
      i++;
   }
   flip[i] = '\0';

}
