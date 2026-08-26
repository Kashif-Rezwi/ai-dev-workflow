#!/usr/bin/env bash
# Validate this single-skill repo against the Agent Skills standard.
#
# Layers (execution order):
#   1. Structure: frontmatter opens on line 1 and is closed.
#   2. Plain-scalar heuristic (always): an unquoted value containing ': ' is
#      invalid YAML; ' #' silently truncates the value. Quoted or block-scalar
#      values are left to the real parser.
#   3. Real YAML parsing when a runtime is available (python3+PyYAML, else ruby)
#      — catches frontmatter that strict harness parsers reject (e.g. Cline
#      silently skips a skill whose YAML does not parse).
#   4. Reference integrity: every skill file referenced by path must exist, and
#      references/checklists files must be reachable via progressive disclosure.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$REPO_ROOT"
file="$DIR/SKILL.md"
name="$(basename "$REPO_ROOT")"
fail=0

say_fail() { echo "  FAIL: $*"; fail=1; }
say_warn() { echo "  WARN: $*"; }

# --- YAML engine (prefer python3+PyYAML, then ruby's YAML stdlib) ----------
YAML_ENGINE=none
if command -v python3 >/dev/null 2>&1 && python3 -c "import yaml" >/dev/null 2>&1; then
  YAML_ENGINE=python
elif command -v ruby >/dev/null 2>&1; then
  YAML_ENGINE=ruby
fi

# yaml_get <file> <key> — print one frontmatter value; fail on invalid YAML.
yaml_get() {
  local file="$1" key="$2"
  if [ "$YAML_ENGINE" = python ]; then
    python3 - "$file" "$key" <<'PY'
import sys, yaml

lines = open(sys.argv[1], encoding="utf-8").read().splitlines()
try:
    close = lines[1:].index("---") + 1
except (ValueError, IndexError):
    sys.exit("frontmatter not closed")
try:
    data = yaml.safe_load("\n".join(lines[1:close])) or {}
except yaml.YAMLError as e:
    sys.exit(f"invalid YAML: {e}")
if not isinstance(data, dict):
    sys.exit("frontmatter is not a mapping")
value = data.get(sys.argv[2])
if value is None:
    sys.exit(f"missing field: {sys.argv[2]}")
print(value)
PY
  elif [ "$YAML_ENGINE" = ruby ]; then
    ruby -e '
require "yaml"
lines = File.read(ARGV[0]).split("\n")
close = lines[1..-1].index("---")
abort "frontmatter not closed" if close.nil?
begin
  data = YAML.safe_load(lines[1..close].join("\n")) || {}
rescue StandardError => e
  abort "invalid YAML: #{e}"
end
abort "frontmatter is not a mapping" unless data.is_a?(Hash)
value = data[ARGV[1]]
abort "missing field: #{ARGV[1]}" if value.nil?
puts value
' "$file" "$key"
  else
    return 1
  fi
}

# check_plain_scalars <file> — heuristic guard for unquoted ': ' and ' #'.
check_plain_scalars() {
  local key value
  while IFS= read -r line; do
    key="${line%%:*}"
    value="${line#*:}"
    value="${value#"${value%%[![:space:]]*}"}"
    case "$value" in
      \"*|\'*|\>*|\|*) ;;  # quoted or block-scalar: full parser handles it
      *": "*)
        say_fail "'$key' is a plain YAML scalar containing ': ' — invalid YAML; wrap it in double quotes or use a block scalar (strict parsers like Cline reject the skill)"
        ;;
      *" #"*)
        say_fail "'$key' is a plain YAML scalar containing ' #' — YAML treats it as a comment and truncates the value; wrap it in double quotes"
        ;;
    esac
  done < <(awk 'NR==1 && $0=="---"{next} /^---$/{exit} {print}' "$1" | grep -E '^[A-Za-z0-9_-]+:[[:space:]]*[^[:space:]]')
}

