# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils versionator java-pkg-2

SLOT="0"
RDEPEND=">=virtual/jdk-1.7"

DESCRIPTION="JD-GUI is a standalone graphical utility that displays Java source codes of \".class\" files"
HOMEPAGE="https://github.com/java-decompiler/jd-gui"
SRC_URI="https://github.com/java-decompiler/jd-gui/releases/download/v${PV}/jd-gui-${PV}.jar"
IUSE=""
KEYWORDS="~x86 ~amd64"
S="${WORKDIR}"

src_unpack() {
    default
    cp -L ${DISTDIR}/${A} ${S}/${PN}.jar || die
}

src_compile() {
    true
}

src_install() {

    java-pkg_dojar "${S}/${PN}.jar"
    java-pkg_dolauncher "${PN}" --main org.jd.gui.App

    newicon "${S}/org/jd/gui/images/jd_icon_128.png" "${PN}.png"
    make_desktop_entry "${PN}" "JD-GUI" "${PN}" "Development"
}
