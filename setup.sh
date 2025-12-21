#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find all setup.sh scripts under subdirectories (exclude root)
mapfile -t scripts < <(find "$root_dir" -mindepth 2 -type f -name "setup.sh" | sort)

if [ ${#scripts[@]} -eq 0 ]; then
  echo "No setup.sh scripts found under $root_dir"
  exit 0
fi

run_all=false

for script in "${scripts[@]}"; do
  rel="${script#$root_dir/}"

  if [ "$run_all" = false ]; then
    while true; do
      printf "Run %s? [Y/NO/DONOTASK]: " "$rel"
      read -r choice
      case "${choice^^}" in
        Y)
          break
          ;;
        NO)
          echo "Skipping $rel"
          script=""
          break
          ;;
        DONOTASK)
          run_all=true
          break
          ;;
        *)
          echo "Please enter Y, NO, or DONOTASK."
          ;;
      esac
    done
  fi

  if [ -n "$script" ]; then
    echo "Running $rel"
    bash "$script"
  fi

done
