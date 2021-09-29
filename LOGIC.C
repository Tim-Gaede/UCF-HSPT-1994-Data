#include <stdio.h>
#include <string.h>

#define FALSE        0
#define TRUE         1
#define MAX_CHARS  255

char ch;
int i, blue, red, yellow, green, orange;

void Setup( void )
{
    blue   = FALSE;
    red    = FALSE;
    yellow = FALSE;
    green  = FALSE;
    orange = FALSE;
}

void MarkSeen( char color )
{
    if( color == 'B' ) blue = TRUE;
    else if( color == 'R' ) red = TRUE;
    else if( color == 'Y' ) yellow = TRUE;
    else if( color == 'G' ) green = TRUE;
    else orange = TRUE;
}

void WriteRemaining( void )
{
    if( !blue ) printf( "Blue" );
    else if( !red ) printf( "Red" );
    else if( !yellow ) printf( "Yellow" );
    else if( !green ) printf( "Green" );
    else printf( "Orange" );
}

void main( void )
{
    FILE *infile;
    char input_line[MAX_CHARS];

    infile = fopen( "logic.in", "r" );

    while( fgets(input_line, MAX_CHARS, infile) != NULL )
    {
	Setup();

        for( i=0; i<4; i++ )
        {
            ch = input_line[i];
            MarkSeen( ch );
        }

        printf( "It's " );
	WriteRemaining();
        printf( "!\n" );
    }

    fclose( infile );
}
