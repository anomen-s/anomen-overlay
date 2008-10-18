# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

FRD_ZIP_FILE="FreeRapid-${PV}.zip"
FRD_INSTALL_DIR="/opt/FreeRapid"

DESCRIPTION="Downloader with support for downloading from Rapidshare and other share file archives."
SRC_URI="http://wordrider.net/download/${FRD_ZIP_FILE}
         premium? ( http://wordrider.net/download/rapidshare_premium-0.99.frp )"
HOMEPAGE="http://wordrider.net/freerapid"
RESTRICT="mirror"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="premium"

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jdk-1.6.0"

S="${WORKDIR}/FreeRapid-${PV}"

src_unpack() {
        unpack $FRD_ZIP_FILE || die

        cd ${S}
        if use premium; then
		rm -f plugins/rapidshare-*.frp 
		cp "${DISTDIR}"/rapidshare_premium-*.frp plugins
    	fi
	
        sed -i -e "s!frd.jar!${FRD_INSTALL_DIR}/frd.jar!" frd.sh
}

src_install() {

	insinto ${FRD_INSTALL_DIR}
	doins -r lib lookandfeel plugins frd.jar frd.sh frd.png

	chmod +x ${D}/${FRD_INSTALL_DIR}/frd.sh

        dosym "${FRD_INSTALL_DIR}/frd.sh" /opt/bin/frd

	dodoc License copyright *.txt
}
