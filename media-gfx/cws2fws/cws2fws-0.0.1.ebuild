# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: pornotube-dl-2007.10.09.ebuild 16 2008-02-05 00:48:42Z ludek $

DESCRIPTION="A small command-line program to decompress Macromedia SWF files."
HOMEPAGE="http://zefonseca.com/cws2fws/"
SRC_URI="http://zefonseca.com/cws2fws/release/${PN}"

RESTRICT="mirror"
LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

src_unpack() {
	:
}

src_install() {
	dobin "${DISTDIR}/${PN}"
}
