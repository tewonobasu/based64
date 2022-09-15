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

## License

MIT
