/*
Aadarsh Patel
118676722
apatel66
*/

#include "calendar.h"
#include "event.h"
#include "my_memory_checker_216.h"
#include <stdio.h>
#include <stdlib.h>

/*****************************************************/
/* In this file you will provide tests for your      */
/* calendar application.  Each test should be named  */
/* test1(), test2(), etc. Each test must have a      */
/* brief description of what it is testing (this     */
/* description is important).                        */
/*                                                   */
/* You can tell whether any test failed if after     */
/* executing the students tests, you executed        */
/* "echo $?" on the command line and you get a value */
/* other than 0.  "echo $?" prints the status of     */
/* the last command executed by the shell.           */
/*                                                   */
/* Notice that main just calls test1(), test2(), etc.*/
/* and once one fails, the program eventually        */
/* return EXIT_FAILURE; otherwise EXIT_SUCCESS will  */
/* be returned.                                      */
/*****************************************************/

static int comp_minutes(const void *ptr1, const void *ptr2) {
  return ((Event *)ptr1)->duration_minutes - ((Event *)ptr2)->duration_minutes;
}

/* Test 1: Initializing calendar and printing */
static int test1() {
  int days = 7;
  Calendar *calendar;

  if (init_calendar("polls", days, comp_minutes, NULL, &calendar) == SUCCESS) {
    if (print_calendar(calendar, stdout, 1) == SUCCESS) {
      return destroy_calendar(calendar);
    }
  }

  return FAILURE;
}

/* Test 2: Add an event to the calendar */
static int test2() {
  int days = 7;
  Calendar *calendar;

  if (init_calendar("Spr", days, comp_minutes, NULL, &calendar) == SUCCESS) {
    if (add_event(calendar, "polls", 300, 50, NULL, 1) == SUCCESS) {
      return destroy_calendar(calendar);
    }
  }
  return FAILURE;
}

/* Test 3: Remove an event from the calendar */
static int test3() {
  int days = 7;
  Calendar *calendar;

  if (init_calendar("Spr", days, comp_minutes, NULL, &calendar) == SUCCESS) {
    if (add_event(calendar, "polls", 300, 50, NULL, 1) == SUCCESS) {
      if (remove_event(calendar, "polls") == SUCCESS) {
        return destroy_calendar(calendar);
      }
    }
  }
  return FAILURE;
}

/* Test 4: Get event info from the calendar */
static int test4() {
  int days = 7;
  Calendar *calendar;

  if (init_calendar("Spr", days, comp_minutes, NULL, &calendar) == SUCCESS) {
    if (add_event(calendar, "polls", 300, 50, NULL, 1) == SUCCESS) {
      if (get_event_info(calendar, "polls") == SUCCESS) {
        return destroy_calendar(calendar);
      }
    }
  }
  return FAILURE;
}

/* Test 5: Clear the entire calendar */
static int test5() {
  int days = 7;
  Calendar *calendar;

  if (init_calendar("Spr", days, comp_minutes, NULL, &calendar) == SUCCESS) {
    if (add_event(calendar, "polls", 300, 50, NULL, 1) == SUCCESS) {
      if (clear_calendar(calendar) == SUCCESS) {
        return destroy_calendar(calendar);
      }
    }
  }
  return FAILURE;
}

/* Test 6: Clear a specific day in the calendar */
static int test6() {
  int days = 7;
  Calendar *calendar;

  if (init_calendar("Spr", days, comp_minutes, NULL, &calendar) == SUCCESS) {
    if (add_event(calendar, "polls", 300, 50, NULL, 1) == SUCCESS) {
      if (clear_day(calendar, 1) == SUCCESS) {
        return destroy_calendar(calendar);
      }
    }
  }
  return FAILURE;
}

/* Test 7: Find an event in the calendar */
static int test7() {
  int days = 7;
  Calendar *calendar;

  if (init_calendar("Spr", days, comp_minutes, NULL, &calendar) == SUCCESS) {
    if (add_event(calendar, "polls", 300, 50, NULL, 1) == SUCCESS) {
      if (find_event(calendar, "polls", NULL) == SUCCESS) {
        return destroy_calendar(calendar);
      }
    }
  }
  return FAILURE;
}

/* Test 8: Find an event in a specific day of the calendar */
static int test8() {
  int days = 7;
  Calendar *calendar;
  Event *event = NULL;

  if (init_calendar("Spr", days, comp_minutes, NULL, &calendar) == SUCCESS) {
    if (add_event(calendar, "polls", 300, 50, NULL, 1) == SUCCESS) {
      if (find_event_in_day(calendar, "polls", 1, &event) == SUCCESS) {
        return destroy_calendar(calendar);
      }
    }
  }
  return FAILURE;
}

int main() {
  int result = SUCCESS;

  /***** Starting memory checking *****/
  start_memory_check();
  /***** Starting memory checking *****/

  if (test1() == FAILURE)
    result = FAILURE;
  if (test2() == FAILURE)
    result = FAILURE;
  if (test3() == FAILURE)
    result = FAILURE;
  if (test4() == FAILURE)
    result = FAILURE;
  if (test5() == FAILURE)
    result = FAILURE;
  if (test6() == FAILURE)
    result = FAILURE;
  if (test7() == FAILURE)
    result = FAILURE;
  if (test8() == FAILURE)
    result = FAILURE;

  /****** Gathering memory checking info *****/
  stop_memory_check();
  /****** Gathering memory checking info *****/

  return result;
}