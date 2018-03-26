# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"
inherit eutils

DESCRIPTION="SoapUI is a free and open source cross-platform Functional Testing solution."
HOMEPAGE="http://www.soapui.org/"
LICENSE="EUPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://s3.amazonaws.com/downloads.eviware/soapuios/${PV}/SoapUI-${PV}-linux-bin.tar.gz"
RESTRICT="strip mirror"
DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.6"

INSTALLDIR="/opt/SoapUI"
S="${WORKDIR}/SoapUI-${PV}"
DOCS="README.md LICENSE.txt RELEASENOTES.txt"

PNGFILE=SoapUI-OS-5.2_48-48.png

src_prepare() {
	# fix logging
	sed -i -e 's!${soapui.logroot}!/tmp/${user.name}-!' "bin/soapui-log4j.xml"
	
	unzip -j -d "$WORKDIR" "bin/soapui-$PV.jar" com/eviware/soapui/resources/images/$PNGFILE
	rm bin/*.log
	
	eapply_user

}

src_install() {
	# application
	insinto ${INSTALLDIR}
	doins -r *

	# executables
	chmod 755 ${D}/${INSTALLDIR}/bin/*.sh

	#einstalldocs

	newicon "$WORKDIR/$PNGFILE" "${PN}.png"
	make_wrapper "${PN}" "${INSTALLDIR}/bin/soapui.sh"
	make_desktop_entry ${PN} "SoapUI ${PV}" "${PN}" "Development;IDE"
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		einfo "Application executable installed in ${INSTALLDIR}/bin/soapui.sh"
	fi
}
