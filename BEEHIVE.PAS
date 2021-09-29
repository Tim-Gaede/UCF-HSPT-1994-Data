program Beehive;


var
  Screen : Array[1..80,1..30] of char;  { The Virtual screen            }
  MaxY   : Integer;                     { How tall the used portion is  }
  Columns: Array[1..20] of integer;     { How many cells in each column }
  NumCol : integer;                     { How many columns              }
  F      : Text;                        { Input file                    }


{ Procedure Cls;

  This procedure clears the virtual screen.
  NumCol and MaxY are also cleared.

  INPUT
    none

  RETURNS
    nothing
}
Procedure Cls;
Var
  Count, Count2 : integer;

Begin
  For Count2 := 1 to 30 Do
    For Count := 1 to 80 Do
      Screen[Count, Count2] := ' ';
  NumCol := 0;
  MaxY := 0;
End;



{ Procedure PrintScreen;

  This procedure outputs the virtual screen.  It will output
MaxY rows of Screen.

  INPUT
    none

  RETURNS
    nothing
}
Procedure PrintScreen;
Var
  Count, Count2 : integer;

Begin
  For Count2 := 1 to MaxY Do
    Begin
      For Count := 1 to 79 Do
        Write (Screen[Count,Count2]);
      Writeln;
    End;
End;



{ Procedure DrawCell(x,y : integer; birthing : boolean);

  This procedure draws a beehive cell onto the virtual screen.

  INPUT
    x        : The x coordinate of the cell in honeycomb coordinates.
    y        : The y coordinate of the cell in honeycomb coordinates.
    birthing : True if this cell is to be drawn with a 'Q' in it.

  RETURNS
    nothing
}
Procedure DrawCell(x,y : integer; birthing : boolean);
var
  ScreenX, ScreenY : integer;  { Screen Coordinates }

begin
  {Convert honeycomb coordinates to screen coordinates.  Note that
   nothing is drawn at (ScreenX, ScreenY).}
  ScreenX := 1 + (x - 1) * 2;
  ScreenY := 1 + (y - 1) * 2;
  if (x mod 2 = 0) then
    ScreenY := ScreenY + 1;

  {Draw the elements of the cell}
  Screen[ScreenX + 1,ScreenY] := '_';
  Screen[ScreenX,ScreenY + 1] := '/';
  Screen[ScreenX + 2,ScreenY + 1] := '\';
  Screen[ScreenX,ScreenY + 2] := '\';
  Screen[ScreenX+1,ScreenY + 2] := '_';
  Screen[ScreenX + 2,ScreenY + 2] := '/';
  if birthing then
    Screen[ScreenX+1,ScreenY + 1] := 'Q';

  {If this cell went below MaxY, MaxY needs to be incrememnted so
   this cell will be drawn}
  if ScreenY + 2 > MaxY then MaxY := ScreenY + 2;
end;



{ Procedure ReadCols;

  This procedure parses the first line of each input set, the column
data.  It uses Pos and Copy to grab each number off the input, then
deletes that number from the original string with Delete.

  INPUT
    none

  RETURNS
    When this proc. is done, NumCols is set properly.
}
Procedure ReadCols;
var
  InS  : String;   {Original String                             }
  SPos : integer;  {Position of next space                      }
  NumS : String;   {String into which the next number is copied }
  InV  : integer;  {The number is converted into here           }
  Jnk  : integer;

begin
  Readln(F,InS);
  Repeat
    {Set NumS to next number}
    SPos := Pos(' ',InS);
    if (SPos = 0) then
      NumS := InS
    else
      begin
        NumS := Copy(InS,SPos - 1,SPos-1);
        Delete(InS,1,SPos);
      end;
    {store Number in Columns}
    NumCol := NumCol + 1;
    Val(NumS,InV,Jnk);
    Columns[NumCol] := InV;
  Until SPos = 0;
end;




Var
  Count, Count2 : Integer;
  X, Y : Integer;

BEGIN
  Assign(F,'Beehive.in');
  Reset(F);
  While not EOF(F) Do
    Begin
      Cls;
      { Read in the honeycomb, drawing it out with blank cells }
      ReadCols;
      For Count := 1 to NumCol Do
        For Count2 := 1 to Columns[Count] Do
          DrawCell(Count,Count2,FALSE);

      { Read in the Birthing Cells, redrawing them over the blank cells }
      Readln(F,Count2);
      For Count := 1 to Count2 Do
      Begin
        Readln(F,X,Y);
        DrawCell(X,Y,TRUE);
      End;

      { Output the honeycomb }
      PrintScreen;
      Writeln;
    End;
   Close(F);
End.