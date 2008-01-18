# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="GNU groff wrapper taking UTF-8 encoded manual pages"
HOMEPAGE="http://www.haible.de/bruno/packages-groff-utf8.html"
SRC_URI="http://www.haible.de/bruno/gnu/${PN}.tar.gz"

RESTRICT=mirror

LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=">=sys-apps/groff-1.18.1"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack "${A}" &&
	cd "${S}" || die "unpack failed"
}

src_compile() {
	emake CFLAGS="${CFLAGS}" DESTDIR="${D}" PREFIX="/usr" ||
	die "make failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "make install failed"
}

pkg_postinst() {
	einfo "Sample use:"
	einfo "  $ groff-utf8 -Tutf8 -mandoc find.vi.1 | less"
	einfo "  $ groff-utf8 -Thtml -mandoc find.vi.1 >"\
		"find.html; mozilla find.html"
	einfo "You can also in /etc/man.conf edit the definition of the"
	einfo "variable NROFF, to use groff-utf8 instead of groff:"
	einfo "  NROFF           /usr/bin/groff-utf8 -Tutf8 -c -mandoc"
}

