#include <stdio.h>
#include <string.h>

  char   Screen[80][30];                /* The Virtual screen            */
  int    MaxY;                          /* How tall the used portion is  */
  int    Columns[20];                   /* How many cells in each column */
  int    NumCol;                        /* How many columns              */
  FILE   *F;                            /* Input file                    */


/* void Cls(void);

  This procedure clears the virtual screen.
  NumCol and MaxY are also cleared.

  INPUT
    none

  RETURNS
    nothing
*/
void Cls(void)
{
int Count,Count2;
  for (Count2 = 0; Count2 < 30; Count2++)
    for (Count = 0; Count < 80; Count++)
      Screen[Count][Count2] = ' ';
  NumCol = 0;
  MaxY = 0;
}



/* void PrintScreen(void);

  This procedure outputs the virtual screen.  It will output
MaxY rows of Screen.

  INPUT
    none

  RETURNS
    nothing
*/
void PrintScreen(void)
{
int Count, Count2;
  for (Count2 = 0; Count2 <= MaxY; Count2++)
    {
      for (Count = 0; Count < 79; Count++)
        printf("%c",Screen[Count][Count2]);
      printf("\n");
    }
}



/* void DrawCell(int x, int y int birthing);

  This procedure draws a beehive cell onto the virtual screen.

  INPUT
    x        : The x coordinate of the cell in honeycomb coordinates.
    y        : The y coordinate of the cell in honeycomb coordinates.
    birthing : True if this cell is to be drawn with a 'Q' in it.

  RETURNS
    nothing
*/
void DrawCell(int x, int y, int birthing)
{
int ScreenX, ScreenY;           /* Screen Coordinates */

  /*Convert honeycomb coordinates to screen coordinates.  Note that
   nothing is drawn at (ScreenX, ScreenY).*/
  ScreenX = (x - 1) * 2;
  ScreenY = (y - 1) * 2;
  if (x % 2 == 0)
    ScreenY++;

  /*Draw the elements of the cell*/
  Screen[ScreenX + 1][ScreenY] = '_';
  Screen[ScreenX][ScreenY + 1] = '/';
  Screen[ScreenX + 2][ScreenY + 1] = '\\';
  Screen[ScreenX][ScreenY + 2] = '\\';
  Screen[ScreenX+1][ScreenY + 2] = '_';
  Screen[ScreenX + 2][ScreenY + 2] = '/';
  if (birthing)
    Screen[ScreenX+1][ScreenY + 1] = 'Q';

  /*If this cell went below MaxY, MaxY needs to be incrememnted so
   this cell will be drawn*/
  if (ScreenY + 2 > MaxY)  MaxY = ScreenY + 2;
}



/* void ReadCols(void);

  This procedure parses the first line of each input set, the column data.
  The technique is kinda cheap, but I like it.

  INPUT
    none

  RETURNS
    When this proc. is done, NumCols is set properly.
*/
void ReadCols(void)
{
char InS[256];     /*Original String                             */
char NumS[256];    /*String into which the next number is copied */
int  InV;          /*The number is converted into here           */

  fgets(InS,255,F);
  InS[strlen(InS) - 1] = 0;
  NumCol = sscanf(InS,"%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d",
                  Columns,    &Columns[1],&Columns[2],&Columns[3],
                  &Columns[4],&Columns[5],&Columns[6],&Columns[7],
                  &Columns[8],&Columns[9],&Columns[10],&Columns[11],
                  &Columns[12],&Columns[13],&Columns[14],&Columns[15],
                  &Columns[16],&Columns[17],&Columns[18],&Columns[19]);
}




void main()
{
int Count, Count2;
int X, Y;
  F = fopen("beehive.in","rt");
  while (!feof(F))
  {
    Cls();
    /* Read in the honeycomb, drawing it out with blank cells */
    ReadCols();
    for (Count = 0; Count < NumCol; Count++)
      for (Count2 = 0; Count2 < Columns[Count]; Count2++)
        DrawCell(Count+1,Count2+1,0);
    /* Read in the Birthing Cells, redrawing them over the blank cells */
    fscanf(F,"%d",&Count2);
    for (Count = 0; Count < Count2; Count++)
    {
      fscanf(F,"%d %d\n",&X,&Y);
      DrawCell(X,Y,1);
    }

    /* Output the honeycomb */
    PrintScreen();
    printf("\n");
  }
 fclose(F);
}