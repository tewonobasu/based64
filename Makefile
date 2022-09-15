.PHONY: all test clean

all:
	dune build

test:
	dune runtest

benchmark:
	dune exec ./benchmark/benchmark.exe

clean:
	dune clean