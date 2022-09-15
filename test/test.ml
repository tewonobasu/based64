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

let test_encode () =
  List.iter
    (fun (c, r) ->
      Alcotest.check Alcotest.string (sprintf "encode %s" c) (encode c) r)
    rfc4648_tests

let test_encode_and_decode () =
  List.iter
    (fun (c, _) ->
      Alcotest.check Alcotest.string
        (sprintf "encode and decode %s" c)
        (decode (encode c))
        c)
    rfc4648_tests

let () =
  let open Alcotest in
  run "Based64"
    [
      ( "encode decode",
        [
          test_case "encode" `Quick test_encode;
          test_case "encode and decode" `Quick test_encode_and_decode;
        ] );
    ]
