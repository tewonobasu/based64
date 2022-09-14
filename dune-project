(lang dune 3.3)
(using ctypes 0.1)
(formatting (enabled_for ocaml))

(name based64)

(generate_opam_files true)

(source
 (github tewonobasu/based64))

(authors "Arul")

(maintainers "Arul")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name based64)
 (synopsis "Bindings to https://github.com/aklomp/base64")
 (description "")
 (depends ocaml dune ctypes alcotest)
 (tags
  (topics "to describe" your project)))
