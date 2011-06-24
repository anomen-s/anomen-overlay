# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/cracklib-words/cracklib-words-20080507.ebuild,v 1.8 2010/05/21 02:00:44 vapier Exp $
EAPI="3"

DESCRIPTION="Colorize Maven output"
HOMEPAGE="http://repo.or.cz/w/anomen-overlay.git/tree/HEAD:/dev-java/maven-color"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="dev-java/maven-bin"


src_install() {
	dobin "${FILESDIR}/cmvn"
}

