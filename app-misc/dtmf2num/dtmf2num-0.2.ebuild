# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

DESCRIPTION="Tool for decoding the DTMF and MF tones from PCM wave files."
HOMEPAGE="http://aluigi.org/mytoolz.htm"
SRC_URI="http://aluigi.org/mytoolz/${PN}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

src_prepare() {
    default
    sed -i -e '/^CFLAGS/d' Makefile
}

src_install() {
	dobin "${PN}"
}
