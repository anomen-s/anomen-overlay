# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="odt2txt is a command-line tool which extracts the text out of
OpenDocument Texts produced by OpenOffice.org, StarOffice, KOffice and
others."
HOMEPAGE="http://stosberg.net/odt2txt/"
SRC_URI="http://stosberg.net/odt2txt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/zlib
virtual/libiconv"
RDEPEND=""

src_install() {
	make DESTDIR=../../image/ PREFIX=/usr install
}
