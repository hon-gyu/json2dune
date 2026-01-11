open! Core

type value =
  | String of string
  | Number of float
  | Bool of bool
  | Array of value list
  | Object of (string * value) list
[@@deriving sexp_of]


let is_atom_char = function
  | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '+' | '-' | '.' | '/' | ':' -> true
  | _ -> false

let is_valid_atom s = String.length s > 0 && String.for_all s ~f:is_atom_char

let escape_string s =
  let buf = Buffer.create (String.length s) in
  String.iter s ~f:(fun c ->
      match c with
      | '\n' -> Buffer.add_string buf "\\n"
      | '\r' -> Buffer.add_string buf "\\r"
      | '\t' -> Buffer.add_string buf "\\t"
      | '\b' -> Buffer.add_string buf "\\b"
      | '\\' -> Buffer.add_string buf "\\\\"
      | '"' -> Buffer.add_string buf "\\\""
      | '%' -> Buffer.add_string buf "\\%"
      | c -> Buffer.add_char buf c);
  Buffer.contents buf

let rec to_dune_string value =
  match value with
  | String s -> if is_valid_atom s then s else "\"" ^ escape_string s ^ "\""
  | Number f ->
    if Float.is_integer f then Int.to_string (Float.to_int f) else Float.to_string f
  | Bool b -> if b then "true" else "false"
  | Array items ->
    let inner = List.map items ~f:to_dune_string |> String.concat ~sep:" " in
    "(" ^ inner ^ ")"
  | Object pairs ->
    let pair_strs =
      List.map pairs ~f:(fun (k, v) ->
          let key_str = if is_valid_atom k then k else "\"" ^ escape_string k ^ "\"" in
          "(" ^ key_str ^ " " ^ to_dune_string v ^ ")")
    in
    "(" ^ String.concat ~sep:" " pair_strs ^ ")"

let rec of_yojson (json : Yojson.Basic.t) : value =
  match json with
  | `Null -> String "null"
  | `Bool b -> Bool b
  | `Int i -> Number (Float.of_int i)
  | `Float f -> Number f
  | `String s -> String s
  | `List items -> Array (List.map items ~f:of_yojson)
  | `Assoc pairs -> Object (List.map pairs ~f:(fun (k, v) -> (k, of_yojson v)))

let convert_json_string s =
  let json = Yojson.Basic.from_string s in
  let value = of_yojson json in
  to_dune_string value
