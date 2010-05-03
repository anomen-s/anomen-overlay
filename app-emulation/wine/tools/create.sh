#!/bin/sh -x

PROFILE=$1
[[ -z "$1" ]]  && exit 1

export WINEPREFIX="$HOME/Wine/$PROFILE"
mkdir -p "$WINEPREFIX"

wineprefixcreate

mkdir -p "$WINEPREFIX/loop"
mkdir -p "$WINEPREFIX/home"

ln -sfn ../loop  "$WINEPREFIX/dosdevices/d:"
ln -sfn ../../drive_t "$WINEPREFIX/dosdevices/t:"
ln -sfn ../home "$WINEPREFIX/dosdevices/z:"
ln -sfn .. "$WINEPREFIX/dosdevices/p:"

for I in `seq 1 5 ` ; do
# wait for registry
 sleep 3
 test -s "$WINEPREFIX/system.reg" && break
done
sleep 1

cat >> "$WINEPREFIX/system.reg" << EOT

[Software\\\\Wine\\\\Drives] 1249894386
"d:"="cdrom"

EOT

for D in "Desktop" "My Documents" "My Music" "My Pictures" "My Videos"
do
    ln -sfn ../../../home "${WINEPREFIX}/drive_c/users/${USER}/${D}"
done

#############################################################################

cat > "$WINEPREFIX/config.sh" << EOT
#!/bin/sh -x
PROFILE=$PROFILE    # <<--- SET

export WINEPREFIX="\$HOME/Wine/\$PROFILE"
#export WINEDEBUG=-all

cd "\$WINEPREFIX/drive_c"

winecfg
#regedit

EOT

#############################################################################

cat > "$WINEPREFIX/run.sh" << EOT
#!/bin/sh -x

PROFILE=$PROFILE    # <<--- SET
ISOFILE=

# english locale
#export LC_ALL=en_US
#export LANG=en_US

export WINEPREFIX="\$HOME/Wine/\$PROFILE"
#export WINEDEBUG=-all

cd "\$WINEPREFIX"
if test -n "\$ISOFILE" ; then
  test -n  "\`ls loop/\`"  &&  fusermount -z -u "\$WINEPREFIX/loop"
  fuseiso "\$ISOFILE" "\$WINEPREFIX/loop"
fi

cd drive_c
# cpu freq
#sudo cpufreq-set -g performance  || echo cpu perf. setting failed

#taskset 01 wine "c:\\\\game\\\\game.exe"
taskset 01 wine "t:\\\\totalcmd\\\\totalcmd.exe"

if test -n "\$ISOFILE" ; then
  fusermount -z -u "\$WINEPREFIX/loop"
fi

### restore settings

#sudo cpufreq-set -g ondemand  || echo cpu perf. setting failed
#xrandr -s 1440x900 -r 54
#nvidia-settings -l

EOT

#############################################################################

chmod 755 "$WINEPREFIX/run.sh" "$WINEPREFIX/config.sh"

#winecfg

