#include "calendar.h"
#include "event.h"
#include "my_memory_checker_216.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Function to initialize a calendar */
int init_calendar(const char *name, int days,
                  int (*comp_func)(const void *ptr1, const void *ptr2),
                  void (*free_info_func)(void *ptr), Calendar **calendar) {

  Calendar *new_cal;

  if (calendar == NULL || name == NULL || days < 1) {
    return FAILURE;
  }

  new_cal = malloc(sizeof(Calendar));
  if (new_cal == NULL) {
    return FAILURE;
  }

  (new_cal)->name = malloc(strlen(name) + 1);
  if ((new_cal)->name == NULL) {
    return FAILURE;
  }

  (new_cal)->events = calloc(days, sizeof(Event *));
  if ((new_cal)->events == NULL) {
    return FAILURE;
  }

  strcpy((new_cal)->name, name);
  (new_cal)->days = days;
  (new_cal)->total_events = 0;
  (new_cal)->comp_func = comp_func;
  (new_cal)->free_info_func = free_info_func;

  *calendar = new_cal;

  return SUCCESS;
}

/* Function to print the calendar */
int print_calendar(Calendar *calendar, FILE *output_stream, int print_all) {
  int i = 0;
  Event *event;

  if (calendar == NULL || output_stream == NULL) {
    return FAILURE;
  }

  if (print_all) {
    fprintf(output_stream, "Calendar's Name: \"%s\"\n", calendar->name);
    fprintf(output_stream, "Days: %d\n", calendar->days);
    fprintf(output_stream, "Total Events: %d\n", calendar->total_events);
  }

  fprintf(output_stream, "\n**** Events ****\n");

  if (calendar->total_events > 0) {

    for (i = 0; i < calendar->days; i++) {
      fprintf(output_stream, "Day %d\n", i + 1);
      event = calendar->events[i];
      while (event != NULL) {
        fprintf(output_stream,
                "Event's Name: \"%s\", Start_time: %d, Duration: %d\n",
                event->name, event->start_time, event->duration_minutes);
        event = event->next;
      }
    }
  }

  return SUCCESS;
}

/*Function to destroy a calendar */
int destroy_calendar(Calendar *calendar) {
  int i = 0;
  Event *next_event;
  Event *event;

  if (calendar == NULL) {
    return FAILURE;
  }

  for (i = 0; i < calendar->days; i++) {
    event = calendar->events[i];
    while (event != NULL) {
      next_event = event->next;
      if (event->info != NULL && calendar->free_info_func != NULL) {
        calendar->free_info_func(event->info);
      }
      free(event->name);
      free(event);
      event = next_event;
    }
  }

  free(calendar->events);
  free(calendar->name);
  free(calendar);

  return SUCCESS;
}

/* Function to add an event to the calendar */
int add_event(Calendar *calendar, const char *name, int start_time,
              int duration_minutes, void *info, int day) {
  Event *existingEvent;
  Event *newEvent;
  Event **eventList;

  if (calendar == NULL || name == NULL || start_time < 0 || start_time > 2400 ||
      duration_minutes <= 0 || day < 1 || day > calendar->days) {
    return FAILURE;
  }

  if (find_event(calendar, name, &existingEvent) == SUCCESS) {
    return FAILURE;
  }

  newEvent = malloc(sizeof(Event));
  if (newEvent == NULL) {
    return FAILURE;
  }
  newEvent->name = malloc(strlen(name) + 1);
  if (newEvent->name == NULL) {
    free(newEvent);
    return FAILURE;
  }

  strcpy(newEvent->name, name);
  newEvent->start_time = start_time;
  newEvent->duration_minutes = duration_minutes;
  newEvent->info = info;
  newEvent->next = NULL;

  eventList = &(calendar->events[day - 1]);
  if (*eventList == NULL || calendar->comp_func(newEvent, *eventList) <= 0) {
    newEvent->next = *eventList;
    *eventList = newEvent;
  } else {
    while ((*eventList)->next != NULL &&
           calendar->comp_func(newEvent, (*eventList)->next) > 0) {
      eventList = &((*eventList)->next);
    }
    newEvent->next = (*eventList)->next;
    (*eventList)->next = newEvent;
  }

  calendar->total_events++;

  return SUCCESS;
}

int find_event(Calendar *calendar, const char *name, Event **event) {
  Event *currentEvent;
  int i = 0;

  if (calendar == NULL || name == NULL || event == NULL) {
    return FAILURE;
  }

  *event = NULL;

  for (i = 0; i < calendar->days; i++) {
    currentEvent = calendar->events[i];
    while (currentEvent != NULL) {
      if (strcmp(currentEvent->name, name) == 0) {
        *event = currentEvent;
        return SUCCESS;
      }
      currentEvent = currentEvent->next;
    }
  }

  return FAILURE;
}

void *get_event_info(Calendar *calendar, const char *name) {

  Event *event;

  if (calendar == NULL || name == NULL) {
    return NULL;
  }

  if (find_event(calendar, name, &event) == SUCCESS) {
    return event->info;
  }

  return NULL;
}

int clear_calendar(Calendar *calendar) {

  int i = 0;
  Event *event;
  Event *next_event;

  if (calendar == NULL) {
    return FAILURE;
  }

  for (i = 0; i < calendar->days; i++) {
    event = calendar->events[i];
    while (event != NULL) {
      next_event = event->next;

      if (event->info != NULL && calendar->free_info_func != NULL) {
        calendar->free_info_func(event->info);
      }

      free(event->name);
      free(event);

      event = next_event;
    }

    calendar->events[i] = NULL;
  }

  calendar->total_events = 0;

  return SUCCESS;
}

int clear_day(Calendar *calendar, int day) {

  Event *event = NULL, *next_event = NULL;

  if (calendar == NULL || day < 1 || day > calendar->days) {
    return FAILURE;
  }

  event = calendar->events[day - 1];

  while (event != NULL) {
    next_event = event->next;

    if (event->info != NULL && calendar->free_info_func != NULL) {
      calendar->free_info_func(event->info);
    }

    free(event->name);
    free(event);

    event = next_event;
    calendar->total_events--;
  }

  calendar->events[day - 1] = NULL;

  return SUCCESS;
}

int remove_event(Calendar *calendar, const char *name) {

  Event *event;
  Event *prev_event;
  int i = 0;

  if (calendar == NULL || name == NULL) {
    return FAILURE;
  }

  for (i = 0; i < calendar->days; i++) {
    event = calendar->events[i];
    prev_event = NULL;

    while (event != NULL) {
      if (strcmp(event->name, name) == 0) {
        if (prev_event != NULL) {
          prev_event->next = event->next;
        } else {
          calendar->events[i] = event->next;
        }

        if (event->info != NULL && calendar->free_info_func != NULL) {
          calendar->free_info_func(event->info);
        }

        free(event->name);
        free(event);
        calendar->total_events--;

        return SUCCESS;
      }

      prev_event = event;
      event = event->next;
    }
  }

  return FAILURE;
}

int find_event_in_day(Calendar *calendar, const char *name, int day,
                      Event **event) {

  Event *curr_event = calendar->events[day - 1];

  if (calendar == NULL || name == NULL || day < 1 || day > calendar->days ||
      event == NULL) {
    return FAILURE;
  }

  while (curr_event != NULL) {
    if (strcmp(curr_event->name, name) == 0) {
      *event = curr_event;
      return SUCCESS;
    }
    curr_event = curr_event->next;
  }

  return FAILURE;
}
