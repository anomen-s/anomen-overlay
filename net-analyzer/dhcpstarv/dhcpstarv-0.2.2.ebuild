# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils versionator

DESCRIPTION="Utility for DHCP starvation attacks"
MY_PV=$(get_version_component_range '1-2')
SRC_URI="mirror://sourceforge/${PN}/${MY_PV}/${P}.tar.gz"
HOMEPAGE="http://dhcpstarv.sourceforge.net/"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
"
DEPEND="
	${RDEPEND}
"

src_prepare(){
	eautoreconf
}
