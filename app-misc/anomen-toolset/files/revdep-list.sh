#! /bin/sh

# Creates list of packages needed to rebuild due to broken deps.

#if [ "$1" != "-n" ] ; then
P=--pretend
#fi

revdep-rebuild -vv -i --keep-temp $P # --ignore --pretend


cat > revdep.emerge.sh <<"END_TEXT"
#!/bin/sh

emerge --keep-going -1 -v \
END_TEXT

cat /var/cache/revdep-rebuild/5_order.rr | while read P
do
  echo "=$P \\" >> revdep.emerge.sh
done

echo " " >> revdep.emerge.sh

chmod 755 revdep.emerge.sh


