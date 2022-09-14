(lang dune 3.3)
(using ctypes 0.1)
(formatting (enabled_for ocaml))

(name ocaml_ctypes_example)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Arul")

(maintainers "Arul")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name ocaml_ctypes_example)
 (synopsis "Ctypes stubs example")
 (description "Ctypes stubs example with dune")
 (depends ocaml dune)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
