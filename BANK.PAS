program Bank;

type

  (* person - This data type holds the information for each person who  *)
  (*          enters the bank.                                          *)
  person = record
             name : string [15];
             transaction : string [22];
             intime, outtime, tranlen : longint;
             openteller, giveuptime : longint;
           end;

  (* linequeue - This data type is for the people in line at the bank   *)
  (*             and for the output list.                               *)
  linequeue = array [ 1..500 ] of person;

  (* tellerlist - This list is for the people who are currently being   *)
  (*              serviced by a teller.                                 *)
  tellerlist = array [ 1..5 ] of person;

var

  infile : text;               (* input file                            *)

  queue,                       (* people standing in line               *)
  outputlist : linequeue;      (* people already processed              *)

  teller : tellerlist;         (* people standing at a teller           *)

  numberofpeople,              (* number of people in the data set      *)
  peopleinline,                (* number of people in line              *)
  tellersbusy,                 (* number of tellers currently busy      *)
  outputlistlen,               (* number of people already processed    *)
  currentperson : integer;     (* loop variable for reading input       *)

  nextperson : person;         (* the nextperson to enter the bank      *)

  time : longint;              (* the current time of day               *)


(* -------------------------------------------------------------------- *)
(* addteller - This procedure adds a person to the list of free         *)
(*             tellers.  If the person would have given up by the       *)
(*             time this procedure was called, she is moved to the      *)
(*             output list instead.                                     *)
(* -------------------------------------------------------------------- *)

procedure addteller ( aperson : person );
var
  i : integer;
begin

  if ( aperson.giveuptime < aperson.openteller ) then
    begin

      (* Append a 'NO' to the transaction because the person gave up,   *)
      (* and set the time of departure to the time she gave up          *)

      aperson.transaction := aperson.transaction + '/NO ';
      aperson.outtime := aperson.giveuptime;

      (* Add her to the output list.                                    *)

      outputlistlen := outputlistlen + 1;
      outputlist [outputlistlen] := aperson;

    end
  else
    begin

      (* Append a 'YES' to the transaction beacuse the person is        *)
      (* now being processed.                                           *)

      aperson.transaction := aperson.transaction + '/YES';
      aperson.outtime := aperson.openteller + aperson.tranlen;

      (* Add her to the teller list.  Note: the list is kept sorted     *)
      (* by a simple insertion sort so the first person to leave the    *)
      (* set of tellers is always in the first position.                *)

      tellersbusy := tellersbusy + 1;
      i := tellersbusy;

      while ( i > 1 ) and ( aperson.outtime < teller [i-1].outtime )  do
        begin

          teller [i] := teller [i-1];
          i := i-1;

        end;

      teller [i] := aperson;

    end;

end;

(* -------------------------------------------------------------------- *)
(* removeteller - Take the first person out of the teller list.  The    *)
(*                time a departure is saved for use later to determine  *)
(*                when the next person will receive processing          *)
(* -------------------------------------------------------------------- *)

function removeteller : integer;
var
  i : integer;
begin

  (* Add the person to the output list.                                 *)

  outputlistlen := outputlistlen + 1;
  outputlist [outputlistlen] := teller [1];

  (* Save the departure time, and remove the first person from the list *)

  tellersbusy := tellersbusy - 1;
  for i := 1 to tellersbusy do
    teller [i] := teller [i+1];

  removeteller := outputlist [outputlistlen].outtime;

end;

(* -------------------------------------------------------------------- *)
(* addqueue - Add a person to the line.  If a teller is open, the       *)
(*            goes straight to an open teller, otherwise he is add to   *)
(*            the end of the list.                                      *)
(* -------------------------------------------------------------------- *)

procedure addqueue ( aperson : person );
begin

  if tellersbusy < 5 then
    begin

      (* person goes to the teller                                      *)

      aperson.openteller := time;
      addteller ( aperson );

    end
  else
    begin

      (* person has to wait                                             *)

      peopleinline := peopleinline + 1;
      queue [peopleinline] := aperson;

    end;

end;

(* -------------------------------------------------------------------- *)
(* removequeue - Remove the first person from the queue.                *)
(* -------------------------------------------------------------------- *)

procedure removequeue ( var aperson : person );
var
  i : integer;
begin

  aperson := queue [1];

  peopleinline := peopleinline - 1;
  for i := 1 to peopleinline do
    queue [i] := queue [i+1];

end;

(* -------------------------------------------------------------------- *)
(* updatequeue - This procedure takes care of most of the work.  As     *)
(*               long as there is an open teller and the line is not    *)
(*               empty, people are moved from the queue line to an      *)
(*               available teller.                                      *)
(* -------------------------------------------------------------------- *)

procedure updatequeue;
var
  i, freeteller : integer;
  nextperson : person;
begin

  while ( tellersbusy > 0 ) and ( teller [1].outtime <= time ) or
        ( tellersbusy < 5 ) and ( peopleinline > 0 ) do
    begin

      (* If a teller has finished with a customer, remove the person    *)
      (* and save the time of departure for the next customer.  If not, *)
      (* then the customer must enter the teller list at the current    *)
      (* time.                                                          *)

      if ( tellersbusy > 0 ) and ( teller [1].outtime <= time ) then
        freeteller := removeteller
      else
        freeteller := time;

      (* If there is someone in line, remove him and move him into the  *)
      (* teller list at the time determined above                       *)

      if ( peopleinline > 0 ) then
        begin

          removequeue ( nextperson );
          if freeteller > nextperson.intime then
            nextperson.openteller := freeteller
          else
            nextperson.openteller := nextperson.intime;
          addteller ( nextperson );

        end;

    end;

