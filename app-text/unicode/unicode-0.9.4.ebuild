# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

DESCRIPTION="Display unicode character properties"
HOMEPAGE="http://kassiopeia.juls.savba.sk/~garabik/software/unicode/"
MY_P=$(replace_version_separator 1 '_' $P)
SRC_URI="http://kassiopeia.juls.savba.sk/~garabik/software/unicode/${MY_P}.tar.gz
		 unicode? ( http://www.unicode.org/Public/UNIDATA/UnicodeData.txt )
		 cjk? ( http://www.unicode.org/Public/UNIDATA/Unihan.zip )"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

#cjk downloads the Unihan database,
#unicode downloads the (newest) Unicode database,
#for which the program also looks for in known perl paths,
#but does not require them to run
IUSE="cjk unicode"
DEPEND=">=dev-lang/python-2.3
		cjk? ( app-arch/unzip )"
RDEPEND=">=dev-lang/python-2.3"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch ${FILESDIR}/${P}-gentooPerlPath.patch
}

src_install() {
	dobin unicode paracode
	dodoc README README-paracode COPYING
	doman *.1

	insinto /usr/share/unicode
	use unicode && doins "${DISTDIR}"/UnicodeData.txt
	use cjk && doins "${WORKDIR}"/Unihan.txt
	ecompressdir /usr/share/unicode
}
