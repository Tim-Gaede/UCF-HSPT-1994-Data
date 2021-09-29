(************************************************************************)
(*                                                                      *)
(*                    University of Central Florida                     *)
(*            8th Annual High School Programming Tournament             *)
(*                        Friday, May 13, 1994                          *)
(*                                                                      *)
(*                Pascal solution for: "Nothin' But Net"                *)
(*                                                                      *)
(************************************************************************)

Program Nothin ;

Const
     MAX_OBJECTS  = 20 ; (* Maximum number of objects        *)
     MAX_NAME_LEN = 30 ; (* Maximum length of an object name *)

Type
     (* For storing an object number/action pair *)
     PathEntry = record
          obj_num : Integer ; (* Sequence number of the object      *)
          action  : Integer ; (* 1 - off, 2 - through or 3 - around *)
     End ;

     (* For storing connectivity matricies *)
     MatrixType = Array[1..MAX_OBJECTS-1, 1..MAX_OBJECTS] of Integer ;

     (* For storing object name lists *)
     NameListType = Array[1..MAX_OBJECTS] of String[MAX_NAME_LEN] ;

     (* For storing paths to the net *)
     PathType = Array[1..MAX_OBJECTS] of PathEntry ;

Var

     fhand     : Text ;         (* Input file handle            *)
     num       : Integer ;      (* Number of objects            *)
     i, j      : Integer ;      (* Counter variables            *)
     start     : Integer ;      (* Starting object              *)
     matrix    : MatrixType ;   (* Object connectivity matrix   *)
     name_list : NameListType ; (* Object name list             *)
     cur_path  : PathType ;     (* Current path being traversed *)


(************************************************************************)
(*                                                                      *)
(* Function: FindPath                                                   *)
(*                                                                      *)
(* This is a recursive function.  At each level of recursion it checks  *)
(* first to see if the object passed in is the net.  If this is the     *)
(* case, then a valid path to the net has been found and True will be   *)
(* returned immediately at each level of recursion until it returns to  *)
(* the original calling routine.  If the object is not the net, then it *)
(* adds the object to the path array at the given index, and calls      *)
(* itself recursively for each object to which the current object has a *)
(* connection or until a path is found.  Note that the net object is    *)
(* also stored in the path array to indicate the end of the path, but   *)
(* no action exists for the net object, so nothing is stored.           *)
(*                                                                      *)
(************************************************************************)

Function FindPath( objct, index : Integer ) : Boolean ;

     Var
          i     : Integer ; (* Counter                       *)
          found : Boolean ; (* True if a path has been found *)

     Begin
          (* Store the object number in the current path entry. *)
          cur_path[index].obj_num := objct ;

          if objct = num then
          Begin
               (* We reached the net!  Return True. *)
               FindPath := True ;
          End
          else
          Begin
               (* Loop through matrix columns until we find a path or *)
               (* we run out of columns.                              *)
               found := False ;
               i := 1 ;
               while ( i <= num ) and ( not found ) do
               Begin
                    if matrix[objct][i] > 0 then
                    Begin
                         (* We found a connection. Store the action and *)
                         (* see if it leads to the net.                 *)
                         cur_path[index].action := matrix[objct][i] ;
                         found := FindPath( i, index + 1 ) ;
                    End ;
                    i := i + 1 ;
               End ;

               (* Found or not, we are done. *)
               FindPath := found ;
          End ;
     End ;


(************************************************************************)
(*                                                                      *)
(* Procedure: PrintPath                                                 *)
(*                                                                      *)
(* This procedure loops through the solution path, converting it to the *)
(* required output sentence format.                                     *)
(*                                                                      *)
(************************************************************************)

Procedure PrintPath ;

     Var
          i : Integer ; (* Counter *)

     Begin
          (* Treat the first object separate since we need to capitalize. *)
          if cur_path[1].obj_num = num then
          Begin
               (* We hit the net! *)
               writeln( 'Nothin'' but net.' ) ;
          End
          else
          Begin
               (* Switch on the action. *)
               case cur_path[1].action of
                    1 : write( 'Off the ' ) ;
                    2 : write( 'Through the ' ) ;
                    3 : write( 'Around ' ) ;
               End ;
               write( name_list[cur_path[1].obj_num], ', ' ) ;
          End ;

          (* Loop until we hit the net. *)
          i := 1 ;
          while cur_path[i].obj_num <> num do
          Begin
               i := i + 1 ;
               if cur_path[i].obj_num = num then
               Begin
                    (* We hit the net! *)
                    writeln( 'nothin'' but net.' ) ;
               End
               else
               Begin
                    (* Switch on the action. *)
                    case cur_path[i].action of
                         1 : write( 'off the ' ) ;
                         2 : write( 'through the ' ) ;
                         3 : write( 'around ' ) ;
                    End ;
                    write( name_list[cur_path[i].obj_num], ', ' ) ;
               End ;
          End ;
          writeln ;
     End ;


(***************************************************************************)
(*                                                                         *)
(* Body of Program                                                         *)
(*                                                                         *)
(* The program body loops until end of file processing data sets.  For     *)
(* each data set it read in the object names and connectivity matrix.  It  *)
(* then loops through the starting objects, calling FindPath to generate a *)
(* path to the net, and PrintPath to output the path.                      *)
(*                                                                         *)
(***************************************************************************)

Begin
     assign( fhand, 'nothin.in' ) ;
     reset( fhand ) ;
     while not eof( fhand ) do
     Begin
          (* In case of blank lines at the bottom of the file... *)
          if eoln( fhand ) then
          Begin
               readln( fhand ) ;
          End
          else
          Begin
               readln( fhand, num ) ;

               (* Read in the object names. *)
               for i := 1 to num - 1 do
               Begin
                    readln( fhand, name_list[i] ) ;
               End ;

               (* Read in the connectivity matrix. *)
               for i := 1 to num - 1 do
               Begin
                    for j := 1 to num do
                    Begin
                         read( fhand, matrix[i][j] ) ;
                    End ;
                    readln( fhand ) ;
               End ;

               (* Loop through starting objects until a zero is read. *)
               readln( fhand, start ) ;
               while start <> 0 do
               Begin
                    (* Find a path to the net *)
                    if not FindPath( start, 1 ) then
                    Begin
                         (* This should never happen! *)
                         Writeln( 'ERROR: No path was found!!!' ) ;
                    End
                    else
                    Begin
                         (* Print out the path found. *)
                         PrintPath ;
                    End ;

                    readln( fhand, start ) ;
               End ;
          End ;
     End ;
End.

