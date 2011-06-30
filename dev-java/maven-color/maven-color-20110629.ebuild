# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="3"

DESCRIPTION="Colorize Maven output"
HOMEPAGE="http://repo.or.cz/w/anomen-overlay.git/tree/HEAD:/dev-java/maven-color"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-java/maven-bin:2.2
	app-misc/realpath"

src_unpack() {
	cd "${WORKDIR}"
	cp "${FILESDIR}/cmvn-${PV}" cmvn
}



src_install() {
	dobin "cmvn"
}

