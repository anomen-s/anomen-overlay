# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A command-line program to display informations about media files."
HOMEPAGE="http://mediainfo.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/MediaInfo_CLI_${PV}_GNU_FromSource.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/MediaInfo_CLI_GNU_FromSource"

src_compile() {
	cd "${S}/ZenLib/Project/GNU/Library"
	econf || die "econf failed!"
	emake || die "emake failed!"
	
	cd "${S}/MediaInfoLib/Project/GNU/Library"
	econf || die "econf failed!"
	emake || die "emake failed!"
	
	cd "${S}/MediaInfo/Project/GNU/CLI"
	econf --enable-staticlibs || die "econf failed!"
	emake || die "emake failed!"
}

src_install() {
	cd ${S}
	dobin MediaInfo/Project/GNU/CLI/mediainfo

    dodoc \
		MediaInfo/*.txt \
		MediaInfo/*.html \
		MediaInfo/Release/*.txt \
		MediaInfo/Contrib/CLI_Help.doc
	
	docinto MediaInfoLib
	dodoc MediaInfoLib/*.txt MediaInfoLib/*.html MediaInfoLib/Release/*.txt
	
	docinto ZenLib
    dodoc ZenLib/*.txt
	
}
