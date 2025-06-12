#!/usr/bin/env bash

# ----------------------------
# Levenshtein distance function
# ----------------------------
levenshtein() {
  local str1="$1" str2="$2"
  local len1=${#str1} len2=${#str2}
  local cost i j
  local -a matrix

  for ((i = 0; i <= len1; i++)); do
    matrix[i * (len2 + 1)]=$i
  done
  for ((j = 0; j <= len2; j++)); do
    matrix[j]=$j
  done

  for ((i = 1; i <= len1; i++)); do
    for ((j = 1; j <= len2; j++)); do
      [[ "${str1:i-1:1}" == "${str2:j-1:1}" ]] && cost=0 || cost=1

      local del=$((matrix[(i-1)*(len2+1)+j] + 1))
      local ins=$((matrix[i*(len2+1)+(j-1)] + 1))
      local sub=$((matrix[(i-1)*(len2+1)+(j-1)] + cost))

      local min=$del
      [[ $ins -lt $min ]] && min=$ins
      [[ $sub -lt $min ]] && min=$sub

      matrix[i*(len2+1)+j]=$min
    done
  done

  echo "${matrix[len1*(len2+1)+len2]}"
}

# ----------------------------
# Configuration
# ----------------------------

base_command="./myapp"

valid_options=(
  start
  stop
  restart
  status
  setup
  config
  help
  version
)

# ----------------------------
# Parse input
# ----------------------------

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <arg1> [arg2 ...] [-- extra args...]"
  exit 1
fi

# Separate fuzzy args from passthrough args
fuzzy_inputs=()
passthrough_args=()
seen_double_dash=0

for arg in "$@"; do
  if [[ "$arg" == "--" ]]; then
    seen_double_dash=1
    continue
  fi
  if [[ $seen_double_dash -eq 0 ]]; then
    fuzzy_inputs+=("$arg")
  else
    passthrough_args+=("$arg")
  fi
done

# ----------------------------
# Fuzzy match each input
# ----------------------------
resolved_args=()

for input in "${fuzzy_inputs[@]}"; do
  declare -A distances
  for opt in "${valid_options[@]}"; do
    distances["$opt"]="$(levenshtein "$input" "$opt")"
  done

  best_match=$(for opt in "${!distances[@]}"; do echo "$opt ${distances[$opt]}"; done | sort -k2 -n | head -n1 | awk '{print $1}')
  resolved_args+=("$best_match")
done

# ----------------------------
# Output suggestion
# ----------------------------
echo -e "\nSuggested command:"
echo -e "$base_command ${resolved_args[*]} ${passthrough_args[*]}"
