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

DEPEND="app-arch/bzip2"
RDEPEND=""

S="${WORKDIR}/MediaInfo_CLI_GNU_FromSource"

src_compile() {
	./CLI_Compile.sh
}

src_install() {
	cd ${S}
	dobin MediaInfo/Project/GNU/CLI/mediainfo
        dodoc MediaInfo/History_CLI.txt MediaInfo/Release/ReadMe_CLI_Linux.txt MediaInfo/Contrib/CLI_Help.doc MediaInfoLib/History_DLL.txt
}
