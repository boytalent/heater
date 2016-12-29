ALL_EXE = heater-test
all: $(ALL_EXE) 

CC=gcc
CFLAGS=-I. -I../util
DEPS = Makefile

PUBLIC_LIBS = ../util/phy_2_vir_addr.o
LIB_FILES =
LIB_OBJS := $(subst .c,.o,$(LIB_FILES))

heater-test: heater-test.o $(LIB_OBJS) $(PUBLIC_LIBS)
# $@: target file name, $^: all prerequisites
	gcc -g -o $@ $^

test: heater-test
	./heater-test

clean:
	rm -rf *.o $(ALL_EXE) 

#pattern rules
%.o: %.c $(DEPS)
# $<: first prerequisite
	$(CC) -g -c -o $@ $< $(CFLAGS)
