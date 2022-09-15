(lang dune 3.3)
(using ctypes 0.1)
(formatting (enabled_for ocaml))

(name based64)
(version 1.0)

(generate_opam_files true)

(source
 (github tewonobasu/based64))

(authors "Jérémie MARTIN <martin.jeremie42@gmail.com>, Lucas DE ANGELIS <deangelis.lucas@outlook.com>")

(maintainers "Jérémie MARTIN <martin.jeremie42@gmail.com>, Lucas DE ANGELIS <deangelis.lucas@outlook.com>")

(license MIT)

(documentation "https://github.com/tewonobase/based64/README.md")

(package
 (name based64)
 (synopsis "Bindings to https://github.com/aklomp/base64")
 (description "")
 (depends
  (ocaml (>= 4.11))
  dune
  ctypes
  (alcotest :with-test))
 (tags
  (base64 "C bindings"))
 (allow_empty))
