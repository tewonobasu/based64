open Ctypes

let () =
  print_endline "at the start";
  let input = "foobarfoobarfoobarfoobarfoobarfoobar" in
  let out = CArray.make char ~initial:'\x00' ((String.length input)) in
  let input_ptr = (CArray.start (CArray.of_string input)) in
  let out_ptr = (CArray.start out) in
  let len_size_t = (Unsigned.Size_t.of_int 100) in
  print_endline "before external";
  Based64.C.Function.base64_encode input_ptr len_size_t out_ptr (allocate_n ~count:1 size_t) 0;
  
  print_endline "after external";
  let buf_addr = allocate (ptr char) (CArray.start out) in
  let s = from_voidp string (to_voidp buf_addr) in
  (* Printf.printf "%s\n" input; *)
  Printf.printf "%s\n" (!@s);
  ()