# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Author: lucianoshl
EAPI="4"

inherit eutils java-utils-2

DESCRIPTION="SQuirreL SQL Client"
HOMEPAGE="http://squirrel-sql.sourceforge.net"
SRC_URI="mirror://sourceforge/project/${PN}/1-stable/${PV}-plainzip/squirrelsql-${PV}-optional.zip"
IUSE=""
RESTRICT="mirror"

SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="LGPL-2.1"

RDEPEND="virtual/jre"

DEPEND="${RDEPEND}"

S="${WORKDIR}/squirrelsql-${PV}-optional"
INSTALL_DIR="/opt/${P}"


src_install() {

	rm *.bat
	
        sed -e "s@SQUIRREL_SQL_HOME=.*@SQUIRREL_SQL_HOME=${INSTALL_DIR}@" -i squirrel-sql.sh
	
	insinto ${INSTALL_DIR}
	doins -r *
	
	fperms +x ${INSTALL_DIR}/${PN}.sh

	dosym ${INSTALL_DIR}/${PN}.sh /opt/bin/${PN}

	newicon icons/acorn.png ${PN}.png
	make_desktop_entry /opt/bin/${PN} "SQuirrel SQL Client ${PV}" ${PN} "Development;Database"
}
