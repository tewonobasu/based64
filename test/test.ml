open Printf
open Based64

let rfc4648_tests =
  [
    ("", "");
    ("f", "Zg==");
    ("fo", "Zm8=");
    ("foo", "Zm9v");
    ("foob", "Zm9vYg==");
    ("fooba", "Zm9vYmE=");
    ("foobar", "Zm9vYmFy");
  ]

let test_rfc4648 () =
  List.iter
    (fun (c, r) ->
      Alcotest.check Alcotest.string
        (sprintf "encode %s" c) (encode c) r)
        rfc4648_tests
      (* Base64 vs test cases above *)
      (* Alcotest.(check string) (sprintf "encode decode %s" c) (decode (encode c)) r *)

let () =
  let open Alcotest in 
  run "Based64" [
    "encode decode", [test_case "rfc4648" `Quick test_rfc4648;];
  ]
