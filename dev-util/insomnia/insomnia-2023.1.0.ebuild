# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils pax-utils xdg-utils

MY_PN="Insomnia.Core"

DESCRIPTION="The most intuitive cross-platform REST API Client"
HOMEPAGE="https://insomnia.rest/"
SRC_URI="https://github.com/Kong/insomnia/releases/download/core%40${PV}/${MY_PN}-${PV}.deb"

LICENSE="MIT"
RESTRICT="mirror"

SLOT="0"
KEYWORDS="~amd64 -*"
IUSE=""

DEPEND=""
RDEPEND="
	x11-libs/libnotify
	dev-libs/libappindicator
	x11-libs/libXtst
	dev-libs/nss
"

S="${WORKDIR}"

src_unpack() {
	ar x "${DISTDIR}/${A}" || die
	unpack "${WORKDIR}/data.tar.xz"
}


src_install() {
	unpack usr/share/doc/insomnia/*.gz
	dodoc changelog

	insinto /usr/share
	doins -r usr/share/icons
	doins -r usr/share/applications

	cp -a opt "${D}" || die
	pax-mark rm "${ED}/opt/Insomnia/insomnia"
	make_wrapper "${PN}" "/opt/Insomnia/insomnia"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
