# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python im-/export filters for MS Excel files. Including xls2txt, xls2csv and xls2html commands."
HOMEPAGE="http://sourceforge.net/projects/pyexcelerator"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
RESTRICT="mirror"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

src_install() {
	distutils-r1_src_install

	dobin tools/xls2csv.py
	dobin tools/xls2html.py
	dobin tools/xls2txt.py

	if use examples ; then
		insinto /usr/share/doc/"${PF}"/examples
		doins -r examples/*
	fi
}
