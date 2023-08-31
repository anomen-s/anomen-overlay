# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="ASN.1 to C compiler"
HOMEPAGE="http://asn1c.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install(){
	emake DESTDIR="${ED}" install || die "make install failed"
	mv "$D/usr/share/doc/asn1c" "$D/usr/share/doc/${PF}"
}
