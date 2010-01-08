# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author: anomen

# TODO: java launcher

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

	rm *.bat *.sh

	insinto ${INSTALL_DIR}

	doins -r *
	
	
	doins ${FILESDIR}/squirrel-sql
	fperms +x ${INSTALL_DIR}/squirrel-sql

	dosym ${INSTALL_DIR}/squirrel-sql /opt/bin/${PN}

	newicon icons/acorn.png ${PN}.png
	make_desktop_entry /opt/bin/${PN} "SQuirrel SQL Client" ${PN}.png "Development;Database" ${INSTALL_DIR}
}
