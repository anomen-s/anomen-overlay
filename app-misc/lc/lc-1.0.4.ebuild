# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

DESCRIPTION="Scans for broken symlinks"
HOMEPAGE="http://www.watzke.cz/"
SRC_URI="http://www.watzke.cz/files/${PF}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ia64"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PF}"

src_install() {
	emake DESTDIR="${D}" CFLAGS="${CFLAGS}" install
	dodoc ChangeLog README
}
