# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="3"

DESCRIPTION="Anomen's set of scripts for managing Wine prefixes"
HOMEPAGE="http://repo.or.cz/w/anomen-overlay.git/tree/HEAD:/app-emulation/wine-cellar"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="app-emulation/wine"

src_unpack() {
	cp -t "${WORKDIR}"  "${FILESDIR}"/*

}

INSTALL_DIR=/usr/share/wine/cellar

src_install() {
	insinto "$INSTALL_DIR"
	doins *
	fperms 0755 "$INSTALL_DIR/create.sh"
}
