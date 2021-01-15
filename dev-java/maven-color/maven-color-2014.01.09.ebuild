# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="4"

DESCRIPTION="Colorize Maven output"
HOMEPAGE="https://github.com/anomen-s/anomen-overlay/tree/master/dev-java/maven-color"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-java/maven-bin:2.2
	sys-libs/ncurses
	|| ( >=sys-apps/coreutils-8.15 app-misc/realpath )"

S="${WORKDIR}"

src_unpack() {
	cd "${WORKDIR}"
	cp "${FILESDIR}/cmvn-${PV}" cmvn
}

src_install() {
	dobin "cmvn"
}
