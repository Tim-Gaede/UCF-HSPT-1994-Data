(************************************************************************)
(*                                                                      *)
(*                    University of Central Florida                     *)
(*            8th Annual High School Programming Tournament             *)
(*                        Friday, May 13, 1994                          *)
(*                                                                      *)
(*                Pascal solution for: "Dimwit Numbers"                 *)
(*                                                                      *)
(************************************************************************)

Program Dimwit ;

Type
     DimNum = Array[1..4] of Integer ; (* Holds Dimwit numbers and bases *)

Var
     num_cons  : Integer ; (* Number of conversions to perform             *)
     c, i, j   : Integer ; (* Counters                                     *)
     fhand     : Text ;    (* Input file handle                            *)
     in_val    : DimNum ;  (* Holds Dimwit number read in                  *)
     out_val   : DimNum ;  (* Holds converted Dimwit number                *)
     dec_val   : Integer ; (* Holds decimal conversion of original number  *)
     mult      : Integer ; (* Multiplyer used for conversion               *)
     from_base : DimNum ;  (* Holds Dimwit base to be converted from       *)
     to_base   : DimNum ;  (* Holds Dimwit base to be converted to         *)
     overflow  : Boolean ; (* Overflow flag                                *)


(***************************************************************************)
(*                                                                         *)
(* Procedure: ReadNum                                                      *)
(*                                                                         *)
(* This procedure skips the specified number of character in the input     *)
(* file and then reads in the next four characters, converts them to       *)
(* integers, and stores them in the specified DimNum array in reverse      *)
(* order.                                                                  *)
(*                                                                         *)
(***************************************************************************)

Procedure ReadNum(
     Var dnum    : DimNum ;    (* Array to store values read               *)
     skip        : Integer ) ; (* Number of chars to skip before reading   *)

     Var
          i    : Integer ; (* Counter                                      *)
          temp : Char ;    (* Used for reading in numbers                  *)

     Begin
          for i := 1 to skip do
               read( fhand, temp ) ;
          for i := 4 downto 1 do
          Begin
               read( fhand, temp ) ;
               dnum[i] := Ord( temp ) - Ord( '0' ) ;
          End ;
     End ;


(***************************************************************************)
(*                                                                         *)
(* Body of Program                                                         *)
(*                                                                         *)
(* The program body reads in the number of data sets and loops through     *)
(* them.  For each one it uses ReadNum to get the number to convert and    *)
(* the source and target bases.  Each number is converted from the source  *)
(* base to its decimal equivalent, and from there to the target base.  It  *)
(* then prints out the result.                                             *)
(*                                                                         *)
(***************************************************************************)

Begin
     assign( fhand, 'dimwit.in' ) ;
     reset( fhand ) ;
     readln( fhand, num_cons ) ;
     for c := 1 to num_cons do
     Begin
          (* Read in the number to convert. *)
          ReadNum( in_val, 0 ) ;

          (* Read in base to convert from. *)
          ReadNum( from_base, 3 ) ;

          (* Read in base to convert to. *)
          ReadNum( to_base, 3 ) ;

          (* Convert from original base to decimal. *)
          mult := 1 ;
          dec_val := 0 ;
          for i := 1 to 4 do
          Begin
               dec_val := dec_val + in_val[i] * mult ;
               mult := mult * ( from_base[i] + 1 ) ;
          End ;

          (* Convert from decimal to output base. *)
          overflow := False ;
          for i := 1 to 4 do
               out_val[i] := 0 ;
          i := 1 ;
          while ( not overflow ) and ( i <= dec_val ) do
          Begin
               out_val[1] := out_val[1] + 1 ;
               for j := 1 to 4 do
               Begin
                    if out_val[j] > to_base[j] then
                    Begin
                         if j = 4 then
                              overflow := True
                         else
                         Begin
                              out_val[j] := 0 ;
                              out_val[j+1] := out_val[j+1] + 1 ;
                         End ;
                    End ;
               End ;
               i := i + 1 ;
          End ;

          (* Write the result. *)
          if overflow then
               writeln( 'OVERFLOW' )
          else
          Begin
               for i := 4 downto 1 do
                    write( out_val[i]:1 ) ;
               writeln ;
          End ;

          (* Skip past the end of the input line. *)
          readln( fhand ) ;
     End ;
End.

