#! /bin/sh

# NOT TO BE CALLED DIRECTLY

# removes same files from SRC directory
#used by the "treecmp" script 

# args: srcdir, destdir, file_in_srcdir

DL=`expr length "$1"`
FL=`expr length "$3"`
FNL=`expr $FL '-' $DL`

FN=`expr substr "$3" '(' $DL '+' 2 ')' $FNL `

if [ "$1" '!=' "`expr substr "$3" 1 $DL`" ]
then
 echo "INVALID FILE: $3 !!!"
 exit 1
fi

if [ ! -f "$2/$FN" ]
then
 echo "S MISS: $2/$FN"
 exit 2
fi

#echo "#########"
#echo "$FN"

#echo "$1 / $2 / $3"
SUM1=`sha1sum "$1/$FN"`
SUM2=`sha1sum "$2/$FN"`

S1=`expr substr "$SUM1" 1 40`
S2=`expr substr "$SUM2" 1 40`

if [ "$S1" = "$S2" ]
then
# echo "same $FN ($SUM1)"
 echo "S KILL: $FN"
 rm -f "$1/$FN"
else
#echo ""
 echo "S DIFF: $FN"
fi
