# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# TODO: jdbc symlinks

EAPI="7"

IUSE=""

inherit java-utils-2 desktop xdg-utils

MY_PV=$(ver_rs 1- _)
At=dbvis_linux_${MY_PV}.tar.gz

DESCRIPTION="DB Visualizer (Free Version)"
HOMEPAGE="http://www.dbvis.com/"
SRC_URI="http://www.dbvis.com/product_download/${P}/media/${At}"

SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="Apache-1.1"
RESTRICT="mirror"

RDEPEND="virtual/jre
	dev-java/java-config"
DEPEND="${RDEPEND}"

S="${WORKDIR}/DbVisualizer"
INSTALLDIR="/opt/DbVisualizer-${PV}"

src_unpack() {
	unpack ${A}

	cd ${S}

	sed -e "3i cd ${INSTALLDIR}" \
	    -e '5i INSTALL4J_JAVA_HOME_OVERRIDE=`java-config -o`' -i dbvis || die patch failed
}

src_install() {

	insinto ${INSTALLDIR}

	doins -r .install4j *

	fperms +x ${INSTALLDIR}/dbvis ${INSTALLDIR}/dbviscmd.sh ${INSTALLDIR}/dbvisgui.sh

	dosym ${INSTALLDIR}/dbvis /opt/bin/${PN}

	newicon --size 48 .install4j/i4j_extf_10_1bd0g0g_1alkt4u.png ${PN}.png
	newicon --size 96 .install4j/i4j_extf_10_1bd0g0g_1alkt4u@2x.png ${PN}.png
	newicon --size 128 .install4j/i4j_extf_9_1bd0g0g_1c0oll4.png ${PN}.png
	newicon --size 256 .install4j/i4j_extf_9_1bd0g0g_1c0oll4@2x.png ${PN}.png

	make_desktop_entry ${PN} "DbVisualizer ${PV}" ${PN} "Development;Database" 
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
