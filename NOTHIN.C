/************************************************************************\
*                                                                        *
*                     University of Central Florida                      *
*             8th Annual High School Programming Tournament              *
*                         Friday, May 13, 1994                           *
*                                                                        *
*                   C solution for: "Nothin' But Net"                    *
*                                                                        *
\************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Function Prototypes */

int  FindPath( int object, int index ) ;
void PrintPath( void ) ;
void main( void ) ;


/* Constants */

#define FALSE         0
#define TRUE          1

#define MAX_OBJECTS  20 /* Maximum number of objects        */
#define MAX_NAME_LEN 30 /* Maximum length of an object name */


/* Types */

/* For storing an object number/action pair */
typedef struct {
     int obj_num ; /* Sequence number of the object      */
     int action ;  /* 1 - off, 2 - through or 3 - around */
} PathEntry ;

/* For storing connectivity matricies */
typedef int MatrixType[MAX_OBJECTS-1][MAX_OBJECTS] ;

/* For storing object name lists */
typedef char NameListType[MAX_OBJECTS][MAX_NAME_LEN+1] ;

/* For storing paths to the net */
typedef PathEntry PathType[MAX_OBJECTS] ;


/* Global Variables */

int          num ;       /* Number of objects            */
MatrixType   matrix ;    /* Object connectivity matrix   */
NameListType name_list ; /* Object name list             */
PathType     cur_path ;  /* Current path being traversed */


/**********************************************************************\
*                                                                      *
* Function: FindPath                                                   *
*                                                                      *
* This is a recursive function.  At each level of recursion it checks  *
* first to see if the object passed in is the net.  If this is the     *
* case, then a valid path to the net has been found and TRUE will be   *
* returned immediately at each level of recursion until it returns to  *
* the original calling routine.  If the object is not the net, then it *
* adds the object to the path array at the given index, and calls      *
* itself recursively for each object to which the current object has a *
* connection or until a path is found.  Note that the net object is    *
* also stored in the path array to indicate the end of the path, but   *
* no action exists for the net object, so nothing is stored.           *
*                                                                      *
\**********************************************************************/

int FindPath( int object, int index )
{
     int i ;     /* Counter                       */
     int found ; /* TRUE if a path has been found */

     /* Store the object number in the current path entry. */
     cur_path[index].obj_num = object ;

     if( object == num - 1 ) {
          /* We reached the net!  Return TRUE. */
          found = TRUE ;
     } else {
          /* Loop through matrix columns until we find a path or */
          /* we run out of columns.                              */
          found = FALSE ;
          for( i = 0; i < num && !found; i++ ) {
               if( matrix[object][i] > 0 ) {
                    /* We found a connection. Store the action and */
                    /* see if it leads to the net.                 */
                    cur_path[index].action = matrix[object][i] ;
                    found = FindPath( i, index + 1 ) ;
               }
          }
     }
     return( found ) ;
}


/**********************************************************************\
*                                                                      *
* Function: PrintPath                                                  *
*                                                                      *
* This procedure loops through the solution path, converting it to the *
* required output sentence format.                                     *
*                                                                      *
\**********************************************************************/

void PrintPath( void )
{
     int i ; /* Counter */

     /* Treat the first object separate since we need to capitalize. */
     if( cur_path[0].obj_num == num - 1 ) {
          /* We hit the net! */
          printf( "Nothin' but net.\n" ) ;
     } else {
          /* Switch on the action. */
          switch( cur_path[0].action ) {
               case 1 : printf( "Off the " ) ;
                        break ;
               case 2 : printf( "Through the " ) ;
                        break ;
               case 3 : printf( "Around " ) ;
                        break ;
          }
          printf( "%s, ", name_list[cur_path[0].obj_num] ) ;
     }

     /* Loop until we hit the net. */
     i = 0 ;
     while( cur_path[i].obj_num != num - 1 ) {
          i++ ;
          if( cur_path[i].obj_num == num - 1 ) {
               printf( "nothin' but net.\n" ) ;
          } else {
               /* Switch on the action. */
               switch( cur_path[i].action ) {
                    case 1 : printf( "off the " ) ;
                             break ;
                    case 2 : printf( "through the " ) ;
                             break ;
                    case 3 : printf( "around " ) ;
                             break ;
               }
               printf( "%s, ", name_list[cur_path[i].obj_num] ) ;
          }
     }
     printf( "\n" ) ;
}


/*************************************************************************\
*                                                                         *
* Function: main                                                          *
*                                                                         *
* This function loops until end of file processing data sets.  For each   *
* data set it read in the object names and connectivity matrix.  It then  *
* loops through the starting objects, calling FindPath to generate a path *
* to the net, and PrintPath to output the path.                           *
*                                                                         *
\*************************************************************************/

void main( void )
{
     FILE *fhand ; /* Input file handle */
     int  i, j ;   /* Counter variables */
     int  start ;  /* Starting object   */

     if( ( fhand = fopen( "nothin.in", "r" ) ) == NULL ) {
          printf( "Error opening file: NOTHIN.IN !!!\n" ) ;
          exit( 1 ) ;
     }

     while( fscanf( fhand, "%d \n", &num ) == 1 ) {
          /* Read in the object names. */
          for( i = 0; i < num - 1; i++ ) {
               fgets( name_list[i], MAX_NAME_LEN, fhand ) ;
               j = strlen( name_list[i] ) - 1 ;
               if( name_list[i][j] == '\n' ) {
                    name_list[i][j] = '\0' ;
               }
          }

          /* Read in the connectivity matrix. */
          for( i = 0; i < num - 1; i++ ) {
               for( j = 0; j < num; j++ ) {
                    fscanf( fhand, "%d", &matrix[i][j] ) ;
               }
          }

          /* Loop through starting objects until a zero is read. */
          fscanf( fhand, "%d", &start ) ;
          while( start != 0 ) {
               /* Find a path to the net */
               if( ! FindPath( start-1, 0 ) ) {
                    /* This should never happen! */
                    printf( "ERROR: No path was found!!!\n" ) ;
               } else {
                    /* Print out the path found. */
                    PrintPath( ) ;
               }
               fscanf( fhand, "%d", &start ) ;
          }
     }
}

