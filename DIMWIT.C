/************************************************************************\
*                                                                        *
*                     University of Central Florida                      *
*             8th Annual High School Programming Tournament              *
*                         Friday, May 13, 1994                           *
*                                                                        *
*                    C solution for: "Dimwit Numbers"                    *
*                                                                        *
\************************************************************************/

#include <stdlib.h>
#include <stdio.h>

typedef int DimNum[4] ; /* Holds Dimwit numbers and bases                 */

/* Prototypes */
void ReadNum( FILE *, DimNum, int ) ;
void main( void ) ;


/**************************************************************************\
*                                                                          *
* Function: ReadNum                                                        *
*                                                                          *
* This function skips the specified number of character in the input       *
* file and then reads in the next four characters, converts them to        *
* integers, and stores them in the specified DimNum array in reverse       *
* order.                                                                   *
*                                                                          *
\**************************************************************************/

void ReadNum(
     FILE      *fhand, /* Input file handle                               */
     DimNum    dnum,   /* Array to store values read                      */
     int       skip )  /* Number of chars to skip before reading          */
{
     int       i ;     /* Counter                                         */

     for( i = 0; i < skip; i++ ) {
          fgetc( fhand ) ;
     }
     for( i = 3; i >= 0; i-- ) {
          dnum[i] = fgetc( fhand ) - '0' ;
     }
}


/*************************************************************************\
*                                                                         *
* Function main                                                           *
*                                                                         *
* This function reads in the number of data sets and loops through them.  *
* For each one it uses ReadNum to get the number to convert and the       *
* source and target bases.  Each number is converted from the source base *
* to its decimal equivalent, and from there to the target base.  It then  *
* prints out the result.                                                  *
*                                                                         *
\*************************************************************************/

void main( void )
{
     int       num_cons ;  /* Number of conversions to perform            */
     int       c, i, j ;   /* Counters                                    */
     FILE      *fhand ;    /* Input file handle                           */
     DimNum    in_val ;    /* Holds Dimwit number read in                 */
     DimNum    out_val ;   /* Holds converted Dimwit number               */
     int       dec_val ;   /* Holds decimal conversion of original number */
     int       mult ;      /* Multiplyer used for conversion              */
     DimNum    from_base ; /* Holds Dimwit base to be converted from      */
     DimNum    to_base  ;  /* Holds Dimwit base to be converted to        */
     int       overflow ;  /* Overflow flag                               */

     if( ( fhand = fopen( "dimwit.in", "r" ) ) == NULL ) {
          printf( "Error opening file: DIMWIT.IN !!!\n" ) ;
          exit( 1 ) ;
     }
     fscanf( fhand, "%d \n", &num_cons ) ;
     for( c = 0; c < num_cons; c++ ) {
          /* Read in the number to convert. */
          ReadNum( fhand, in_val, 0 ) ;

          /* Read in base to convert from. */
          ReadNum( fhand, from_base, 3 ) ;

          /* Read in base to convert to. */
          ReadNum( fhand, to_base, 3 ) ;

          /* Convert from original base to decimal. */
          mult = 1 ;
          dec_val = 0 ;
          for( i = 0; i < 4; i++ ) {
               dec_val += in_val[i] * mult ;
               mult *= from_base[i] + 1 ;
          }

          /* Convert from decimal to output base. */
          overflow = 0 ;
          for( i = 0; i < 4; i++ ) {
               out_val[i] = 0 ;
          }
          for( i = 0; !overflow && i < dec_val; i++ ) {
               out_val[0]++ ;
               for( j = 0; j < 4; j++ ) {
                    if( out_val[j] > to_base[j] ) {
                         if( j == 3 ) {
                              overflow = 1 ;
                         } else {
                              out_val[j] = 0 ;
                              out_val[j+1]++ ;
                         }
                    }
               }
          }

          /* Write the result. */
          if( overflow ) {
               printf( "OVERFLOW\n" ) ;
          } else {
               for( i = 3; i >= 0; i-- ) {
                    printf( "%1d", out_val[i] ) ;
               }
               printf( "\n" ) ;
          }

          /* Read past end of line. */
          fscanf( fhand, " \n" ) ;
     }
}

