#include "stdio.h"
#include "stdlib.h"
#include "string.h"


/* person - This data type holds the information for each person who    */
/*          enters the bank.                                            */
typedef struct
{
  char name [15];
  char transaction [23];
  long intime, outtime, tranlen;
  long openteller, giveuptime;
} person;

/* linequeue - This data type is for the people in line at the bank     */
/*             and for the output list.                                 */
typedef person linequeue [501];


/* tellerlist - This list is for the people who are currently being     */
/*              serviced by a teller.                                   */
typedef person tellerlist [5];


FILE *infile;                  /* input file                            */

linequeue queue,               /* people standing in line               */
          outputlist;          /* people already processed              */

tellerlist teller;             /* people standing at a teller           */

int numberofpeople,            /* number of people in the data set      */
    peopleinline,              /* number of people in line              */
    tellersbusy,               /* number of tellers currently busy      */
    outputlistlen,             /* number of people already processed    */
    currentperson;             /* loop variable for reading input       */

person nextperson;             /* the nextperson to enter the bank      */

long time;                     /* the current time of day               */


/* -------------------------------------------------------------------- */
/* addteller - This procedure adds a person to the list of free         */
/*             tellers.  If the person would have given up by the       */
/*             time this procedure was called, she is moved to the      */
/*             output list instead.                                     */
/* -------------------------------------------------------------------- */

void addteller ( person aperson )
{

  int i;

  if ( aperson.giveuptime < aperson.openteller )
  {

    /* Append a 'NO' to the transaction because the person gave up,     */
    /* and set the time of departure to the time she gave up            */

    strcat ( aperson.transaction, "/NO " );
    aperson.outtime = aperson.giveuptime;

    /* Add her to the output list.                                      */

    outputlistlen++;
    outputlist [outputlistlen] = aperson;

  }
  else
  {

    /* Append a 'YES' to the transaction beacuse the person is          */
    /* now being processed.                                             */

    strcat ( aperson.transaction, "/YES" );
    aperson.outtime = aperson.openteller + aperson.tranlen;

    /* Add her to the teller list.  Note: the list is kept sorted       */
    /* by a simple insertion sort so the first person to leave the      */
    /* set of tellers is always in the first position.                  */

    tellersbusy++;
    i = tellersbusy;
    while ( i > 1 && aperson.outtime < teller [i-1].outtime )
      teller [i] = teller [i-1], i--;

    teller [i] = aperson;

  }

}


/* -------------------------------------------------------------------- */
/* removeteller - Take the first person out of the teller list.  The    */
/*                time a departure is saved for use later to determine  */
/*                when the next person will receive processing          */
/* -------------------------------------------------------------------- */

int removeteller ( void )
{

  int i;

  /* Add the person to the output list.                                 */

  outputlistlen++;
  outputlist [outputlistlen] = teller [1];

  /* Save the departure time, and remove the first person from the list */

  tellersbusy--;
  for ( i=1; i <= tellersbusy; i++ )
    teller [i] = teller [i+1];

  return outputlist [outputlistlen].outtime;

}


/* -------------------------------------------------------------------- */
/* addqueue - Add a person to the line.  If a teller is open, the       */
/*            goes straight to an open teller, otherwise he is add to   */
/*            the end of the list.                                      */
/* -------------------------------------------------------------------- */

void addqueue ( person aperson )
{

  if ( tellersbusy < 5 )
  {

    /* person goes to the teller                                        */

    aperson.openteller = time;
    addteller ( aperson );

  }
  else
  {

    /* person has to wait                                               */

    peopleinline++;
    queue [peopleinline] = aperson;

  }


}


/* -------------------------------------------------------------------- */
/* removequeue - Remove the first person from the queue.                */
/* -------------------------------------------------------------------- */

void removequeue ( person *aperson )
{

  int i;

  *aperson = queue [1];

  peopleinline--;
  for ( i=1; i <= peopleinline; i++ )
    queue [i] = queue [i+1];

}


/* -------------------------------------------------------------------- */
/* updatequeue - This procedure takes care of most of the work.  As     */
/*               long as there is an open teller and the line is not    */
/*               empty, people are moved from the queue line to an      */
/*               available teller.                                      */
/* -------------------------------------------------------------------- */

void updatequeue ( void )
{

  int i, freeteller;
  person nextperson;

  while ( tellersbusy && teller [1].outtime <= time ||
          tellersbusy < 5 && peopleinline )
  {

    /* If a teller has finished with a customer, remove the person      */
    /* and save the time of departure for the next customer.  If not,   */
    /* then the customer must enter the teller list at the current      */
    /* time.                                                            */

    if ( tellersbusy && teller [1].outtime <= time )
      freeteller = removeteller ();
    else
      freeteller = time;

    /* If there is someone in line, remove him and move him into the    */
    /* teller list at the time determined above                         */

    if ( peopleinline )
    {

      removequeue ( &nextperson );
      nextperson.openteller = ( freeteller > nextperson.intime ) ?
                              freeteller : nextperson.intime;
      addteller ( nextperson );

    }

  }

}


