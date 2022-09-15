open Core
open Core_bench

let random_string len =
  String.map ~f:(fun _ -> Random.ascii ()) (String.make len 'a')

let txt = Random.self_init (); random_string 1000000
let encoded_txt = Based64.encode txt

let bench1 =
  Command_unix.run
    (Bench.make_command
       [
         Bench.Test.create ~name:"base64 encode" (fun () ->
             ignore (Base64.encode txt));
         Bench.Test.create ~name:"based64 encode" (fun () ->
             ignore (Based64.encode txt));
       ])

let bench2 =
Command_unix.run
  (Bench.make_command
      [
        Bench.Test.create ~name:"base64 decode" (fun () ->
            ignore (Base64.decode encoded_txt));
        Bench.Test.create ~name:"based64 decode" (fun () ->
            ignore (Based64.decode encoded_txt));
  ])

let () =
ignore bench1;
ignore bench2
