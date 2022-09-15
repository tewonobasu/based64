# Notes

Personal notes about the development.

Dune >= 3.0 pour ctypes
Test sur freeBSD avec https://github.com/marketplace/actions/freebsd-vm
Regarder pour la génération voire l'ecriture de stubs, benchmarker
Cross compilation :
- https://discuss.ocaml.org/t/cross-compiling-implementations-how-they-work/8686/2
- https://github.com/ocaml-cross/opam-cross-windows
- How should I install libffi on Mac OS X?
The default version of libffi on Mac OS X 10.8 is too old. Use Homebrew to install a later version.
- Does ctypes work on Windows?
Ctypes is written in OCaml and standard C, and is intended to work on all common platforms, including Windows. If you run into problems using ctypes on Windows, please give details on the issue tracker.
- What's the build process for code that uses stub generation ?
There are examples in the async_ssl (using dune) and lz4 (using ocamlbuild) packages.
- y'a peut être moyen d'utiliser ocaml_string vu qu'on va pas relacher le runtime lock
- plus de choses sur ocaml_string https://lists.ocaml.org/pipermail/ctypes/2017-December/000248.html Essayer de benchmarker la consomation de mémoire et la vitesse
- ocaml-memcpy https://github.com/yallop/ocaml-memcpy
- documenter comment la librairie a été faite, et ses évolutions 
- exemple de fonction où ça serait pas safe d'utiliser ocaml_string https://lists.ocaml.org/pipermail/ctypes/2017-December/000244.html
- compiler avec la bonne version de libffi sous mac os https://github.com/ocamllabs/ocaml-ctypes/issues/74
- peut peut être aider https://discuss.ocaml.org/t/ann-dkml-c-probe-cross-compiler-friendly-definitions-for-c-compiling/9950
- la même chose, faite à la main https://github.com/owlbarn/eigen/blob/0.3.0-backports/eigen/configure/configure.ml
- explications sur la cross compilation https://diskuv.gitlab.io/diskuv-ocaml/doc/CompilingInDepth.html
- ajouter une partie "installation" au readme avec "The bindings are available via OPAM: opam install based64"
- on pourrait forcer l'install de base64 la librairie C avec les packages opam conf-xxx type https://opam.ocaml.org/packages/conf-libdw/


To use perf: https://discuss.ocaml.org/t/ann-perf-demangling-of-ocaml-symbols-a-short-introduction-to-perf/7143