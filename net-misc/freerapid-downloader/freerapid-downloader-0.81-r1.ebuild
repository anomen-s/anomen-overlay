# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2

FRD_ZIP_FILE="Freerapid-Downloader_${PV}.zip"
FRD_P_ZIP_FILE="rapidshare_premium.frp"
FRD_INSTALL_DIR="/opt/FreeRapid"

DESCRIPTION="Downloader with support for downloading from Rapidshare and other share file archives."
SRC_URI="http://download.sosej.cz/programy4/${FRD_ZIP_FILE}
         premium? ( http://wordrider.net/download/${FRD_P_ZIP_FILE} )"
HOMEPAGE="http://wordrider.net/freerapid"
RESTRICT="mirror"

KEYWORDS="-amd64 -x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="premium"

DEPEND="app-arch/unzip
	>=dev-java/commons-codec-1.3
	>=dev-java/commons-logging-1.1
	>=dev-java/l2fprod-common-7.3
	"
RDEPEND=">=virtual/jre-1.6.0"

S="${WORKDIR}/FreeRapid-${PV}"

src_unpack() {
        unpack $FRD_ZIP_FILE || die

        cd ${S}
        if use premium; then
		rm -f plugins/rapidshare*.frp 
		cp "${DISTDIR}/${FRD_P_ZIP_FILE}" plugins/
    	fi
	
        sed -i -e "s!frd.jar!${FRD_INSTALL_DIR}/frd.jar!" frd.sh

	cd ./lib
	for j in commons-logging commons-codec l2fprod-common ; do
	    rm -v ${j}*.jar || die
	    java-pkg_jar-from ${j}
	done
#	die
}

src_install() {

	insinto ${FRD_INSTALL_DIR}
	doins -r lib lookandfeel plugins frd.jar frd.sh frd.png *.properties

	chmod +x ${D}/${FRD_INSTALL_DIR}/frd.sh

	# TODO create launches (see jxplorer)
        dosym "${FRD_INSTALL_DIR}/frd.sh" /opt/bin/frd

	dodoc License copyright *.txt
}
