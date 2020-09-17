CC = gcc

CFLAGS =\
		-g\
		-Wall\

LIBS =\
	  -lm


SRCS +=\
	   zftl.c\
	   zftl_util.c\
	   gc.c\
	   block.c\

	   
OBJS :=\
	  $(patsubst %.c,%.o,$(SRCS))\


all: $(OBJS)

.c.o :
	$(CC) $(CFLAGS) -c $< -o $@ $(LIBS)

#../object/%.o : %.c	
#	$(CC) $(CFLAGS) -c $< -o $@ $(LIBS)

clean:
	@$(RM) *.o

