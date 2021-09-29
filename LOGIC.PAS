program Logic( input, output );

var
    infile : text;
    ch : char;
    i : integer;
    blue, red, yellow, green, orange : boolean;

procedure Setup;
begin
    blue   := false;
    red    := false;
    yellow := false;
    green  := false;
    orange := false;
end;

procedure MarkSeen( color : char );
begin
    if color = 'B' then blue := true
    else if color = 'R' then red := true
    else if color = 'Y' then yellow := true
    else if color = 'G' then green := true
    else orange := true;
end;

procedure WriteRemaining;
begin
    if not blue then write( 'Blue' )
    else if not red then write( 'Red' )
    else if not yellow then write( 'Yellow' )
    else if not green then write( 'Green' )
    else write( 'Orange' );
end;

begin
    assign( infile, 'logic.in' );
    reset( infile );

    while not eof( infile ) do
    begin
        Setup;

        for i := 1 to 4 do
        begin
            read( infile, ch );
            MarkSeen( ch );
        end;
        readln( infile );

        write( 'It''s ' );
        WriteRemaining;
        writeln( '!' );
    end;

    close( infile );
end.
