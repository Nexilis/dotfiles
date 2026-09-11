#!/usr/bin/env bash
# Default apps for file types: ImageGlass for images, Skim for PDF. Runs after the
# apps casks, so the apps and duti are already installed. Idempotent: duti
# overwrites.
#
# An app has to be launched once before duti has any effect on it. A freshly
# installed cask is not fully registered with LaunchServices; duti then exits 0
# and the Apple default stays. Verified on macOS 26.6.
#
# Images get both a UTI list and an extension list, because LaunchServices
# resolves some formats (avif, jxl, webp on older macOS) only by extension.
#
# macOS 26 asks for confirmation in a dialog for each handler change made by a
# third-party tool. Approve the dialogs; until then `duti -x` still reports the
# old handler, so a stale summary line below is expected.
set -uo pipefail

IMAGEGLASS=com.duongdieuphap.imageglass
SKIM=net.sourceforge.skim-app.skim

if ! command -v duti >/dev/null 2>&1; then
  echo "duti not on PATH; it is in the apps group" >&2
  exit 1
fi

# Spotlight is not consulted: a copy made seconds ago is not indexed yet.
installed() {
  local plist
  for plist in /Applications/*.app/Contents/Info.plist "$HOME"/Applications/*.app/Contents/Info.plist; do
    [ -f "$plist" ] || continue
    [ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$plist" 2>/dev/null)" = "$1" ] && return 0
  done
  return 1
}

# $1 bundle id, $2 an extension whose handler tells whether the app already won
warm_up() {
  if ! installed "$1"; then
    echo "not installed: $1" >&2
    return 1
  fi
  if [ "$(duti -x "$2" 2>/dev/null | tail -1)" != "$1" ]; then
    open -g -b "$1" && sleep 3
    osascript -e "tell application id \"$1\" to quit" 2>/dev/null || true
  fi
}

if warm_up "$IMAGEGLASS" png; then
  for uti in public.image public.png public.jpeg public.jpeg-2000 public.tiff \
             public.heic public.heif public.avif public.svg-image \
             com.compuserve.gif com.microsoft.bmp com.microsoft.ico \
             org.webmproject.webp com.adobe.raw-image public.camera-raw-image; do
    duti -s "$IMAGEGLASS" "$uti" all 2>/dev/null || true
  done
  for ext in png jpg jpeg jpe gif webp heic heif avif bmp tif tiff ico svg jxl \
             psd tga dds raw arw cr2 cr3 nef dng orf raf rw2; do
    duti -s "$IMAGEGLASS" ".$ext" all 2>/dev/null || true
  done
  echo "images: $(duti -x png | tail -1)"
fi

if warm_up "$SKIM" pdf; then
  duti -s "$SKIM" com.adobe.pdf all
  duti -s "$SKIM" .pdf all
  echo "pdf: $(duti -x pdf | tail -1)"
fi
