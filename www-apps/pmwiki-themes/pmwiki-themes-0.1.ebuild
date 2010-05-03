# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

DESCRIPTION="Collection of pmwiki themes"
HOMEPAGE="http://www.pmwiki.org/wiki/Cookbook/Skins"
THEME_URI="http://www.pmwiki.org/pmwiki/uploads/Cookbook/"
SRC_URI="${THEME_URI}/marathon04.zip
	${THEME_URI}/dropdown.zip
	${THEME_URI}/jhskin.zip
	${THEME_URI}/jhmpskin.zip
	${THEME_URI}/gemini.zip
	${THEME_URI}/fixflow.zip
	${THEME_URI}/SchlaeferTwo.zip
	${THEME_URI}/recurve.zip
	${THEME_URI}/phpnet.zip
	${THEME_URI}/Notebook2Skin_2.0.1.zip
	${THEME_URI}/evolver-0.3.zip
	${THEME_URI}/NeutralSkin.zip
	${THEME_URI}/pukka_float.zip
	${THEME_URI}/lens.zip
	${THEME_URI}/simple.zip
	${THEME_URI}/monobook.zip
	${THEME_URI}/wikilove.zip
	${THEME_URI}/somethingcorporate.zip
	${THEME_URI}/grease.zip
	${THEME_URI}/notsosimple-20051103.zip
	http://qdig.sourceforge.net/wiki-skins/LeanSkinForPmWiki-0.16.0.zip"

SLOT="0"
LICENSE="freedist"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="www-apps/pmwiki
	 app-arch/unzip"

src_unpack() {
	local bn
	mkdir "${S}"
	cd "${S}"
	for i in "${SRC_URI}" ; do
		bn=`basename $i`
		cp "${DISTDIR}/${bn}" .
		unpack "${bn}"
	done
	rm *.zip
	rm *.tar.gz
	pwd
	mv pub/skins/evolver .
	rmdir pub/skins/
	rmdir pub
	#We don't need Mac Stuff
	rm -rf __MACOSX
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	DESTDIR="/usr/share/pmwiki/Skins"
	dodir "${DESTDIR}"
	cp -a * "${D}/usr/share/pmwiki/Skins/"
}
