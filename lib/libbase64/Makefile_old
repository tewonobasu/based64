
.PHONY: clean

all: clean foo.a foo.so

foo.o:
	gcc -c foo.c -fPIC -o foo.o

foo.so: foo.o
	gcc -shared foo.o -o libfoo.so

foo.a: foo.o
	ar crs libfoo.a foo.o

clean:
	rm -rf *.a
	rm -rf *.so
	rm -rf *.o
