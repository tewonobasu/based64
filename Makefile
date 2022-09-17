.PHONY: all test bench clean

all: build test clean

build:
	dune build

test: build
	dune runtest

bench:
	dune exec --profile=benchmark ./benchmark/benchmark.exe 

clean:
	dune clean