/* -------------------------------------------------------------------- */
/* cleanqueue - This procedure takes care of the remaining customers    */
/*              after all input has been read for the current data set. */
/* -------------------------------------------------------------------- */

void cleanqueue ( void )
{

  /* While a teller is still busy, remove the first person, and update  */
  /* update the queue.                                                  */

  while ( tellersbusy )
  {

    /* Set the current time to the time of departure, and update the    */
    /* queue to take care of any customers that are still in line       */

    time = teller [1].outtime;
    updatequeue ();

  }

}


/* -------------------------------------------------------------------- */
/* writelist - Sort the output list by arrival time, and print it out   */
/* -------------------------------------------------------------------- */

void writelist ( void )
{

  int i,j;
  person temp;


  /* Sort the list using the insertion sort.                            */

  for ( j=2; j <= outputlistlen; j++ )
  {

    i = j;
    temp = outputlist [i];
    while ( i > 1 && temp.intime < outputlist [i-1].intime )
      outputlist [i] = outputlist [i-1], i--;

    outputlist [i] = temp;

  }

  /* For each person in the output list, print the information required */
  /* by the problem specification.                                      */

  for ( i=1; i <= outputlistlen; i++ )
   printf ("%-14s  %-22s %8ld  %8ld\n", outputlist [i].name,
            outputlist [i].transaction, outputlist [i].intime,
            outputlist [i].outtime);

}


/* -------------------------------------------------------------------- */
/* getperson - Get a new person from the input file.                    */
/* -------------------------------------------------------------------- */

void getperson ( person *nextperson )
{

  float amount;
  char ch, *money;
  int i;

  /* Read the next person's name, arrival time, and his wait time       */

  fscanf ( infile, "%s %ld %ld", nextperson->name, &(nextperson->intime),
           &(nextperson->giveuptime) );
  nextperson->intime += time;
  time = nextperson->intime;
  nextperson->giveuptime += time;

  /* Read the extra space, and the rest of the line is the transaction. */

  ch = fgetc ( infile );
  fgets ( nextperson->transaction, 30, infile );
  for ( i=0; nextperson->transaction && nextperson->transaction [i] != '\n'; i++ );
  nextperson->transaction [i] = 0;

  /* This if-then block determines the type of transaction and the      */
  /* amount of time it will take.                                       */

  if ( strstr (nextperson->transaction, "DEPOSIT") )
    nextperson->tranlen = 5;
  else if ( strstr (nextperson->transaction, "WITHDRAW") )
  {

    money = strstr ( nextperson->transaction, "$" )+1;
    sscanf ( money, "%f", &amount );
    nextperson->tranlen = 7 + (int) (amount + 99.991) / 100;

  }
  else if ( strstr (nextperson->transaction, "CASHIERS_CHECK") )
    nextperson->tranlen = 10;
  else if ( strstr (nextperson->transaction, "LOAN") )
  {

    money = strstr ( nextperson->transaction, "$" )+1;
    sscanf ( money, "%f", &amount );
    nextperson->tranlen = 50 + (int) (amount + 99.991) / 100 * 3;

  }
  else if ( strstr (nextperson->transaction, "ACCOUNT_BALANCE") )
    nextperson->tranlen = 2;
  else if ( strstr (nextperson->transaction, "ATM_CARD") )
    nextperson->tranlen = 20;
  else if ( strstr (nextperson->transaction, "OPEN_ACCOUNT") )
    nextperson->tranlen = 30;
  else
    printf ("Bad judge data\n");

}


/* -------------------------------------------------------------------- */
/*                          The main program                            */
/* -------------------------------------------------------------------- */

void main ( void )
{

  /* Open the input file.                                               */

  infile = fopen ("bank.in", "rt");

  while ( !feof (infile) )
  {

    /* Reset the variables for the current data set.                    */

    peopleinline = 0;
    tellersbusy = 0;
    outputlistlen = 0;
    time = 0;

    /* Read the number of people, and print the header.                 */

    fscanf ( infile, "%d\n", &numberofpeople );

    printf ("CUSTOMER        TRANSACTION/COMPLETED        IN       OUT \n");
    printf ("----------------------------------------------------------\n");

    /* Loop once for each person in the data set.                       */

    for ( currentperson=0; currentperson < numberofpeople; currentperson++ )
    {

      /* Get the next person, add her to the queue, and call            */
      /* updatequeue.                                                   */

      getperson ( &nextperson );
      addqueue ( nextperson );
      updatequeue ();

    }

    /* Finish anyone who might to left.                                 */

    cleanqueue ();

    /* Write out the list with two extra blank lines to separate the    */
    /* data sets.                                                       */

    writelist ();

    printf ("\n\n");

  }

  fclose ( infile );

}