(define-module (picat)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
)

(define-public picat
  (package
    (name "picat")
    (version "2.8")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://picat-lang.org/download/picat28_src.tar.gz"
              ))
              (sha256
                (base32 
                  "02lyy8g4396qw6ajpzyq3qyagnad2r8i1imn10dnmh8azlgzn3r"
                )
              )
    ))
    (build-system gnu-build-system)
    (arguments `(
      #:make-flags (list "picat")
      #:tests? #f
      #:phases
        (modify-phases %standard-phases
          (delete 'configure)
          (delete 'install)
        )
    ))
    (synopsis "The Picat programming language")
    (description 
      "Picat is a simple, and yet powerful, logic-based multi-paradigm programming language aimed for general-purpose applications. Picat is a rule-based language, in which predicates, functions, and actors are defined with pattern-matching rules. Picat incorporates many declarative language features for better productivity of software development, including explicit non-determinism, explicit unification, functions, list comprehensions, constraints, and tabling. Picat also provides imperative language constructs, such as assignments and loops, for programming everyday things."
    )
    (home-page "http://picat-lang.org/")
    (license gpl3+)
  )
)
picat
