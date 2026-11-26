#!/usr/bin/env bash
# Terminal programs (nchat, yazi, btop) as their own macOS apps. Each app is a
# copy of Ghostty.app with its own bundle id, so it gets a separate Dock icon,
# Cmd+Tab entry and window state. Its main executable is a small launcher that
# starts the copied Ghostty with the program as the only command. The copies
# share ~/.config/ghostty, so they look like the normal terminal. Rerun after a
# Ghostty update; the copies do not update themselves.
#
# usage: tui-apps.sh [name...]   (no names builds every app in APPS)
set -euo pipefail

SOURCE=/Applications/Ghostty.app

# program|Dock icon screen gradient, bottom to top|app name (optional)
# The app name defaults to the program. nchat is published as "nc" so the app
# bundle, its id and executable carry that name, not the program's; the
# launcher still runs the real nchat binary.
APPS=(
  "nchat|#14532d,#22c55e|nc"
  "yazi|#1e3a8a,#60a5fa"
  "btop|#7c2d12,#f97316"
)

if [ ! -d "$SOURCE" ]; then
  echo "$SOURCE not found; ghostty is in the shell group" >&2
  exit 1
fi

NU="$(command -v nu || true)"
if [ -z "$NU" ]; then
  echo "nu not on PATH; nushell is in the shell group" >&2
  exit 1
fi

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# build <program> <colors> <app name>
build() {
  local prog="$1" colors="$2" name="$3"
  local app="/Applications/$name.app"
  local build="$WORK/$name.app"

  if ! command -v "$prog" >/dev/null 2>&1; then
    echo "skip $name: $prog not on PATH" >&2
    return 0
  fi
  if pgrep -f "$app/Contents/MacOS/" >/dev/null 2>&1; then
    echo "skip $name: $app is running; quit it first" >&2
    return 0
  fi

  ditto "$SOURCE" "$build"
  xattr -cr "$build"

  # The launcher is the bundle's main executable. exec keeps the process inside
  # this bundle, which is what gives the app its own identity in the Dock.
  # It is compiled C, not a shell script: macOS launch constraints kill /bin/sh
  # when it runs as an app's main executable, and clang ships with the Command
  # Line Tools, so it needs nothing from the langs group.
  # The program runs inside a nu login shell: an app started from the Dock
  # gets only the launchd PATH, and the login shell adds Homebrew, EDITOR and
  # the rest, which yazi openers and nchat voice notes (mpv) need.
  cat >"$WORK/$name.c" <<EOF
#include <libgen.h>
#include <mach-o/dyld.h>
#include <stdio.h>
#include <unistd.h>

int main(void) {
  char self[4096];
  uint32_t size = sizeof self;
  if (_NSGetExecutablePath(self, &size) != 0) return 1;
  char ghostty[4200];
  snprintf(ghostty, sizeof ghostty, "%s/ghostty", dirname(self));
  char *args[] = {
    ghostty,
    "--command=direct:$NU --login --commands $prog",
    "--title=$name",
    "--working-directory=home",
    "--window-save-state=never",
    "--quit-after-last-window-closed=true",
    "--auto-update=off",
    "--macos-icon=custom-style",
    "--macos-icon-frame=plastic",
    "--macos-icon-ghost-color=#ffffff",
    "--macos-icon-screen-color=$colors",
    NULL,
  };
  execv(ghostty, args);
  perror("execv");
  return 1;
}
EOF
  clang -O2 -o "$build/Contents/MacOS/$name" "$WORK/$name.c"

  local plist="$build/Contents/Info.plist"
  plutil -replace CFBundleExecutable -string "$name" "$plist"
  plutil -replace CFBundleIdentifier -string "local.dotfiles.$name" "$plist"
  plutil -replace CFBundleName -string "$name" "$plist"
  plutil -replace CFBundleDisplayName -string "$name" "$plist"
  # Without these the copy would compete with Ghostty for "Open With",
  # Services and Ghostty's exported file types, and would offer its updates.
  local key
  for key in CFBundleDocumentTypes NSServices UTExportedTypeDeclarations SUPublicEDKey; do
    plutil -remove "$key" "$plist" 2>/dev/null || true
  done

  # Changing Info.plist breaks Ghostty's signature; an ad-hoc one keeps the
  # entitlements, which macOS needs for the permission prompts.
  codesign --force --deep --sign - --preserve-metadata=entitlements "$build" 2>/dev/null
  codesign --verify --deep --strict "$build"

  rm -rf "$app"
  mv "$build" "$app"
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app"
  echo "installed $app"
}

found=0
for entry in "${APPS[@]}"; do
  prog="${entry%%|*}"
  rest="${entry#*|}"
  colors="${rest%%|*}"
  name="${rest#*|}"
  [ "$name" = "$rest" ] && name="$prog"   # no third field: app name is the program
  if [ $# -gt 0 ] && [[ " $* " != *" $prog "* && " $* " != *" $name "* ]]; then
    continue
  fi
  found=1
  build "$prog" "$colors" "$name"
done

if [ "$found" -eq 0 ]; then
  echo "usage: tui-apps.sh [name...]; known: nchat yazi btop" >&2
  exit 2
fi
