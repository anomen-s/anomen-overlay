# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A steganography program which hides data in various media files"
HOMEPAGE="http://steghide.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

DEPEND="
	app-crypt/mhash
	dev-libs/libmcrypt
	sys-libs/zlib
	virtual/jpeg"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc34.patch
	"${FILESDIR}"/${P}-gcc4.patch
	"${FILESDIR}"/${P}-gcc43.patch
)

src_prepare(){
	eautoreconf
	default
}

src_configure() {
	econf $(use_enable debug)
}

src_compile() {
	export CXXFLAGS="$CXXFLAGS -std=c++0x"
	local libtool
	[[ ${CHOST} == *-darwin* ]] && libtool=$(type -P glibtool) || libtool=$(type -P libtool)
	emake LIBTOOL="${libtool}" || die "emake failed"
}

src_install() {
	emake DESTDIR="${ED}" docdir="${EPREFIX}/usr/share/doc/${PF}" install || die "emake install failed"
}
