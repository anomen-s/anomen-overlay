# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
inherit distutils-r1

DESCRIPTION="Display unicode character properties"
HOMEPAGE="http://kassiopeia.juls.savba.sk/~garabik/software/unicode/"
SRC_URI="https://github.com/garabik/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="unihan"

DEPEND="app-i18n/unicode-data"
RDEPEND="${DEPEND}"
BDEPEND="unihan? ( app-arch/unzip )"

DOCS=(README{,-paracode} COPYING debian/changelog debian/copyright)

UNICODE_DIR=/usr/share/unicode-data

src_compile() {
	distutils-r1_src_compile

	use unihan && unzip "$UNICODE_DIR/Unihan.zip"
}

src_install() {
	distutils-r1_src_install

	doman *.1

	insinto "$UNICODE_DIR"
	use unihan && doins Unihan*.txt
}
