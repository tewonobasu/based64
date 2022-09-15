# Based64

Based64 is an OCaml library providing bindings to [aklomp/base64](https://github.com/aklomp/base64).

## Usage

Here's an example of usage in a utop session:

```
utop # #require "based64";;
utop # let encoded = Based64.encode "foobar";;
val encoded : string = "Zm9vYmFy"
utop # Based64.decode encoded;;
- : string = "foobar"
```

## API

From the `based64.mli` file:

```ocaml
val encode : string -> string
(** Encode a string in base 64 *)

val decode : string -> string
(** Decode a string from base 64 *)
```

## Benchmark

There is a benchmark comparing the base64 encoding of this library and the base64 implementation in pure OCaml [ocaml-base64](https://github.com/mirage/ocaml-base64). It's used to make sure that the C bindings are actually faster than the pure OCaml implementation, since it's the goal of this library.

On my machine, the pure OCaml implementation is faster for random string of size 10. For a random string of size 1 000 000, the C implementation is faster by ~3 times for encoding and ~8 times for decoding. The initial goal for this library was to speed up encoding of images of at least a few MBs, so this works.

## License

MIT
