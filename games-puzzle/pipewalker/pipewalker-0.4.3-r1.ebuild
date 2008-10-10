# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit games

DESCRIPTION="PipeWalker - is a clone of the NetWalk game."
HOMEPAGE="http://pipewalker.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="X glut"

DEPEND="glut? ( media-libs/freeglut )"
RDEPEND="${DEPEND}"

src_compile() {
	sed -i -e 's!/games/!/!' src/Makefile.in 		
	sed -i -e 's!/games/!/!' textures/Makefile.in 		

	egamesconf \
		--disable-dependency-tracking \
		--datadir=${GAMES_DATADIR} \
		$(use_with X) \
		$(use_with glut)

	emake || die "emake failed"
}

src_install() {

	dogamesbin src/${PN} || die "dogamesbin failed"
	dodoc README

	insinto "${GAMES_DATADIR}/${PN}/textures"
	doins -r textures/*.tga || die "Installing data files failed"  

	doicon extra/PipeWalker.xpm
	domenu extra/pipewalker.desktop

	prepgamesdirs
}
