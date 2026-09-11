#!/usr/bin/env bash
# Make PicView the default app for image files. Runs after the apps casks, so
# PicView and duti are already installed. Idempotent: duti overwrites.
#
# PicView has to be launched once before duti has any effect. A freshly
# installed cask is not fully registered with LaunchServices; duti then exits 0
# and Preview stays the handler. Verified on macOS 26.6.
#
# Both a UTI list and an extension list, because LaunchServices resolves some
# formats (avif, jxl, webp on older macOS) only through the extension.
set -uo pipefail

BUNDLE=com.ruben2776.picview

if ! command -v duti >/dev/null 2>&1; then
  echo "duti not on PATH; it is in the apps group" >&2
  exit 1
fi
if ! mdfind "kMDItemCFBundleIdentifier == '$BUNDLE'" | grep -q .; then
  echo "PicView not installed ($BUNDLE)" >&2
  exit 1
fi

if [ "$(duti -x png 2>/dev/null | tail -1)" != "$BUNDLE" ]; then
  open -g -b "$BUNDLE" && sleep 3
  osascript -e "tell application id \"$BUNDLE\" to quit" 2>/dev/null || true
fi

for uti in public.image public.png public.jpeg public.jpeg-2000 public.tiff \
           public.heic public.heif public.avif public.svg-image \
           com.compuserve.gif com.microsoft.bmp com.microsoft.ico \
           org.webmproject.webp com.adobe.raw-image public.camera-raw-image; do
  duti -s "$BUNDLE" "$uti" all 2>/dev/null || true
done
for ext in png jpg jpeg jpe gif webp heic heif avif bmp tif tiff ico svg jxl \
           psd tga dds raw arw cr2 cr3 nef dng orf raf rw2; do
  duti -s "$BUNDLE" ".$ext" all 2>/dev/null || true
done

echo "PicView is the default image viewer ($(duti -x png | tail -1))"
