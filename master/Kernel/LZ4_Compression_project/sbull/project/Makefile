CC = gcc
CFLAGS = -g -W -Wall
#LOADLIBES = -lcrypto
TARGET1 = bench1
TARGET2 = bench2
OBJECT1 = bench1.o
OBJECT2 = bench2.o

all : $(TARGET1) $(TARGET2)

$(TARGET1): $(OBJECT1)
	$(CC) $(CFLAGS) -o $@ $^

$(TARGET2): $(OBJECT2)
	$(CC) $(CFLAGS) -o $@ $^

clean :
	rm *.o $(TARGET1) $(TARGET2)
