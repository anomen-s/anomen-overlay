# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils versionator

DESCRIPTION="Display unicode character properties"
HOMEPAGE="http://kassiopeia.juls.savba.sk/~garabik/software/unicode/"
MY_P=$(replace_version_separator 1 '_' $P)
SRC_URI="http://kassiopeia.juls.savba.sk/~garabik/software/unicode/${MY_P}.tar.gz
		http://kassiopeia.juls.savba.sk/~garabik/software/unicode/old/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""
DEPEND="dev-lang/python
		app-i18n/unicode-data"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch ${FILESDIR}/${P}-gentooPath.patch
}

src_install() {
	dobin unicode paracode
	dodoc README README-paracode COPYING
	doman *.1
}
