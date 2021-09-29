#include <stdio.h>

void main(void)
{
   FILE   *infile;   /* Input file pointer */
   char   ch;        /* Current character in input file */

   /* Assume the input file exists and open it for reading */
   infile = fopen("vocal.in", "r");

   /* Process file until end of it */
   while (!feof(infile))
   {
      /* Get the first character */
      ch = fgetc(infile);

      /* Keep looping until either end-of-file or end-of-line (newline) */
      while ( (!feof(infile)) && (ch != '\n') )
      {
	 /* If the current character is one of the special ones needed to */
	 /* be converted to a sound, output the sound representation.     */
	 /* Otherwise, just output the character unchanged.               */
	 switch (ch)
	 {
	    case '.':
	       printf("[pthut]");
	       break;
	    case '!':
	       printf("[phsss-pthut]");
	       break;
	    case ',':
	       printf("[pst]");
	       break;
	    case '-':
	       printf("[fshhh]");
	       break;
	    case '\'':
	       printf("[chic]");
	       break;
	    case '"':
	       printf("[chic-chic]");
	       break;
	    case '?':
	       printf("[pssu-pthut]");
	       break;
	    default:
	       printf("%c", ch);
	       break;
	 }

	 /* Get the next character */
	 ch = fgetc(infile);
      }

      /* We reached end-of-line so write a newline on the output */
      printf("\n");
   }

   /* Close the input file */
   fclose(infile);
}