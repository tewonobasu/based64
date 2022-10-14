(lang dune 3.3)
(using ctypes 0.1)
(formatting (enabled_for ocaml))

(name based64)
(version 1.0.0)

(generate_opam_files true)

(source
 (github tewonobasu/based64))

(authors "Jérémie MARTIN <martin.jeremie42@gmail.com>" "Lucas DE ANGELIS <deangelis.lucas@outlook.com>")

(maintainers "Jérémie MARTIN <martin.jeremie42@gmail.com>" "Lucas DE ANGELIS <deangelis.lucas@outlook.com>")

(license MIT)

(package
 (name based64)
 (synopsis "Bindings to https://github.com/aklomp/base64")
 (description "")
 (depends
  (ocaml (>= 4.11))
  (dune (>= 3.3))
  (ctypes (>= 0.15))
  (alcotest (and (>= 0.8.0) :with-test)))
 (tags
  (base64 "C bindings"))
 (allow_empty))
