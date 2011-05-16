# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_PVL=$(replace_version_separator 2 'u')
MY_PVU=$(replace_version_separator 2 'U')
FRD_ZIP_FILE="FreeRapid-${MY_PVL}-b566.zip"
FRD_INSTALL_DIR="/opt/FreeRapid"

DESCRIPTION="Downloader with support for downloading from Rapidshare and other share file archives."
SRC_URI="${FRD_ZIP_FILE}"
HOMEPAGE="http://wordrider.net/freerapid"
RESTRICT="mirror fetch"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.6.0"

S="${WORKDIR}/FreeRapid-0.85u1-build566"

src_unpack() {
        unpack $FRD_ZIP_FILE || die

        cd ${S}

	#remove Windows stuff
	rm -rf tools/gocr tools/nircmd

        sed -i -e "s!frd.jar!${FRD_INSTALL_DIR}/frd.jar!" frd.sh
}

src_install() {

	insinto ${FRD_INSTALL_DIR}
	doins -r doc lib lookandfeel plugins tools search frd.jar frd.sh frd.png *.properties License copyright

	chmod +x ${D}/${FRD_INSTALL_DIR}/frd.sh

        dosym "${FRD_INSTALL_DIR}/frd.sh" /opt/bin/frd

	#dodoc License copyright doc/*.txt
}
