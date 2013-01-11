#!/bin/sh

TMPD=`mktemp -d`
DEST=`pwd`
echo AesCrypt ...


VERSION=1.0
TMP=$TMPD/aescrypt
mkdir -p "$TMP/cookbook"  "$TMP/pub/aescrypt" "$TMP/pub/guiedit"
cp AesCrypt/aescrypt.php "$TMP/cookbook"
cp AesCrypt/*.js "$TMP/pub/aescrypt"
cp AesCrypt/{close.png,maskbg.png,showpass.png} "$TMP/pub/aescrypt"
cp AesCrypt/aescrypt.png "$TMP/pub/guiedit"

tar -c -v -z -f aescrypt-$VERSION.tgz -C  "$TMP/" cookbook pub

( cd  "$TMP/" ; zip -v -9 -r "$DEST/aescrypt-$VERSION.zip" cookbook pub )


echo CachedNumberOfArticles ...

VERSION=1.0
TMP=$TMPD/cachednumberofarticles
mkdir -p "$TMP/cookbook"  "$TMP/wikilib.d"
cp CachedNumberOfArticles/noa.php "$TMP/cookbook"
cp CachedNumberOfArticles/Site.NumberOfArticles "$TMP/wikilib.d"

tar -c -v -z -f noa-$VERSION.tgz -C  "$TMP/" cookbook wikilib.d

( cd  "$TMP/" ; zip -v -9 -r "$DEST/noa-$VERSION.zip" cookbook wikilib.d )
