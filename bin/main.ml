open Ctypes

let () =
  let input = "foobar   foobar   foobar" in
  let out = CArray.make char ~initial:'\x00' (String.length input * 2) in
  let out_ptr = (CArray.start out) in
  let len_size_t = (Unsigned.Size_t.of_int (String.length input)) in
  Based64.C.Function.base64_encode input len_size_t out_ptr (allocate_n ~count:1 size_t) 0;
  let buf_addr = allocate (ptr char) (CArray.start out) in
  let s = from_voidp string (to_voidp buf_addr) in
  Printf.printf "%s\n" (!@s);
  ()