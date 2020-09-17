CC = gcc

CFLAGS=\
		-g\
		-Wall\


DBUGS = -fsanitize=address\
		-static-libasan


SRCS +=\
		main.c\
		./bench/bench.c\
		./data_struct/heap.c\
		./data_struct/queue.c\
		./data_struct/hash.c
OBJS =\
	   $(patsubst %.c,%.o,$(SRCS))\


LIBS =\
		-lm\


all : simulator

simulator : main.c libarc.a
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)


libarc.a : $(OBJS)
	mkdir -p object	
	cd ./zftl/ && $(MAKE) clean && $(MAKE) && cd ../	
	mv ./zftl/*.o ./object/ && cd ../
	cd ./hashftl/ && $(MAKE) clean && $(MAKE) && cd ../
	mv ./hashftl/*.o ./object/
	mv ./bench/*.o ./object/
	mv ./data_struct/*.o ./object
	mv *.o ./object
	$(AR) r $(@) ./object/*

.c.o :
	$(CC) $(CFLAGS) -c $< -o $@ $(LIBS)
	
clean:
	@$(RM) *.o
	@$(RM) ./object/*.o
	@$(RM) simulator
	@$(RM) *.a
