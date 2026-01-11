# expect-tests

- use `ppx_expect`
- most of the time, you write tests in `let%expect_test` block and leave `[%expect {| |}]` in the end. Then use `dune test mytest.ml` + `dune promote diff` to see the difference. Or you simply use `dune test mytest.ml --auto-promote`.
