program Driver( input, output );

const
      MAX_BACK_SEAT_DRIVERS = 15;

var
    infile : text;
    sentences : array[1..MAX_BACK_SEAT_DRIVERS] of string;
    num_back_seat_drivers, i, current_driver, best_driver,
    most_exclamations, count : integer;
    ch : char;

function CountExclamations( person : integer ) : integer;
var i,result : integer;
begin
    result := 0;
    for i := 1 to length(sentences[person]) do
    begin
        if sentences[person][i] = '!' then
            result := result + 1;
    end;
    CountExclamations := result;
end;

begin
    assign( infile, 'driver.in' );
    reset( infile );

    while not eof( infile ) do
    begin
        readln( infile, num_back_seat_drivers );

        for i := 1 to num_back_seat_drivers do
            sentences[i] := '';

        current_driver := 1;

        while (not eof( infile )) and (not eoln( infile )) do
        begin
            read( infile, ch );
            if ch <> '!' then
                sentences[current_driver] := sentences[current_driver] + ch
            else
            begin
                if (not eof( infile )) and (not eoln( infile )) then
                begin
                    read( infile, ch );
                    if ch = '!' then
                        sentences[current_driver] := sentences[current_driver] + '!'
                    else
                    begin
                        current_driver := current_driver + 1;
                        if current_driver > num_back_seat_drivers then
                            current_driver := 1;
                        sentences[current_driver] := sentences[current_driver] + ch;
                    end;
                end;
            end;
        end;

        readln( infile );

        for i := 1 to num_back_seat_drivers do
            writeln( 'Person #', i:1, ':  ', sentences[i] );

        best_driver := 1;
        most_exclamations := CountExclamations( 1 );
        for i := 2 to num_back_seat_drivers do
        begin
            count := CountExclamations( i );
            if count > most_exclamations then
            begin
                best_driver := i;
                most_exclamations := count;
            end;
        end;

        writeln( 'Follow person #', best_driver:1, ':  ', sentences[best_driver] );
        writeln;
    end;

    close( infile );
end.