# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="open source software for reading and writing Data Matrix barcodes"
HOMEPAGE="http://www.libdmtx.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+imagemagick"

DEPEND="imagemagick? ( media-gfx/imagemagick )"
RDEPEND=""

pkg_setup() {
	if ! use imagemagick ; then
		ewarn "No USE=\"imagemagick\" selected, this build will not include command line tools (dmtxquery,dmtxread,dmtxwrite)."
	fi
}

src_compile() {
#TODO
#  --enable-cocoa          enable Cocoa bindings
#  --enable-java           enable Java bindings
#  --enable-net            enable .NET bindings
#  --enable-php            enable PHP bindings
#  --enable-python         enable Python bindings
#  --enable-ruby           enable Ruby bindings
#  --enable-vala           enable Vala bindings

	local myconf
	if ! use imagemagick ; then
		myconf="--disable-dmtxquery --disable-dmtxread --disable-dmtxwrite"
	fi
	econf ${myconf}
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}
