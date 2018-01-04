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

export REAL_HOME="$HOME"
export HOME="$WINEPREFIX"
export XDG_CONFIG_HOME="$WINEPREFIX/.config"
export XDG_DATA_HOME="$WINEPREFIX/.local"

if [ ! -d "$WINECELLAR" ]; then
  echo Missing cellar: "$WINECELLAR"...
  echo Use $CELLAR_SHARE/install.sh to create it.
  exit 1
fi

echo '*** precreate WINEPREFIX'

for A in loop home drive_c/wine .config .local/share
do
 mkdir -v -p "$WINEPREFIX/$A"
done

for A in .fontconfig
do
 echo cp $A
 cp -a -t "$WINEPREFIX" "$REAL_HOME/$A"
done

echo 0 > "$WINEPREFIX/drive_c/wine/track_usage"

for F in config.sh regedit.sh run.sh winetricks.sh gitinit.sh
do
    sed -e  "s/@PROFILE@/$PROFILE/g" "$CELLAR_SHARE/$F.template" > "$WINEPREFIX/$F"
    chmod -v 755 "$WINEPREFIX/$F"
done

echo '*** wine wineboot...'

cd "$WINEPREFIX/drive_c"
wine wineboot


for I in `seq 1 10 ` ; do
# wait for registry
 sleep 3
 test -s "$WINEPREFIX/system.reg" && break
done
sleep 1

ln -v -s -f -n ../loop  "$WINEPREFIX/dosdevices/d:"
ln -v -s -f -n .. "$WINEPREFIX/dosdevices/p:"
ln -v -s -f -n ../../drive_t "$WINEPREFIX/dosdevices/t:"
ln -v -s -f -n /usr/share "$WINEPREFIX/dosdevices/s:"


echo '*** wine fixing links to $HOME...'

for D in "${WINEPREFIX}/drive_c/users/${USER}"/*
do
    if readlink "${D}"
    then
	ln -v -s -f -n ../../../home "${D}"
    fi
done

ln -v -s -f -n .. "$WINEPREFIX/dosdevices/z:"

wine regedit "s:\\wine\\cellar\\setup.reg"

