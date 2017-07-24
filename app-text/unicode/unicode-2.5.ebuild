# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils versionator

DESCRIPTION="Display unicode character properties"
HOMEPAGE="http://kassiopeia.juls.savba.sk/~garabik/software/unicode/"
SRC_URI="https://github.com/garabik/unicode/archive/v${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""
DEPEND="dev-lang/python
		app-i18n/unicode-data"
RDEPEND="${DEPEND}"

src_install() {
	dobin unicode paracode
	dodoc README README-paracode COPYING debian/changelog
	doman *.1
}
