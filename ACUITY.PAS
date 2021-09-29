PROGRAM acuity;
(* This program reads the input from 'acuity.in' file.
   It uses functions is_valid and is_bigger and procedure
   get flipped. *)

VAR
   input : Text;
   number, flipped : String;
   valid , bigger : Boolean;

FUNCTION is_valid( Str: String) : Boolean;

VAR
   i , max : Integer;
   continue : Boolean;

BEGIN
     i := 1;
     is_valid := True;
     continue := True;
     max := Length(Str);

     WHILE (i <= max) AND (continue) DO
     BEGIN
          (* Only the 4, 6, 7, and 9 cause invalid numbers to be produced *)
          IF ((Str[i] = '4') OR (Str[i] = '6') OR
              (Str[i] = '7') OR (Str[i] = '9') ) THEN
          BEGIN
              is_valid := False;
              continue := False
          END;
          Inc(i);
     END;
END; {is_valid}

PROCEDURE get_flipped(num: String; VAR flip : String);

VAR
   i, max: Integer;

BEGIN
     (* copy string and string length *)
     max := Length(num);
     flip := num;

     FOR i := 1 TO max DO
     BEGIN
          (* Only the 2 and 5 get flipped to some other number *)
          CASE num[i] OF
               '2' : flip[i] := '5';
               '5' : flip[i] := '2';
          ELSE
              (* The rest stay the same *)
              flip[i] := num[i];
          END
     END
END; {get_flipped}


FUNCTION is_bigger(num1, num2 : String) : Boolean;

VAR
   i, max : Integer;
   big : Boolean;

BEGIN
     big := False;
     is_bigger := False;

     (* Determine which string is numerically bigger *)

     IF num1[1] <> '-' THEN
     BEGIN
        IF Ord(num1[0]) > Ord(num2[0]) THEN
           is_bigger := True
        ELSE IF Ord(num1[0]) = Ord(num2[0]) THEN
        BEGIN
           i := 1;
           max := Length(num1);
           WHILE (i <= max) AND  (NOT big) DO
           BEGIN
                IF num1[i] > num2[i] THEN
                BEGIN
                   is_bigger := True;
                   big := True
                END;
                Inc(i);
           END
        END
     END
     ELSE
     BEGIN
         IF Ord(num1[0]) < Ord(num2[0]) THEN
            is_bigger := True
         ELSE IF Ord(num1[0]) = Ord(num2[0]) THEN
         BEGIN
              i := 2;
              max := Length(num1);

              WHILE (i <= max) AND (NOT big) DO
              BEGIN
                   IF num1[i] < num2[i] THEN
                   BEGIN
                      is_bigger := True;
                      big := True
                   END;
                   Inc(i);
              END
         END
     END
END;  {is_bigger}


{ MAIN PROGRAM }

BEGIN
     (* Open the input file *)
     Assign(input, 'acuity.in');
     Reset(input);

     (* Process all input *)
     WHILE NOT EOF(input) DO
     BEGIN
          ReadLn(input, number);

          (* Check if the number will be valid if flipped *)
          valid := is_valid(number);
          IF valid THEN
          BEGIN
               (* Get the flipped number and compare it to original *)
               get_flipped(number, flipped);
               bigger := is_bigger(flipped, number);
               IF bigger THEN
                  WriteLn('Ali sees ', flipped, ', which is bigger than ', number, '.')

               ELSE
                  WriteLn('Ali sees ', flipped, ', which is not bigger than ', number, '.')
          END
          ELSE
              WriteLn('Ali does not see a valid number.');
      END;

      (* Close the input file *)
      Close(input)
END.