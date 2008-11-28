# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: pornotube-dl-2007.10.09.ebuild 16 2008-02-05 00:48:42Z ludek $

MY_P="${P/mediainfo-bin-/MediaInfo_}"
MY_A="$(use x86 && echo 'i386' || echo 'x64')"

DESCRIPTION="A command-line program to display informations about media files."
HOMEPAGE="http://mediainfo.sourceforge.net"
SRC_URI="
	amd64? ( mirror://sourceforge/${PN}/${MY_P}_CLI_Linux_x64.tar.bz2 )
	x86? ( mirror://sourceforge/${PN}/${MY_P}_CLI_Linux_i386.tar.bz2 )
"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!media-video/mediainfo"
RDEPEND=""

S="${WORKDIR}/MediaInfo_CLI_Linux_${MY_A}"

src_install() {
	cd ${S}
	dobin mediainfo
        dodoc Contrib/* *.html *.txt
}
