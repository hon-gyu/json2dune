open! Core

let is_yaml_file filename =
  String.is_suffix filename ~suffix:".yaml" || String.is_suffix filename ~suffix:".yml"

let run format_opt filename_opt () =
  let input, format =
    match filename_opt with
    | None ->
      (* stdin *)
      let fmt =
        match format_opt with
        | Some f -> f
        | None -> `Json (* default to JSON for stdin *)
      in
      (In_channel.(input_all stdin), fmt)
    | Some filename ->
      let fmt =
        match format_opt with
        | Some f -> f
        | None ->
          (* auto-detect from extension *)
          if is_yaml_file filename then `Yaml else `Json
      in
      (In_channel.read_all filename, fmt)
  in
  let output =
    match format with
    | `Yaml -> Json2dune.convert_yaml_string input
    | `Json -> Json2dune.convert_json_string input
  in
  print_endline output

let () =
  Command.basic
    ~summary:"Convert JSON/YAML to dune S-expressions"
    ~readme:(fun () ->
      "Converts JSON or YAML input to valid dune-flavored S-expressions.\n\n\
       Examples:\n\
      \  json2dune config.yaml\n\
      \  json2dune --format yaml < input.txt\n\
      \  cat data.json | json2dune")
    (let%map_open.Command format =
       flag
         "--format"
         (optional (Arg_type.create (fun s ->
              match String.lowercase s with
              | "json" -> `Json
              | _ when is_yaml_file s -> `Yaml
              | _ -> failwith "Format must be 'json' or 'yaml'")))
         ~doc:"FORMAT Input format: json or yaml (auto-detect by default)"
     and filename = anon (maybe ("FILE" %: string)) in
     run format filename)
  |> Command_unix.run
