# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"
inherit eutils

PYTHON_COMPAT=( python3_{6,7,8,9} )

DESCRIPTION="Display unicode character properties"
HOMEPAGE="http://kassiopeia.juls.savba.sk/~garabik/software/unicode/"
SRC_URI="https://github.com/garabik/unicode/archive/v${PV}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="unihan"

BDEPEND="app-arch/unzip"
RDEPEND="=dev-lang/python-3*
	app-i18n/unicode-data"
DEPEND="${RDEPEND}"

DOCS=(README{,-paracode} COPYING debian/changelog)

UNICODE_DIR=/usr/share/unicode-data


src_compile() {
	use unihan && unzip "$UNICODE_DIR/Unihan.zip"
}

src_install() {
	default

	dobin unicode paracode
	doman *.1

	insinto "$UNICODE_DIR"
	use unihan && doins Unihan*.txt
}
