open! Core
open Json2dune

let test json_str =
  let result = convert_json_string json_str in
  print_endline result

let%expect_test "array to list" =
  test {|["library", ["name", "mylib"], ["libraries", "base", "core"]]|};
  [%expect {| (library (name mylib) (libraries base core)) |}]

let%expect_test "object to pairs" =
  test {|{"name": "mylib", "public_name": "my-lib"}|};
  [%expect {| ((name mylib) (public_name my-lib)) |}]

let%expect_test "string with spaces gets quoted" =
  test {|{"message": "hello world"}|};
  [%expect {| ((message "hello world")) |}]

let%expect_test "numbers and bools" =
  test {|[42, 3.14, true, false]|};
  [%expect {| (42 3.14 true false) |}]

let%expect_test "nested structure" =
  test {|{"outer": {"inner": "value"}}|};
  [%expect {| ((outer ((inner value)))) |}]

let%expect_test "special characters escaped" =
  test {|{"path": "foo\\bar", "msg": "line1\nline2"}|};
  [%expect {| ((path "foo\\bar") (msg "line1\nline2")) |}]

let%expect_test "null becomes atom" =
  test {|{"key": null}|};
  [%expect {| ((key null)) |}]
