open! Core

let is_yaml_file filename =
  String.is_suffix filename ~suffix:".yaml" || String.is_suffix filename ~suffix:".yml"

let () =
  let input, is_yaml =
    match Sys.get_argv () |> Array.to_list with
    | [ _ ] ->
      (* stdin - default to JSON *)
      (In_channel.(input_all stdin), false)
    | [ _; filename ] -> (In_channel.read_all filename, is_yaml_file filename)
    | _ ->
      eprintf "Usage: json2dune [FILE]\n";
      exit 1
  in
  let output =
    if is_yaml then Json2dune.convert_yaml_string input
    else Json2dune.convert_json_string input
  in
  print_endline output
