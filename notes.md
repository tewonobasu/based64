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

| group         | item                          | reason for failure                 | status                      |
| ------------- | ----------------------------- | ---------------------------------- | --------------------------- |
| compilers     | 4.11                          | lower bounds were not set properly | fixed                       |
| compilers     | 4.12                          | lower bounds were not set properly | fixed                       |
| compilers     | 4.13                          | lower bounds were not set properly | fixed                       |
| compilers     | 4.14                          | lower bounds were not set properly | fixed                       |
| distributions | alpine-3.14                   | segfault                           |                             |
| distributions | alpine-3.15                   | segfault                           |                             |
| distributions | fedora-34                     | something to do with ld and -fPIC  | fixed                       |
| distributions | fedora-35                     | something to do with ld and -fPIC  | issue with the docker image |
| distributions | macos-homebrew (experimental) | ?                                  |                             |
| distributions | opensuse-15.3                 | something to do with ld and -fPIC  | fixed                       |
| distributions | oraclelinux-8                 | something to do with ld and -fPIC  | fixed                       |
| extras        | arm32                         | ?                                  |                             |
| extras        | arm64                         | ?                                  |                             |
| extras        | ppc64                         | ?                                  |                             |
| extras        | s390x                         | ?                                  |                             |
| extras        | x86_32                        | ?                                  |                             |

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
Trying it a few hours later, this time it's another issue:

```shell
Sending build context to Docker daemon  1.012MB
Step 1/17 : ARG toto
Step 2/17 : FROM ocaml/opam:fedora-35-ocaml-4.14
fedora-35-ocaml-4.14: Pulling from ocaml/opam
a0a60bad9321: Pull complete 
Digest: sha256:6ced737bb6829993d5cb0bcf5601dca380871f3a11ec37420155ac164f5391d8
Status: Downloaded newer image for ocaml/opam:fedora-35-ocaml-4.14
 ---> c5b1acf5a5dd
Step 3/17 : USER 1000:1000
 ---> Running in c043967ddd03
Removing intermediate container c043967ddd03
 ---> b0e54a70bcd1
Step 4/17 : WORKDIR /home/opam
 ---> Running in 84f8dcdbfdbe
Removing intermediate container 84f8dcdbfdbe
 ---> a4318ac7fec3
Step 5/17 : RUN sudo ln -f /usr/bin/opam-dev /usr/bin/opam
 ---> Running in 9b893585deab
Removing intermediate container 9b893585deab
 ---> 2e59813d305c
Step 6/17 : RUN opam init --reinit -ni
 ---> Running in d31e90f00c66
Configuring from /home/opam/.opamrc and then from built-in defaults.
Checking for available remotes: rsync and local, git.
  - you won't be able to use mercurial repositories unless you install the hg command on your system.
  - you won't be able to use darcs repositories unless you install the darcs command on your system.

Fatal error: Undefined boolean filter value: !(os = "openbsd" | os = "freebsd")
The command '/bin/sh -c opam init --reinit -ni' returned a non-zero code: 99
```

openSUSE seemed to be suffering from the same problem as Fedora, so I replaced the initial docker image in the above dockerfile by `ocaml/opam:opensuse-15.3-ocaml-4.14@sha256:3e710d1dd555b7da5d2b1599f83f72b3a473594a5b0a97ffa4d03940e33b4200` and everything worked!  
For oracle linux, same issue so I'm going to do the same thing but with `ocaml/opam:oraclelinux-8-ocaml-4.14@sha256:c38de8b8e540b0ec9bd11e35a518540ec684d9c02a1a17950ca34eca5e33425b`. It worked too.  

Trying to remove the usage of objcopy, wasn't successful  
De ce que j'ai compris le soucis c'est que y'a des symboles qui sont dupliqués et que du coup ça fait un problème de relocation quand on crée une librairie dynamique/statique, et passer un coup de objcopy permet d'éviter ça en rendant que certains symboles visibles  
The (temporary?) solution will be to add a conf-objcopy as a dependency, and configure it for where it works  

Alpine gives me an error but the test itself seem to work. I don't really understand what's happening here.  

```shell
Running[1]: (cd _build/default/test && ./test.exe)
File "test/dune", line 2, characters 7-11:
2 |  (name test)
           ^^^^
Command [1] got signal SEGV:
$ (cd _build/default/test && ./test.exe)
Testing `Based64'.
This run has ID `HZOL6UYP'.

  [OK]          encode decode          0   encode.
  [OK]          encode decode          1   encode and decode.

Full test results in `~/_build/default/test/_build/_tests/Based64'.
Test Successful in 0.000s. 2 tests run.
make: *** [Makefile:9: test] Error 1
The command '/bin/sh -c make test' returned a non-zero code: 2
```

From what I've searched, there are issues with PIC/PIE on Alpine and the fix is passing `-no-pie` to the compiler but I don't know which.  
What happens when I'm inside the container:

```shell
File "test/dune", line 2, characters 7-11:
2 |  (name test)
           ^^^^
Testing `Based64'.
This run has ID `MFU7F0KU'.

  [OK]          encode decode          0   encode.
  [OK]          encode decode          1   encode and decode.

Full test results in `~/_build/default/test/_build/_tests/Based64'.
Test Successful in 0.000s. 2 tests run.
```

When I run dune with verbose:

```shell
Running[1]: (cd _build/default/test && ./test.exe)
File "test/dune", line 2, characters 7-11:
2 |  (name test)
           ^^^^
Command [1] got signal SEGV:
$ (cd _build/default/test && ./test.exe)
Testing `Based64'.
This run has ID `SPYF7U5Z'.

  [OK]          encode decode          0   encode.
  [OK]          encode decode          1   encode and decode.

Full test results in '~/_build/default/test/_build/_tests/Based64'.
Test Successful in 0.000s. 2 tests run.
make: *** [Makefile:9: test] Error 1 
```

Might help https://discuss.ocaml.org/t/how-to-debug-a-terminated-by-signal-sigsegv-address-boundary-error/5936  
Valgrind reports some memory corruption, I'm trying to see where it comes from. A simple executable which encodes foobar doesn't have any issue.

About publishing on opam: I think the rule is to avoid changing stuff that's on opam, but if your package isn't yet on opam, it's okay to force push around to update the files and pass the tests