#!/bin/sh

export WINEARCH="win32"
export WINECELLAR="$HOME/Wine"
export CELLAR_SHARE=/usr/share/wine/cellar

if [ -d "$WINECELLAR" ]; then
  echo Cellar already exists.
  exit 1
fi

echo Creating cellar in "$WINECELLAR"...
mkdir -v "$WINECELLAR" ||  exit 1
mkdir -v "$WINECELLAR/drive_t" || exit 1

ln -v -s ../.wine "$WINECELLAR/Default"
ln -v -s "$CELLAR_SHARE/create.sh" "$WINECELLAR/create.sh"


