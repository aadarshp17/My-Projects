CC = gcc
CFLAGS = -ansi -Wall -g -O0 -Wwrite-strings -Wshadow -pedantic-errors -fstack-protector-all -Wextra
PROGS = public01 public02 public03 public04 public05 public06 student_tests

all: $(PROGS)

public01: public01.o calendar.o my_memory_checker_216.o
	$(CC) $(CFLAGS) -o public01 public01.o calendar.o my_memory_checker_216.o

public02: public02.o calendar.o my_memory_checker_216.o
	$(CC) $(CFLAGS) -o public02 public02.o calendar.o my_memory_checker_216.o

public03: public03.o calendar.o my_memory_checker_216.o
	$(CC) $(CFLAGS) -o public03 public03.o calendar.o my_memory_checker_216.o

public04: public04.o calendar.o my_memory_checker_216.o
	$(CC) $(CFLAGS) -o public04 public04.o calendar.o my_memory_checker_216.o

public05: public05.o calendar.o my_memory_checker_216.o
	$(CC) $(CFLAGS) -o public05 public05.o calendar.o my_memory_checker_216.o

public06: public06.o calendar.o my_memory_checker_216.o
	$(CC) $(CFLAGS) -o public06 public06.o calendar.o my_memory_checker_216.o

student_tests: student_tests.o calendar.o my_memory_checker_216.o
	$(CC) $(CFLAGS) -o student_tests student_tests.o calendar.o my_memory_checker_216.o

public01.o: public01.c event.h calendar.h my_memory_checker_216.h
	$(CC) $(CFLAGS) -c public01.c

public02.o: public02.c event.h calendar.h my_memory_checker_216.h
	$(CC) $(CFLAGS) -c public02.c

public03.o: public03.c event.h calendar.h my_memory_checker_216.h
	$(CC) $(CFLAGS) -c public03.c

public04.o: public04.c event.h calendar.h my_memory_checker_216.h
	$(CC) $(CFLAGS) -c public04.c

public05.o: public05.c event.h calendar.h my_memory_checker_216.h
	$(CC) $(CFLAGS) -c public05.c

public06.o: public06.c event.h calendar.h my_memory_checker_216.h
	$(CC) $(CFLAGS) -c public06.c

student_tests.o: student_tests.c event.h calendar.h my_memory_checker_216.h
	$(CC) $(CFLAGS) -c student_tests.c

calendar.o: calendar.c calendar.h event.h
	$(CC) $(CFLAGS) -c calendar.c

my_memory_checker_216.o: my_memory_checker_216.c my_memory_checker_216.h
	$(CC) $(CFLAGS) -c my_memory_checker_216.c

clean:
	rm -f $(PROGS) *.o

