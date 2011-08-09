# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="3"

DESCRIPTION="Compare jar files"
HOMEPAGE="http://muzso.hu/2010/11/20/jardiff-create-a-diff-of-the-public-api-of-two-jar-files"
SRC_URI="http://muzso.hu/dfiles/public/jardiff-1.1.0.sh"

LICENSE="CCPL-Attribution-ShareAlike-NonCommercial-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""

RDEPEND="app-arch/unzip
	virtual/jdk"


src_unpack() {
	cp "$DISTDIR/$A" jardiff
	sed -i -e '2iTMPDIR=${TMPDIR:-/tmp}' jardiff
}

src_install() {
	dobin "jardiff"
}

