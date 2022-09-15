open Ctypes
include Bindings

let char_array_as_string a = Ctypes.(string_from_ptr (CArray.start a) ~length:(CArray.length a))

(* 
let helper fn input =
  let len_size_t = (Unsigned.Size_t.of_int (String.length input)) in
  let len = (allocate_n ~count:1 int) in
  print_endline "aaa";
  let out = (Bindings.C.Function.based64_owo(len)) in
  let a =  CArray.from_ptr out 5 in
  print_endline "aaa";
  Printf.printf "bbb %s" (out);
  print_endline "ccc";

  out

let encode = helper Bindings.C.Function.base64_encode

let decode = helper Bindings.C.Function.base64_encode
 *)


 let string_to_char_ptr s = Ctypes.CArray.of_string s |> Ctypes.CArray.start

let helper fn input =
  let out = CArray.make char (String.length input * 2) in
  let out_ptr = (CArray.start out) in
  let len_size_t = (Unsigned.Size_t.of_int (String.length input)) in
  let len_out = (allocate_n size_t 0) in
  fn input len_size_t out_ptr len_out 0;
  string_from_ptr out_ptr (Unsigned.Size_t.to_int (!@len_out))

let encode = helper Bindings.C.Function.base64_encode

let decode = helper Bindings.C.Function.base64_decode
