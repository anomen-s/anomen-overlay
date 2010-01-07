# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author: anomen



inherit eutils java-utils-2


DESCRIPTION="SQuirreL SQL Client"
HOMEPAGE="http://squirrel-sql.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/files/1-stable/${P}-optional.zip"
IUSE=""

SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="LGPL-2.1"

RDEPEND="virtual/jre"

DEPEND="${RDEPEND}"

S="${WORKDIR}/SQuirreL SQL Client"
INSTALL_DIR="/opt/SQuirreL"


src_install() {

	insinto ${INSTALL_DIR}

	doins -r *

#	fperms +x ${INSTALLDIR}/dbvis

#	dosym ${INSTALLDIR}/dbvis /opt/bin/${PN}

	newicon icons/acorn.png ${PN}.png
	make_desktop_entry ${PN} "SQuirrel SQL Client" ${PN}.png "Development;Database" 
}

