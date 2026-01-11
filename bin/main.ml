open! Core

let () =
  let input =
    match Sys.get_argv () |> Array.to_list with
    | [ _ ] -> In_channel.(input_all stdin)
    | [ _; filename ] -> In_channel.read_all filename
    | _ ->
      eprintf "Usage: json2dune [FILE]\n";
      exit 1
  in
  let output = Json2dune.convert_json_string input in
  print_endline output
