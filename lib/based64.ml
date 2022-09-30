open Ctypes

let current_size = ref 1_000_000
let out = ref (CArray.make char (!current_size * 2))

let helper fn input =
  let length = String.length input in
  let len_size_t = Unsigned.Size_t.of_int length in
  if length > !current_size
    then (out := CArray.make char (length * 2);
  current_size := length * 2);
  let out_ptr = CArray.start !out in
  let len_out = allocate size_t (Unsigned.Size_t.of_int 0) in
  fn input len_size_t out_ptr len_out 0;
  string_from_ptr out_ptr ~length:(Unsigned.Size_t.to_int !@len_out)

let encode = helper C.Function.base64_encode
let decode = helper C.Function.base64_decode
