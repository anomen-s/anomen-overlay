# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit git qt4

EGIT_REPO_URI="git://git.dolezel.info/${PN}.git"
DESCRIPTION="GUI Wake-on-LAN manager"
HOMEPAGE="http://www.dolezel.info/projects/wolman"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="	x11-libs/qt-gui:4
		net-libs/libnet
		net-libs/libpcap"
RDEPEND="${DEPEND}
		sys-apps/iproute2"

S="${WORKDIR}/${PN}"

src_unpack() {
	git_src_unpack
}

src_compile() {
	eqmake4
	emake || die "make failed"
}

src_install() {
	dosbin wolman || die "dosbin failed"
        newicon gfx/green.png ${PN}.png
        make_desktop_entry ${PN} "Wake-on-LAN manager" ${PN} "Network;RemoteAccess;Qt" /usr/sbin
}
