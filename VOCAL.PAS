program vocal;

var infile:text;   (* Input file *)
    ch:char;       (* Current character from input file *)

begin
   (* Open the input file for reading *)
   assign(infile, 'vocal.in');
   reset(infile);

   (* Process the file until the end of it *)
   while not eof(infile) do
   begin

      (* For each character in the line, we want to read and process it *)
      while not eoln(infile) do
      begin

         (* Read a character from the input file *)
         read(infile, ch);

         (* If the character is one of the special characters that should *)
         (* be changed to a noise, output the appropriate noise string    *)
         case ch of
            '.': write('[pthut]');
            '!': write('[phsss-pthut]');
            ',': write('[pst]');
            '-': write('[fshhh]');
            '''': write('[chic]');
            '"': write('[chic-chic]');
            '?': write('[pssu-pthut]');
         else
            (* Otherwise, output the character unchanged *)
            write(ch);
         end;
      end;

      (* At end of line, tell the input file to go to next line and *)
      (* write out a CR/LF to go to the next line in the output     *)
      readln(infile);
      writeln;
   end;

   (* Close the input file *)
   close(infile);
end.