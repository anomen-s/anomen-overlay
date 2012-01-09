# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils versionator

MY_PV=$(replace_version_separator 3 '.v')


DESCRIPTION="Apache Directory Studio is an universal LDAP directory tool."
SRC_URI="amd64? (
		mirror://apache/directory/studio/stable/${MY_PV}/${PN}-linux-x86_64-${MY_PV}.tar.gz
	)
	x86? (
		mirror://apache/directory/studio/stable/${MY_PV}/${PN}-linux-x86-${MY_PV}.tar.gz
	)"
HOMEPAGE="http://directory.apache.org/studio/"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="Apache-2.0"
IUSE=""

DEPEND="!net-nds/Apache-DS" # obsolete ebuild name
RDEPEND=">=virtual/jre-1.5.0
	x11-libs/gtk+:2"

if use x86 ; then
	MY_ARCH=x86
elif use amd64 ; then
	MY_ARCH=x86_64
fi
INSTALL_DIR="/opt/${PN}"
S="${WORKDIR}/${PN}-linux-${MY_ARCH}-${MY_PV}"

src_install() {

	insinto "${INSTALL_DIR}"
	
	doicon "${PN}.xpm"
	
	make_desktop_entry "${INSTALL_DIR}/${PN}" "Apache Directory Studio" "${PN}" "Internet"
		
	doins -r *
	
	fperms +x "${INSTALL_DIR}/${PN}"
	
	dosym "${INSTALL_DIR}/${PN}" "/opt/bin/${PN}"
}
