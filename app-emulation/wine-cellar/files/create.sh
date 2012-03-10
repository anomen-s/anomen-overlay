#!/bin/sh

PROFILE="$1"
if [ -z "$1" ]; then
 echo 'Missing argument: profile name'
 exit 1
fi

export WINEARCH="win32"
export WINECELLAR="$HOME/Wine"
export WINEPREFIX="$WINECELLAR/$PROFILE"
export CELLAR_SHARE=/usr/share/wine/cellar

if [ ! -d "$WINECELLAR" ]; then
  echo Missing cellar: "$WINECELLAR"...
  echo Use $CELLAR_SHARE/install.sh to create it.
  exit 1
fi

mkdir -v -p "$WINEPREFIX" "$WINEPREFIX/loop" "$WINEPREFIX/home" "$WINEPREFIX/drive_c/wine"

cd "$WINEPREFIX/drive_c"
wine regedit "$CELLAR_SHARE/init.reg"

for I in `seq 1 5 ` ; do
# wait for registry
 sleep 3
 test -s "$WINEPREFIX/system.reg" && break
done
sleep 1

ln -v -s -f -n ../loop  "$WINEPREFIX/dosdevices/d:"
ln -v -s -f -n .. "$WINEPREFIX/dosdevices/p:"
ln -v -s -f -n ../../drive_t "$WINEPREFIX/dosdevices/t:"
ln -v -s -f -n /usr/share/fonts "$WINEPREFIX/dosdevices/v:"
ln -v -s -f -n /usr/share/wine "$WINEPREFIX/dosdevices/w:"
ln -v -s -f -n .. "$WINEPREFIX/dosdevices/z:"

echo 0 > "$WINEPREFIX/drive_c/wine/track_usage"

for D in "${WINEPREFIX}/drive_c/users/${USER}"/*
do
    if readlink "${D}"
    then
	ln -v -s -f -n ../../../home "${D}"
    fi
done

cp -f -v  "$CELLAR_SHARE/winemenubuilder.exe" "$WINEPREFIX/drive_c/windows/system32/"

for F in config.sh regedit.sh run.sh winetricks.sh
do
    sed -e  "s/@PROFILE@/$PROFILE/g" "$CELLAR_SHARE/$F.template" > "$WINEPREFIX/$F"
    chmod -v 755 "$WINEPREFIX/$F"
done

wine regedit "w:\\cellar\\setup.reg"

sleep 3

