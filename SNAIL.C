#include <stdio.h>

#define TRUE   1
#define FALSE  0

main()
{
   FILE   *infile;                /* Input file pointer             */
   char   ch;                     /* Char to hold spaces from input */
   char   matrix[26][26];         /* Input matrix                   */
   int    numRows, numColumns;    /* Size of input matrix           */
   int    x, y;                   /* Variables for loops            */
   int    used[27][27];           /* Used flags including a border  */
   int    currX, currY;           /* Current position in input      */
   int    dx, dy;                 /* Deltas for direction           */
   int    count;                  /* Count of characters outputed   */

   /* Open input file */
   infile = fopen("snail.in", "r");

   /* Process all of the file */
   while (!feof(infile))
   {
      /* Initialize used flags for all matrix elements */
      for (y=0; y < 27; y++)
      {
	 for (x=0; x < 27; x++)
	    used[y][x]=FALSE;
      }

      /* Read in size of next input case */
      fscanf(infile, "%d %d", &numRows, &numColumns);

      /* Get rid of \n */
      ch = fgetc(infile);

      /* Define a border around the input matrix.  This makes it easy    */
      /* to tell when we have to change directions.  Just keep following */
      /* path until the "used" flag is true.                             */
      for (x=0; x <= numColumns+1; x++)
      {
	 used[0][x]=TRUE;
	 used[numRows+1][x]=TRUE;
      }
      for (y=0; y <= numRows+1; y++)
      {
	 used[y][0]=TRUE;
	 used[y][numColumns+1]=TRUE;
      }

      /* Read the input matrix */
      for (y=1; y <= numRows; y++)
      {
	 for (x=1; x <= numColumns; x++)
	 {
	    matrix[y][x] = fgetc(infile);

	    /* Skip the spaces between letters */
	    if (x < numColumns)
	       ch = fgetc(infile);
	 }

	 /* Get rid of \n */
	 ch = fgetc(infile);
      }

      /* Initialize variables.  We start at location (1, 1) */
      /* and go right (dx=1, dy=0).                         */
      currX=1;
      currY=1;
      dx=1;
      dy=0;

      /* Continue output until all letters have been used */
      count=0;
      while (count < numRows*numColumns)
      {
	 /* Continue current direction until a "used" flag is true */
	 while (used[currY][currX] == FALSE)
	 {
	    /* Output character, mark it as used, and increment the count */
	    printf("%c", matrix[currY][currX]);
	    used[currY][currX]=TRUE;
	    count++;

	    /* Move to next character */
	    currY=currY + dy;
	    currX=currX + dx;
	 }

	 /* We have run out of unused elements in the current direction so */
	 /* now we have to change direction to do a "snail."               */

	 /* If we were going right, then go down */
	 if ( (dx == 1) && (dy == 0) )
	 {
	    /* Move current index to the proper element (we went one too */
	    /* far and we have to go down now)                           */
	    currX=currX - 1;
	    currY=currY + 1;
	    dx=0;
	    dy=1;
	 }
	 else if ( (dx == 0) && (dy == 1) )
	 {
	    /* We were going down, now we have to go left */
	    currX=currX - 1;
	    currY=currY - 1;
	    dx=-1;
	    dy=0;
	 }
	 else if ( (dx == -1) && (dy == 0) )
	 {
	    /* We were going left, now we have to go up */
	    currX=currX + 1;
	    currY=currY - 1;
	    dx=0;
	    dy=-1;
	 }
	 else
	 {
	    /* We were going up, now we have to go right */
	    currX=currX + 1;
	    currY=currY + 1;
	    dx=1;
	    dy=0;
	 }
      }

      /* Finish the line and leave a blank one */
      printf("\n\n");
   }

   /* Close the input file */
   fclose(infile);
}
