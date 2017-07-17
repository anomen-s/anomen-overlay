# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author: lucianoshl
EAPI="4"

inherit eutils java-utils-2

DESCRIPTION="SQuirreL SQL Client"
HOMEPAGE="http://squirrel-sql.sourceforge.net"
SRC_URI="mirror://sourceforge/project/${PN}/1-stable/${PV}-plainzip/squirrelsql-${PV}-optional.zip -> ${PN}.zip"
IUSE=""

SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="LGPL-2.1"

RDEPEND="virtual/jre"

DEPEND="${RDEPEND}"

S="${WORKDIR}/squirrelsql-${PV}-optional"
INSTALL_DIR="/opt/${PN}/${PVR}"


src_install() {

	mv squirrel-sql.sh squirrel-sql
	epatch "${FILESDIR}"/${PV}-change-home.patch
	insinto ${INSTALL_DIR}
	doins -r *
	
	fperms +x ${INSTALL_DIR}/squirrel-sql

	dosym ${INSTALL_DIR}/squirrel-sql /opt/bin/${PN}

	newicon icons/acorn.png ${PN}.png
	make_desktop_entry /opt/bin/${PN} "SQuirrel SQL Client" ${PN}.png "Development;Database" ${INSTALL_DIR}
}
