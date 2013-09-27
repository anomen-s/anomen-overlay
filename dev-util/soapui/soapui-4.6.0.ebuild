# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit eutils versionator

DESCRIPTION="SoapUI webservice testing tool"
HOMEPAGE="http://www.soapui.org/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/$PV/${P}-linux-bin.tar.gz"
LICENSE="soapui"
SLOT="0"
IUSE=""
KEYWORDS="~x86 ~amd64"

RDEPEND=">=virtual/jdk-1.6"

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	for exe in loadtestrunner.sh  mockservicerunner.sh  securitytestrunner.sh  soapui.sh  testrunner.sh  toolrunner.sh  wargenerator.sh
	do
		fperms 755 "${dir}/bin/${exe}"
	done

	newicon "bin/soapui32.png" "${PN}.png"
	make_wrapper "${PN}" "/opt/${P}/bin/${PN}.sh"
	make_desktop_entry ${PN} "SoapUI" "${PN}" "Development;IDE"
}
