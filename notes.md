# Notes

Personal notes about the development.  

Thoughts and links :
Dune >= 3.0 pour ctypes  
Test sur freeBSD avec https://github.com/marketplace/actions/freebsd-vm  
Regarder pour la génération voire l'ecriture de stubs, benchmarker  
https://discuss.ocaml.org/t/cross-compiling-implementations-how-they-work/8686/2  
https://github.com/ocaml-cross/opam-cross-windows  
How should I install libffi on Mac OS X?  
The default version of libffi on Mac OS X 10.8 is too old. Use Homebrew to install a later version.  
Does ctypes work on Windows?  
Ctypes is written in OCaml and standard C, and is intended to work on all common platforms, including Windows. If you run into problems using ctypes on Windows, please give details on the issue tracker.  
What's the build process for code that uses stub generation ?  
There are examples in the async_ssl (using dune) and lz4 (using ocamlbuild) packages.  
y'a peut être moyen d'utiliser ocaml_string vu qu'on va pas relacher le runtime lock  
plus de choses sur ocaml_string https://lists.ocaml.org/pipermail/ctypes/2017-December/000248.html Essayer de benchmarker la consomation de mémoire et la vitesse  
ocaml-memcpy https://github.com/yallop/ocaml-memcpy  
documenter comment la librairie a été faite, et ses évolutions  
exemple de fonction où ça serait pas safe d'utiliser ocaml_string https://lists.ocaml.org/pipermail/ctypes/2017-December/000244.html  
compiler avec la bonne version de libffi sous mac os https://github.com/ocamllabs/ocaml-ctypes/issues/74  
peut peut être aider https://discuss.ocaml.org/t/ann-dkml-c-probe-cross-compiler-friendly-definitions-for-c-compiling/9950  
la même chose, faite à la main https://github.com/owlbarn/eigen/blob/0.3.0-backports/eigen/configure/configure.ml  
explications sur la cross compilation https://diskuv.gitlab.io/diskuv-ocaml/doc/CompilingInDepth.html  
ajouter une partie "installation" au readme avec "The bindings are available via OPAM: opam install based64"  
on pourrait forcer l'install de base64 la librairie C avec les packages opam conf-xxx type https://opam.ocaml.org/packages/conf-libdw/  
https://hub.docker.com/r/ocamlpro/ocaml  
To use perf: https://discuss.ocaml.org/t/ann-perf-demangling-of-ocaml-symbols-a-short-introduction-to-perf/7143  
Check lower bounds: https://blog.sim642.eu/2022/03/13/ocaml-dependencies-lower-bounds-ci.html  
To prevent docker from caching layers, add an argument (can be anything) at the point where you want it to stop using layers  
Might help with the objcopy issue? https://tratt.net/laurie/blog/2022/whats_the_most_portable_way_to_include_binary_blobs_in_an_executable.html  
https://doc.sherlocode.com/  
https://sherlocode.com/  
https://nullprogram.com/blog/2017/08/20/  
Tool that parses the opam files of all the conf-* packages and then you can search through them, for example search a command with or without an os/architecture  
A library that was changed to not require objcopy anymore: https://github.com/janestreet/ocaml_plugin/commit/6d09fe6f3938fef5e103b5824356c42d00393c9e  
objcopy on arm? https://github.com/mirage/xen/commit/010b823195b8c32559c6fde101d51a21458ef351  
https://github.com/mirage/xen/commit/b199c44afa3a0d18d0e968e78a590eb9e69e20ad  


## Make the opam CI work

| group         | item                          | reason for failure                 |
| ------------- | ----------------------------- | ---------------------------------- |
| compilers     | 4.11                          | lower bounds were not set properly |
| compilers     | 4.12                          | lower bounds were not set properly |
| compilers     | 4.13                          | lower bounds were not set properly |
| compilers     | 4.14                          | lower bounds were not set properly |
| distributions | alpine-3.14                   | ?                                  |
| distributions | alpine-3.15                   | ?                                  |
| distributions | fedora-34                     | something to do with ld and -fPIC  |
| distributions | fedora-35                     | something to do with ld and -fPIC  |
| distributions | macos-homebrew (experimental) | ?                                  |
| distributions | opensuse-15.3                 | ?                                  |
| distributions | oraclelinux-8                 | ?                                  |
| extras        | arm32                         | ?                                  |
| extras        | arm64                         | ?                                  |
| extras        | ppc64                         | ?                                  |
| extras        | s390x                         | ?                                  |
| extras        | x86_32                        | ?                                  |

Can't manage to get fedora working, even by adding -fPIC everywhere in the makefile. I wonder if opam is building the version with the new makefile.  
Managed to make it work after building my own dockerfile. I'll put it here for posterity:

```dockerfile
FROM ocaml/opam:fedora-34-ocaml-4.14@sha256:2c99951b32f2aec27e7dd60f409c0f2b907967a269e30db5e52220df0c9221e5

USER 1000:1000
WORKDIR /home/opam
RUN sudo ln -f /usr/bin/opam-dev /usr/bin/opam
RUN opam init --reinit -ni
ENV OPAMDOWNLOADJOBS="1"
ENV OPAMERRLOGLEN="0"
ENV OPAMSOLVERTIMEOUT="500"
ENV OPAMPRECISETRACKING="1"

RUN opam repository set-url --strict default opam-repository/
RUN opam update

ENV PATH="${PATH}:/home/opam/.opam/4.14/bin"

COPY --chown=1000:1000 . .
RUN opam install --deps-only --with-test .

RUN make build
RUN make test
```

Fedora 35 seems to be not working at all because of issues of seccomp that prevent any HTTP requests, from what I understand  
