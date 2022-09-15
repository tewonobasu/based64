.PHONY: all test bench clean

all:
	dune build

test:
	dune runtest

bench:
	dune exec ./benchmark/benchmark.exe --profile=benchmark

clean:
	dune clean