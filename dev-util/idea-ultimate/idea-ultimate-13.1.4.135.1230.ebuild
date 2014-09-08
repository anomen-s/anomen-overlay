# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

SLOT="$(get_major_version)"
RDEPEND=">=virtual/jdk-1.6"

MY_PN="idea"
MY_PV="$(get_version_component_range 4-5)"

RESTRICT="strip"
QA_TEXTRELS="opt/${P}/bin/libbreakgen.so"

DESCRIPTION="IntelliJ IDEA is an intelligent Java IDE (Ultimate Edition)"
HOMEPAGE="http://jetbrains.com/idea/"
SRC_URI="http://download.jetbrains.com/idea/ideaIU-$(get_version_component_range 1-3)b.tar.gz"
LICENSE="IntelliJ-IDEA"
IUSE=""
KEYWORDS="~x86 ~amd64"
S="${WORKDIR}/${MY_PN}-IU-${MY_PV}"

src_install() {
	local dir="/opt/${P}"
	local exe="${PN}-${SLOT}"

	insinto "${dir}" || die
	doins -r * || die
	fperms 755 "${dir}/bin/${MY_PN}.sh" "${dir}/bin/inspect.sh" "${dir}/bin/fsnotifier" "${dir}/bin/fsnotifier64" || die

	newicon "bin/${MY_PN}.png" "${exe}.png" || die
	make_wrapper "idea-iu-${SLOT}" "/opt/${P}/bin/${MY_PN}.sh" || die
	make_desktop_entry ${exe} "IntelliJ IDEA $(get_version_component_range 1-3) (Ultimate Edition)" "${exe}" "Development;IDE" || die
}
