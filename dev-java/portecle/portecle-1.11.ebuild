# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

inherit eutils desktop java-pkg-2 xdg-utils

DESCRIPTION="Keystore management tool."
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"
HOMEPAGE="http://portecle.sourceforge.net/"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="|| ( >=virtual/jre-1.8 >=virtual/jdk-1.8 )"

src_compile() {
	:
}

src_install() {

	java-pkg_dojar *.jar
	java-pkg_dolauncher "${PN}" --main net.sf.portecle.FPortecle

	dodoc *.txt

	local size
	for size in 16 32 64 128 ; do
	    doicon --size "${size}" icons/${size}x${size}/${PN}.png
	done

	domenu "net.sf.portecle.desktop"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
