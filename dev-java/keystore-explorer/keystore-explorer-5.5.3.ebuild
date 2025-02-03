# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

inherit desktop

MY_PV=$(ver_rs 1- '')

DESCRIPTION="Keystore management tool."
SRC_URI="https://github.com/kaikramer/${PN}/releases/download/v${PV}/kse-${MY_PV}.zip"
HOMEPAGE="https://keystore-explorer.org/"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="dev-java/java-config
    || ( virtual/jre virtual/jre )"

S="${WORKDIR}/kse-${MY_PV}"

src_unpack() {
    unpack ${A}
    rm -v "$S/kse.exe" || die
}
src_install() {
	local dir="/opt/${PN}"
	local exe="kse"

	dosym ${dir}/kse.sh /opt/bin/kse

	insinto "${dir}" || die
	doins -r * || die
	fperms 755 "${dir}/kse.sh" || die

	newicon "icons/kse_128.png" "${exe}.png" || die
	make_desktop_entry "${exe}" "Keystore Explorer" "${exe}" "Development" || die
}
