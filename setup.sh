#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$root_dir/scripts/report-log.sh"
report_log_init "setup.sh" "$root_dir"

include_installed="${CONFS_SETUP_INCLUDE_INSTALLED:-}"

is_module_installed() {
  local module_dir="$1"
  local check_script="$module_dir/is-installed.step.sh"
  local module_name
  local fallback_check_script

  module_name="$(basename "$module_dir")"
  fallback_check_script="$root_dir/scripts/is-installed/${module_name}.step.sh"

  if [ -f "$check_script" ]; then
    bash "$check_script"
    return $?
  fi

  if [ -f "$fallback_check_script" ]; then
    bash "$fallback_check_script"
    return $?
  fi

  return 1
}

# Show current status before any installs
if [ -x "$root_dir/check.sh" ]; then
  "$root_dir/check.sh"
  echo
  printf "Continue with setup? [Y/NO]: "
  read -r proceed
  if [ "${proceed^^}" != "Y" ]; then
    echo "Aborting."
    exit 0
  fi
fi

# Find all setup.sh scripts under subdirectories (exclude root)
mapfile -t scripts < <(find "$root_dir" -mindepth 2 -type f -name "setup.sh" | sort)

if [ ${#scripts[@]} -eq 0 ]; then
  echo "No setup.sh scripts found under $root_dir"
  exit 0
fi

run_all=false
any_ran=false
any_missing=false

for script in "${scripts[@]}"; do
  rel="${script#$root_dir/}"

  module_dir="$root_dir/${rel%%/*}"
  if [ -z "$include_installed" ] && is_module_installed "$module_dir"; then
    echo "Skipping $rel (already installed)"
    continue
  fi
  any_missing=true

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
    any_ran=true
  fi

done

if [ -z "$include_installed" ] && [ "$any_missing" = false ]; then
  echo "All set. Nothing to install."
  exit 0
fi

echo
echo "=== README ==="
cat "$root_dir/README.md"
