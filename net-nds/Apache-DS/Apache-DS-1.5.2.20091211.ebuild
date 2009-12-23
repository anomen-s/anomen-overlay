# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PV=$(replace_version_separator 3 '.v')


DESCRIPTION="Apache Directory Studio is an universal LDAP directory tool."
SRC_URI="amd64? (
		mirror://apache/directory/studio/stable/${MY_PV}/ApacheDirectoryStudio-linux-x86_64-${MY_PV}.tar.gz
	)
	x86? (
		mirror://apache/directory/studio/stable/${MY_PV}/ApacheDirectoryStudio-linux-x86-${MY_PV}.tar.gz
	)"
HOMEPAGE="http://directory.apache.org/studio/"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="Apache-2.0"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.5.0
	x11-libs/gtk+:2
	dev-libs/glib:2
	x11-libs/pango
	x11-libs/cairo
	x11-libs/libX11"


if use x86 ; then
	ASD_ARCH=x86
elif use amd64 ; then
	ASD_ARCH=x86_64
fi
INSTALL_DIR=/opt/ApacheDirectoryStudio
S="${WORKDIR}/ApacheDirectoryStudio-linux-${ASD_ARCH}-${MY_PV}"

src_install() {

	insinto ${INSTALL_DIR}
	
	doicon ApacheDirectoryStudio.xpm
	
	make_desktop_entry "${INSTALL_DIR}/ApacheDirectoryStudio" "Apache Directory Studio" ApacheDirectoryStudio.xpm "System"
	
	
	doins -r *
	
	fperms +x ${INSTALL_DIR}/ApacheDirectoryStudio
}
