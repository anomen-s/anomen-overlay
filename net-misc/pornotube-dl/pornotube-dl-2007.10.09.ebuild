# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A small command-line program to download videos from pornotube.com."
HOMEPAGE="http://www.arrakis.es/~rggi3/pornotube-dl/"
SRC_URI="http://www.arrakis.es/~rggi3/${PN}/${P}"

RESTRICT="mirror"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4"
RDEPEND="${DEPEND}"

src_unpack() {
	:
}

src_install() {
	dobin "${DISTDIR}/${P}"
	dosym "${P}" "/usr/bin/${PN}"
}
