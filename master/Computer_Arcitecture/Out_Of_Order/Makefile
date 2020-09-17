CC = gcc
CFAGS = -g -Wall
TARGET = out_of_order
OBJECTS = main.c queue.c inst.c
HEADERS = inst.h queue.h
all: $(TARGET)

$(TARGET) : $(HEADERS) $(OBJECTS)
	$(CC) $(CFAGS) -o $@ $^

#inst.o : inst.h inst.c
#	$(CC) $(CFAGS) -c -o 

#queue.o : inst.h queue.h queue.c
#	$(CC) $(CFAGS) -c -o queue.o queue.c
#main.o : inst.h queue.h main.c
#	$(CC) $(CFAGS) -c -o main.o main.c 
clean :
	rm -r $(TARGET)

