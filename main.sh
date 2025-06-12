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

base_command="./myapp"  # TODO: Write actual name of app

valid_options=(
  start
  stop
  restart
  status
  setup
  config
  help
  version
) # TODO: Update with actual arguemnts for app

# ----------------------------
# Input parsing
# ----------------------------
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <option> [args...]"
  exit 1
fi

user_input="$1"
shift
extra_args=("$@")

# ----------------------------
# Find best match
# ----------------------------
declare -A distances
for option in "${valid_options[@]}"; do
  distances["$option"]="$(levenshtein "$user_input" "$option")"
done

# Sort matches by distance
mapfile -t sorted < <(
  for option in "${!distances[@]}"; do
    echo "$option ${distances[$option]}"
  done | sort -k2 -n
)

best_match=$(echo "${sorted[0]}" | awk '{print $1}')

# ----------------------------
# Output suggestion
# ----------------------------
echo -e "\n\033[1mSuggested command:\033[0m"
echo -e "\033[32m$base_command $best_match ${extra_args[*]}\033[0m"
