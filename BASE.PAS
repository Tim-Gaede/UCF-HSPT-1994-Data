program base;

Var
  String1, String2 : String;                     { The two input strings }
  Used1, Used2     : Array['a'..'z'] of boolean; { Stores what is used   }
  F                : Text;                       { The input file        }



{ Procedure ClearUsed;

  This procedure clears the two used arrays.

  INPUT
    none

  RETURNS
    nothing
}
Procedure ClearUsed;
Var
  Count : Char;
Begin
  For Count := 'a' to 'z' Do
    Begin
      Used1[Count] := False;
      Used2[Count] := False;
    End;
End;



{ Procedure PrintShared;

  This loops through Used1 and outputs if true, thus outputing all
of the letters used by String1. It prints the letters out with commas
inbetween them, and does NOT add a carriage return

  INPUT
    none

  RETURNS
    nothing
}
Procedure PrintShared;
Var
  Count : Char;
  first : boolean;

Begin
  First := True;
  For Count := 'a' to 'z' Do
    If Used1[Count] then
    Begin
      if not first then
        Write(', ');
      Write(Count);
      First := False
    End;
End;








Var
  Count : integer;
  Count2 : Char;
  same   : Boolean;  { used to store if the two strings use the same alpha. }

Begin
  Assign(F,'Base.in');
  Reset(F);
  While not eof(F) Do
    Begin
      { Read in the two strings and print them so I can do whatever I
        want to them next }
      Readln(F,String1);
      Writeln(String1);
      Readln(F,String2);
      Writeln(String2);

      { Make sure all is in readiness }
      ClearUsed;

      { Set the values in the Used arrays }
      For Count := 1 to Length(String1) Do
        Used1[String1[Count]] := True;
      For Count := 1 to Length(String2) Do
        Used2[String2[Count]] := True;

      { Determine sameness of alphabet by determining if the two
        Used arrays are equal }
      same := true;
      For Count2 := 'a' to 'z' Do
        if Used1[count2] <> used2[Count2] then
          same := False;
      if same then
        Begin
          Write('The words share the base alphabet (');
          PrintShared;
          Writeln(').');
        End
      else
        Writeln('The words do not share the same base alphabet.');
      Writeln;
    End;
End.