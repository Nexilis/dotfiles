#!/usr/bin/env bash
# Install one or more package groups from bootstrap/macos-packages.txt.
#
# Usage:
#   install-group.sh <group>...     install the named groups
#   install-group.sh --all          install every group in manifest order
#   install-group.sh --interactive  ask y/n per group, then install
#   install-group.sh --list         print groups with package counts
#
# Extra flags:
#   --dry-run   print the brew commands instead of running them
#
# Nothing here fails the whole run. A package that will not install is reported
# and the rest continue; the failures are listed again at the end. brew is
# idempotent, so re-running a group is safe.
#
# The `work` group defaults to NO in --interactive: it is only for a machine
# used for CyberVadis, and it pulls macfuse (a kernel extension needing one-time
# reduced security on Apple Silicon).

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
BOOT=$(cd "$SCRIPT_DIR/.." && pwd)
MANIFEST="$BOOT/macos-packages.txt"

# Groups that default to "no" when asked interactively.
DEFAULT_NO="work"

DRY=0
MODE=groups
SELECTED=()

for a in "$@"; do
  case "$a" in
    --dry-run)     DRY=1 ;;
    --all)         MODE=all ;;
    --interactive) MODE=interactive ;;
    --list)        MODE=list ;;
    -*) echo "unknown flag: $a" >&2; exit 2 ;;
    *)  SELECTED+=("$a") ;;
  esac
done

[ -f "$MANIFEST" ] || { echo "manifest not found: $MANIFEST" >&2; exit 1; }

# rows GROUP -> the manifest rows of that group, comments stripped.
rows() {
  awk -v g="$1" '{ sub(/#.*/, "") } NF >= 3 && $1 == g { print $2, $3 }' "$MANIFEST"
}

# all_groups -> group names in manifest order, deduplicated.
all_groups() {
  awk '{ sub(/#.*/, "") } NF >= 3 { if (!seen[$1]++) print $1 }' "$MANIFEST"
}

FAILED=()

run() {
  if [ "$DRY" = 1 ]; then
    echo "  would run: $*"
    return 0
  fi
  "$@"
}

# install_batch KIND PKG...: one brew call for the whole list; on failure retry
# per package so the log names the one that actually broke.
install_batch() {
  local kind=$1; shift
  [ $# -gt 0 ] || return 0

  local -a cmd=(brew install)
  [ "$kind" = cask ] && cmd+=(--cask)

  echo "  $kind: $*"
  run "${cmd[@]}" "$@" && return 0

  echo "  batch failed, retrying one by one to isolate it"
  local p
  for p in "$@"; do
    run "${cmd[@]}" "$p" || FAILED+=("$kind:$p")
  done
}

install_group() {
  local group=$1
  local -a formulae=() casks=() scripts=()
  local kind pkg

  while read -r kind pkg; do
    case "$kind" in
      formula) formulae+=("$pkg") ;;
      cask)    casks+=("$pkg") ;;
      script)  scripts+=("$pkg") ;;
      *) echo "  unknown kind '$kind' for $pkg (skipped)" >&2 ;;
    esac
  done < <(rows "$group")

  if [ ${#formulae[@]} -eq 0 ] && [ ${#casks[@]} -eq 0 ] && [ ${#scripts[@]} -eq 0 ]; then
    echo "group '$group' not found in manifest" >&2
    FAILED+=("group:$group")
    return
  fi

  echo "== $group"
  # macOS ships bash 3.2, where "${arr[@]}" on an empty array trips set -u.
  # The ${arr[@]+...} guard expands to nothing instead of erroring.
  install_batch formula ${formulae[@]+"${formulae[@]}"}
  install_batch cask ${casks[@]+"${casks[@]}"}

  for pkg in ${scripts[@]+"${scripts[@]}"}; do
    local s="$SCRIPT_DIR/$pkg.sh"
    if [ ! -f "$s" ]; then
      echo "  script missing: $s" >&2
      FAILED+=("script:$pkg")
      continue
    fi
    echo "  script: $pkg"
    run bash "$s" || FAILED+=("script:$pkg")
  done
}

case "$MODE" in
  list)
    printf '%-12s %s\n' GROUP PACKAGES
    while read -r g; do
      printf '%-12s %s\n' "$g" "$(rows "$g" | wc -l | tr -d ' ')"
    done < <(all_groups)
    exit 0
    ;;
  all)
    while read -r g; do SELECTED+=("$g"); done < <(all_groups)
    ;;
  interactive)
    # Answers are read from /dev/tty, never from stdin. stdin here is whatever
    # the caller left behind (just runs the recipe through a shell, a pipe, a
    # redirect), and reading it made the prompts fly past without waiting.
    #
    # There is deliberately NO fallback to defaults. An earlier version printed
    # "taking the defaults" on end of input, which meant 11 of 12 groups were
    # answered YES by nobody. Installing software the operator never approved is
    # worse than doing nothing, so a missing terminal is a hard error.
    #
    # Test that /dev/tty can actually be OPENED. A permission check is not
    # enough: the node exists and looks readable even where there is no
    # controlling terminal (cron, a CI runner, a sandbox).
    if ! { : </dev/tty; } 2>/dev/null; then
      echo "brak terminala: --interactive potrzebuje /dev/tty." >&2
      echo "Uruchom skrypt z terminala, albo podaj grupy jawnie: install-group.sh <grupa>..., --all" >&2
      exit 3
    fi

    echo "Pick groups to install. Enter accepts the default in brackets."
    echo
    # Collect the group names FIRST: prompting inside a
    # `while read ... < <(all_groups)` loop would fight over the descriptor.
    ALL=()
    while read -r g; do ALL+=("$g"); done < <(all_groups)

    for g in ${ALL[@]+"${ALL[@]}"}; do
      n=$(rows "$g" | wc -l | tr -d ' ')
      if [[ " $DEFAULT_NO " == *" $g "* ]]; then
        prompt="[y/N]"; default=n
      else
        prompt="[Y/n]"; default=y
      fi
      printf '  %-12s %2s pkgs  %s ' "$g" "$n" "$prompt"
      if ! { read -r ans </dev/tty; } 2>/dev/null; then
        echo
        echo "przerwane (koniec wejścia); nic nie zostało zainstalowane." >&2
        exit 3
      fi
      ans=${ans:-$default}
      case "$ans" in
        [yY]*) SELECTED+=("$g") ;;
      esac
    done
    echo
    if [ ${#SELECTED[@]} -eq 0 ]; then
      echo "nothing selected"
      exit 0
    fi

    # Last gate before anything is written. The whole point of the group split
    # is that no package arrives unasked, so the choice is restated and has to be
    # confirmed explicitly.
    echo "Do instalacji: ${SELECTED[*]}"
    printf 'Kontynuować? [y/N] '
    if ! { read -r confirm </dev/tty; } 2>/dev/null; then
      echo
      echo "przerwane; nic nie zostało zainstalowane." >&2
      exit 3
    fi
    case "$confirm" in
      [yY]*) ;;
      *) echo "przerwane; nic nie zostało zainstalowane."; exit 0 ;;
    esac
    echo
    ;;
esac

if [ ${#SELECTED[@]} -eq 0 ]; then
  echo "no group given; try --list, --all or --interactive" >&2
  exit 2
fi

[ "$DRY" = 1 ] && echo "(dry-run; nothing is installed)"

for g in "${SELECTED[@]}"; do
  install_group "$g"
done

echo
if [ ${#FAILED[@]} -gt 0 ]; then
  echo "failed (${#FAILED[@]}):"
  printf '  %s\n' "${FAILED[@]}"
  exit 1
fi
echo "all selected groups done"
