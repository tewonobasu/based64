let () =
  let input = "foobarfoobar" in
  let encoded = Based64.encode input in
  let decoded = Based64.decode encoded in

  print_endline encoded;
  print_endline decoded;