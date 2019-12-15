(define-module (picat)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix build-system trivial)
  #:use-module (guix download)
  #:use-module (guix licenses)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages compression)
)

(define-public picat
  (package
    (name "picat")
    (version "2.8")
    (license mpl2.0)
    (source (origin
              (method url-fetch)
              (uri (string-append "http://picat-lang.org/download/picat28_src.tar.gz"
              ))
              (sha256
                (base32 
                  "02lyy8g42396qw6ajpzyq3qyagnad2r8i1imn10dnmh8azlgzn3r"
                )
              )
    ))
    (build-system trivial-build-system)
    (inputs
      (list
        (list "gcc-toolchain" gcc-toolchain)
        (list "zlib" zlib)
        (list "gnu-make" gnu-make)
        (list "tar" tar)
        (list "gzip" gzip)
      )
    )
    (arguments `(
      #:modules (
        (guix build utils)
      )
      #:builder
      (begin
        (use-modules 
          (guix build utils)
        )
        (let*
          (
            (source (assoc-ref %build-inputs "source"))
            (out (assoc-ref %outputs "out"))
            (bin (string-append out "/bin"))
            (tar (string-append
                   (assoc-ref %build-inputs "tar")
                   "/bin/tar"
                 )
            )
            (gz-loc (string-append
                  (assoc-ref %build-inputs "gzip")
                  "/bin"
                )
            )
            (jobs (getenv "NIX_BUILD_CORES"))
            (make-bin (string-append 
                        (assoc-ref %build-inputs "gnu-make") 
                        "/bin"
                      )
            )
            (gcc-tc (assoc-ref %build-inputs "gcc-toolchain"))
            (gcc-bin (string-append gcc-tc "/bin"))
            (gcc-incl (string-append gcc-tc "/include"))
            (gcc-lib (string-append gcc-tc "/lib"))
            (zlib-incl (string-append (assoc-ref %build-inputs "zlib") "/include"))
          )
          (setenv "PATH" (string-append gcc-bin ":" gz-loc ":" make-bin))
          (invoke tar "xzf" source)
          (chdir "Picat/emu")
          (mkdir-p bin)
          (setenv "CPATH" (string-append gcc-incl ":" zlib-incl))
          (setenv "LIBRARY_PATH" gcc-lib)
          (invoke 
            "make" (string-append "--jobs=" jobs) "--file=./Makefile.linux64" "picat"
          )
          (copy-file "picat" (string-append bin "/picat"))
        #t)
      )
    ))
    
    (synopsis "The Picat programming language")
    (description 
      "Picat is a simple, and yet powerful, logic-based multi-paradigm programming language aimed for general-purpose applications. Picat is a rule-based language, in which predicates, functions, and actors are defined with pattern-matching rules. Picat incorporates many declarative language features for better productivity of software development, including explicit non-determinism, explicit unification, functions, list comprehensions, constraints, and tabling. Picat also provides imperative language constructs, such as assignments and loops, for programming everyday things."
    )
    (home-page "http://picat-lang.org/")
  )
)
