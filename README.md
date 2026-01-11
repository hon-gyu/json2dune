# json2dune

Convert JSON/YAML to [dune-flavored S-expressions](https://dune.readthedocs.io/en/stable/reference/lexical-conventions.html).

## Installation

```bash
dune build
dune install
```

## Usage

```bash
# From file (auto-detects format from extension)
json2dune config.yaml
json2dune data.json

# From stdin (defaults to JSON)
echo '{"name": "test"}' | json2dune

# Explicit format
json2dune --format yaml < input.txt
cat data.yml | json2dune --format yaml

# Get help
json2dune --help
```

## Examples

**Input (JSON):**
```json
["library", ["name", "mylib"], ["libraries", "base", "core"]]
```

**Output (dune):**
```dune
(library (name mylib) (libraries base core))
```

**Input (YAML):**
```yaml
library:
  name: mylib
  libraries:
    - base
    - core
```

**Output (dune):**
```lisp
((library ((name mylib) (libraries (base core)))))
```

## Type Mapping

| JSON/YAML | Dune |
|-----------|------|
| `string` | atom or quoted string |
| `number` | atom |
| `boolean` | `true` / `false` |
| `null` | `null` |
| `array` | list `(a b c)` |
| `object` | list of pairs `((key val))` |

## Use with `dynamic_include`

```dune
; Generate dune.inc from config.yaml
(rule
 (target dune.inc)
 (deps config.yaml)
 (action (run json2dune %{deps} -o %{target})))

; Include generated file
(dynamic_include dune.inc)
```
