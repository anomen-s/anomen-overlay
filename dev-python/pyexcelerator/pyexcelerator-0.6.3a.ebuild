# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python im-/export filters for MS Excel files. Including xls2txt, xls2csv and xls2html commands."
HOMEPAGE="http://sourceforge.net/projects/pyexcelerator"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="virtual/python"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${P/pyexcelerator/pyExcelerator}"

src_install() {
	distutils_src_install
	cd tools
	for f in xls*.py; do
		newbin "${f}" "${f%.*}"
	done
}
