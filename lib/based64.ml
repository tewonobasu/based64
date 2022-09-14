open Ctypes
include Bindings

let encode input =
  let out = CArray.make char ~initial:'\x00' (String.length input * 2) in
  let out_ptr = (CArray.start out) in
  let len_size_t = (Unsigned.Size_t.of_int (String.length input)) in
  Bindings.C.Function.base64_encode input len_size_t out_ptr (allocate_n ~count:1 size_t) 0;
  let buf_addr = allocate (ptr char) out_ptr in
  let s = from_voidp string (to_voidp buf_addr) in
  !@s

let decode input =
  let out = CArray.make char ~initial:'\x00' (String.length input * 2) in
  let out_ptr = (CArray.start out) in
  let len_size_t = (Unsigned.Size_t.of_int (String.length input)) in
  Bindings.C.Function.base64_decode input len_size_t out_ptr (allocate_n ~count:1 size_t) 0;
  let buf_addr = allocate (ptr char) out_ptr in
  let s = from_voidp string (to_voidp buf_addr) in
  !@s