# orphan_check <sub> <fail|warn> — files in <sub>/<subdirs> must be referenced.
orphan_check() {
  local sub="$1" severity="$2"
  local f rel g found
  while IFS= read -r f; do
    rel="${f#$DIR/}"
    found=0
    while IFS= read -r g; do
    [ "$g" = "$f" ] && continue
      if grep -qF -- "$rel" "$g"; then found=1; break; fi
    done < <(find "$DIR" -name '*.md' -type f)
    if [ "$found" -eq 0 ]; then
      if [ "$severity" = fail ]; then
        say_fail "unreferenced instruction file: $rel — unreachable via progressive disclosure; reference it from another skill file or delete it"
      else
        say_warn "unreferenced file: $rel — not referenced by path anywhere in the skill"
      fi
    fi
  done < <(find "$DIR$sub" -type f)
}

echo "Checking $name"

if [ ! -f "$file" ]; then
  say_fail "missing $file"
  exit 1
fi

# 1. Frontmatter structure: starts on line 1 and is closed.
head -1 "$file" | grep -q '^---$' || say_fail "frontmatter must start on line 1"
if [ "$(grep -c '^---$' "$file")" -lt 2 ]; then
  say_fail "frontmatter must be closed by a second '---'"
  exit 1
fi

# 2. Plain-scalar heuristic (also protects the fallback path below).
check_plain_scalars "$file"

# 3. YAML validity + required fields.
fm_name=""
fm_desc=""
if [ "$YAML_ENGINE" != none ]; then
  if ! fm_name="$(yaml_get "$file" name 2>&1)"; then
    say_fail "frontmatter does not parse as YAML: $fm_name"
    exit 1
  fi
  if ! fm_desc="$(yaml_get "$file" description 2>&1)"; then
    say_fail "frontmatter does not parse as YAML: $fm_desc"
    exit 1
  fi
else
  say_warn "no YAML runtime found (install python3+PyYAML or ruby) — heuristic frontmatter checks only"
  fm_name="$(sed -n 's/^name:[[:space:]]*//p' "$file" | head -1)"
  fm_desc="$(sed -n 's/^description:[[:space:]]*//p' "$file" | head -1)"
  if [ -z "$fm_name" ]; then say_fail "missing 'name' field"; exit 1; fi
  if [ -z "$fm_desc" ]; then say_fail "missing 'description' field"; exit 1; fi
  case "$fm_desc" in
    '"'*) fm_desc="${fm_desc#\"}"; fm_desc="${fm_desc%\"}" ;;
    \'*)  fm_desc="${fm_desc#\'}"; fm_desc="${fm_desc%\'}" ;;
  esac
fi

# 4. name semantics: non-empty, lowercase-hyphenated, ≤64 characters.
fm_name="$(printf '%s' "$fm_name" | tr -d '[:space:]')"
[ -n "$fm_name" ] || say_fail "missing 'name' field"
printf '%s\n' "$fm_name" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' || say_fail "name must be lowercase alphanumeric with single hyphens"
[ "${#fm_name}" -le 64 ] || say_fail "name exceeds 64 characters"

# 5. description semantics: non-empty, ≤1024 characters.
[ -n "$(printf '%s' "$fm_desc" | tr -d '[:space:]')" ] || say_fail "missing 'description' field"
desc_len="$(printf '%s' "$fm_desc" | wc -c | tr -d '[:space:]')"
[ "$desc_len" -le 1024 ] || say_fail "description too long ($desc_len > 1024)"

# 6. Every skill file referenced by path must exist.
while IFS= read -r ref; do
  [ -e "$DIR/$ref" ] || say_fail "referenced file missing: $ref"
done < <(grep -rhoE '(references|templates|checklists|scripts|assets)/[A-Za-z0-9_./-]+\.(md|tmpl|yml|yaml|sh|py|json|txt)' --include='*.md' "$DIR" | sort -u)

# 7. Instruction files must be reachable via progressive disclosure.
orphan_check /references fail
orphan_check /checklists fail
orphan_check /templates warn

if [ "$fail" -eq 0 ]; then
  echo "All skills valid."
else
  echo "Validation failed." >&2
  exit 1
fi