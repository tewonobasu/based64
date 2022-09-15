.PHONY: all test bench clean

all:
	dune build

test:
	dune runtest

bench:
	dune exec --profile=benchmark ./benchmark/benchmark.exe 

clean:
	dune clean