end;

(* -------------------------------------------------------------------- *)
(* cleanqueue - This procedure takes care of the remaining customers    *)
(*              after all input has been read for the current data set. *)
(* -------------------------------------------------------------------- *)

procedure cleanqueue;
begin

  (* While a teller is still busy, remove the first person, and update  *)
  (* update the queue.                                                  *)

  while ( tellersbusy > 0 ) do
    begin

      (* Set the current time to the time of departure, and update the  *)
      (* queue to take care of any customers that are still in line     *)

      time := teller [1].outtime;
      updatequeue;

    end;

end;

(* -------------------------------------------------------------------- *)
(* writelist - Sort the output list by arrival time, and print it out   *)
(* -------------------------------------------------------------------- *)

procedure writelist;
var
  i,j : integer;
  temp : person;
begin

  (* Sort the list using the insertion sort.                            *)

  for j := 2 to outputlistlen do
    begin

      i := j;
      temp := outputlist [i];
      while ( i > 1 ) and ( temp.intime < outputlist [i-1].intime ) do
        begin

          outputlist [i] := outputlist [i-1];
          i := i - 1;

        end;

      outputlist [i] := temp;

    end;

  (* For each person in the output list, print the information required *)
  (* by the problem specification.                                      *)

  for i := 1 to outputlistlen do
    begin

      write ( outputlist [i].name );
      for j := length ( outputlist [i].name ) + 1 to 16 do
        write ( ' ' );

      write ( outputlist [i].transaction );

      for j := length ( outputlist [i].transaction ) + 1 to 23 do
        write ( ' ' );

      writeln ( outputlist [i].intime:8, outputlist [i].outtime:10 );

    end;

end;

(* -------------------------------------------------------------------- *)
(* getperson - Get a new person from the input file.                    *)
(* -------------------------------------------------------------------- *)

procedure getperson ( var nextperson : person );
var
  amount : real;
  code : integer;
  ch : char;
begin

  nextperson.name := '';
  read ( infile, ch );

  (* Read the next person's name until the first space.                 *)

  while ch <> ' ' do
    begin

      nextperson.name := nextperson.name + ch;
      read ( infile, ch );

    end;

  (* Read the arrival time and the wait time for the next person.       *)

  read ( infile, nextperson.intime, nextperson.giveuptime );
  nextperson.intime := nextperson.intime + time;
  time := nextperson.intime;
  nextperson.giveuptime := nextperson.giveuptime + nextperson.intime;

  (* Read the extra space, and the rest of the line is the transaction. *)

  read ( infile, ch );
  readln ( infile, nextperson.transaction );

  (* This if-then block determines the type of transaction and the      *)
  (* amount of time it will take.                                       *)

  if pos ('DEPOSIT', nextperson.transaction ) > 0 then
    nextperson.tranlen := 5

  else if pos ('WITHDRAW', nextperson.transaction ) > 0 then
    begin
      val ( copy ( nextperson.transaction,
                   pos ( '$', nextperson.transaction ) + 1,
                   length ( nextperson.transaction ) -
                     pos ( '$', nextperson.transaction )
                 ),
            amount, code );
      nextperson.tranlen := 7 + trunc ( amount + 99.99 ) div 100;
    end

  else if pos ('CASHIERS_CHECK', nextperson.transaction ) > 0 then
    nextperson.tranlen := 10

  else if pos ('LOAN', nextperson.transaction ) > 0 then
    begin
      val ( copy ( nextperson.transaction,
                   pos ( '$', nextperson.transaction ) + 1,
                   length ( nextperson.transaction )-
                     pos ( '$', nextperson.transaction )
                 ),
            amount, code );
      nextperson.tranlen := 50 + trunc ( amount + 99.99 ) div 100 * 3;
    end

  else if pos ('ACCOUNT_BALANCE', nextperson.transaction ) > 0 then
    nextperson.tranlen := 2

  else if pos ('ATM_CARD', nextperson.transaction ) > 0 then
    nextperson.tranlen := 20

  else if pos ('OPEN_ACCOUNT', nextperson.transaction ) > 0 then
    nextperson.tranlen := 30

  else
    writeln ('Bad judge data: ', nextperson.transaction );

end;

(* -------------------------------------------------------------------- *)
(*                          The main program                            *)
(* -------------------------------------------------------------------- *)
begin

  (* Open the input file.                                               *)

  assign ( infile, 'bank.in' );
  reset ( infile );

  while not eof ( infile ) do
    begin

      (* Reset the variables for the current data set.                  *)

      peopleinline := 0;
      tellersbusy := 0;
      outputlistlen := 0;
      time := 0;

      (* Read the number of people, and print the header.               *)

      readln ( infile, numberofpeople );

      writeln ('CUSTOMER        TRANSACTION/COMPLETED        IN       OUT ');
      writeln ('----------------------------------------------------------');

      (* Loop once for each person in the data set.                     *)

      for currentperson := 1 to numberofpeople do
        begin

          (* Get the next person, add her to the queue, and call        *)
          (* updatequeue.                                               *)

          getperson ( nextperson );
          addqueue ( nextperson );
          updatequeue;

        end;

      (* Finish anyone who might to left.                               *)

      cleanqueue;

      (* Write out the list with two extra blank lines to separate the  *)
      (* data sets.                                                     *)

      writelist;
      writeln; writeln;

    end;

  close ( infile );

end.