program snail;

var infile:text;                         (* Input file                     *)
    ch:char;                             (* Char to hold spaces from input *)
    matrix:array[1..25,1..25] of char;   (* Input matrix                   *)
    numRows, numColumns:integer;         (* Size of input matrix           *)
    x, y:integer;                        (* Variables for loops            *)
    used:array[0..26,0..26] of boolean;  (* Used flags including a border  *)
    currX, currY:integer;                (* Current position in input      *)
    dx, dy:integer;                      (* Deltas for direction           *)
    count:integer;                       (* Count of characters outputted  *)

begin
   (* Open input file *)
   assign(infile, 'snail.in');
   reset(infile);

   (* Process all of the file *)
   while not eof(infile) do
   begin
      (* Initialize used flag for each possible input element *)
      for y:=0 to 26 do
      begin
         for x:=0 to 26 do
            used[y, x]:=false;
      end;

      (* Read in size of next input case *)
      readln(infile, numRows, numColumns);

      (* Define a border around the input matrix.  This makes it easy    *)
      (* to tell when we have to change directions.  Just keep following *)
      (* path until the "used" flag is true.                             *)
      for x:=0 to numColumns+1 do
      begin
         used[0, x]:=true;
         used[numRows+1, x]:=true;
      end;
      for y:=0 to numRows+1 do
      begin
         used[y, 0]:=true;
         used[y, numColumns+1]:=true;
      end;

      (* Read the input matrix *)
      for y:=1 to numRows do
      begin
         for x:=1 to numColumns do
         begin
            read(infile, ch);
            matrix[y, x]:=ch;

            (* Skip the spaces between letters *)
            if x < numColumns then
               read(infile, ch);
         end;
         readln(infile);
      end;

      (* Initialize variables.  We start at location (1, 1) *)
      (* and go right (dx=1, dy=0).                         *)
      currX:=1;
      currY:=1;
      dx:=1;
      dy:=0;

      (* Continue output until all letters have been used *)
      count:=0;
      while (count < numRows*numColumns) do
      begin
         (* Continue current direction until a "used" flag is true *)
         while used[currY, currX] = false do
         begin
            (* Output character, mark it as used, and increment the count *)
            write(matrix[currY, currX]);
            used[currY, currX]:=true;
            count:=count + 1;

            (* Move to next character *)
            currY:=currY + dy;
            currX:=currX + dx;
         end;

         (* We have run out of unused elements in the current direction so *)
         (* now we have to change direction to do a "snail."               *)

         (* If we were going right, then go down *)
         if (dx = 1) and (dy = 0) then
         begin
            (* Move current index to the proper element (we went one too *)
            (* far and we have to go down now)                           *)
            currX:=currX - 1;
            currY:=currY + 1;
            dx:=0;
            dy:=1;
         end
         else if (dx = 0) and (dy = 1) then
         begin
            (* We were going down, now we have to go left *)
            currX:=currX - 1;
            currY:=currY - 1;
            dx:=-1;
            dy:=0;
         end
         else if (dx = -1) and (dy = 0) then
         begin
            (* We were going left, now we have to go up *)
            currX:=currX + 1;
            currY:=currY - 1;
            dx:=0;
            dy:=-1;
         end
         else
         begin
            (* We were going up, now we have to go right *)
            currX:=currX + 1;
            currY:=currY + 1;
            dx:=1;
            dy:=0;
         end;
      end;

      (* Finish the line and leave a blank one *)
      writeln;
      writeln;
   end;

   (* Close the input file *)
   close(infile);
end.