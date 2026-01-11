(lang dune 3.20)

(name json2dune)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name <author@example.com>")

(maintainers "Maintainer Name <maintainer@example.com>")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name json2dune)
 (synopsis "A short synopsis")
 (description "A longer description")
 (tags
  ("add topics" "to describe" your project))
 (depends
  (ocaml (>= 5.4.0))
  core
  core_unix
  ppx_jane
  ppx_expect
  yojson
  yaml
  )
)

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
