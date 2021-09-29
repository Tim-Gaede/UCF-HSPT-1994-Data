#include <stdio.h>
#include <string.h>

#define MAX_BACK_SEAT_DRIVERS  15
#define MAX_CHARS             255

char sentences[MAX_BACK_SEAT_DRIVERS][MAX_CHARS];
int  num_back_seat_drivers, i, current_driver, best_driver,
     most_exclamations, count;

void Append( char *s, char letter )
{
    int i, length;

    length = strlen(s);
    s[length] = letter;
    s[length+1] = '\0';
}

int CountExclamations( int person )
{
    int i,result;

    result = 0;
    for( i=0; i<strlen(sentences[person]); i++ )
    {
        if( sentences[person][i] == '!' )
            result = result + 1;
    }
    return( result );
}

void main( void )
{
    FILE *infile;
    char input_line[MAX_CHARS];
    char *ch;

    infile = fopen( "driver.in", "r" );

    while( fgets( input_line, MAX_CHARS, infile ) != NULL )
    {
        sscanf( input_line, "%d", &num_back_seat_drivers );

        for( i=0; i<num_back_seat_drivers; i++ )
            sentences[i][0] = '\0';

        current_driver = 0;

	fgets( input_line, MAX_CHARS, infile );
	if( input_line[strlen(input_line)-1] == '\n' )
	    input_line[strlen(input_line)-1] = '\0';
        ch = input_line;

        while( *ch != '\0' )
        {
            if( *ch != '!')
                Append( sentences[current_driver], *ch );
            else
            {
                ch++;
                if( *ch != '\0' )
                {
		    if( *ch == '!' )
                        Append( sentences[current_driver], '!' );
                    else
                    {
                        current_driver = current_driver + 1;
                        if( current_driver == num_back_seat_drivers )
			    current_driver = 0;
                        Append( sentences[current_driver], *ch );
                    }
                }
	    }
	    if( *ch != '\0' )
		ch++;
        }

        for( i=0; i<num_back_seat_drivers; i++ )
	    printf( "Person #%d:  %s\n", i+1, sentences[i] );

        best_driver = 0;
        most_exclamations = CountExclamations( best_driver );
        for( i=1; i<num_back_seat_drivers; i++ )
        {
            count = CountExclamations( i );
            if( count > most_exclamations )
            {
                best_driver = i;
                most_exclamations = count;
            }
        }

	printf( "Follow person #%d:  %s\n\n", best_driver+1, sentences[best_driver] );
    }

    fclose( infile );
}