# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A small and fast command line MP3 editor"
HOMEPAGE="http://www.puchalla-online.de/cutmp3.html"
SRC_URI="http://www.puchalla-online.de/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="media-sound/mpg123
		sys-libs/readline
		sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_install() {
	dobin ${PN}
	dodoc README* TODO Changelog USAGE BUGS COPYING
}
