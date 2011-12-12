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
 echo "D MISS: $2/$FN"
 exit 2
fi

#echo "#########"
#echo "$FN"

#echo "$1 / $2 / $3"
DIFF=`diff -wu "$1/$FN" "$2/$FN" | wc -l`

if [ 0 -eq "$DIFF" ]
then
# echo "same $FN ($SUM1)"
 echo "D KILL: $FN"
 rm -f "$1/$FN"
else
#echo ""
 echo "D DIFF: $FN"
fi
