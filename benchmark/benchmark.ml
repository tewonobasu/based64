open Core
open Core_bench

let random_string len =
  String.map ~f:(fun _ -> Random.ascii ()) (String.make len 'a')

let main =
  Random.self_init ();
  let txt = random_string 1000000 in
  Command_unix.run
    (Bench.make_command
       [
         Bench.Test.create ~name:"base64 encode" (fun () ->
             ignore (Base64.encode_exn txt));
         Bench.Test.create ~name:"based64 encode" (fun () ->
             ignore (Based64.encode txt));
       ])

let () = ignore main
