CC = gcc

CFLAGS =\
		-g\
		-Wall\

LIBS =\
	  -lm


SRCS +=\
	   bloomftl.c\
	   bloomftl_util.c\
	   gc.c\
	   block.c\
	   rebloom.c
	   
OBJS :=\
	  $(patsubst %.c,%.o,$(SRCS))\


all: $(OBJS)

.c.o :
	$(CC) $(CFLAGS) -c $< -o $@ $(LIBS)

#../object/%.o : %.c	
#	$(CC) $(CFLAGS) -c $< -o $@ $(LIBS)

clean:
	@$(RM) *.o

