# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/dominions2-demo/dominions2-demo-2.08.ebuild,v 1.2 2006/12/06 20:33:26 wolf31o2 Exp $

inherit games

DESCRIPTION="Eschalon Book I is an turn-based fantasy RPG game"
HOMEPAGE="http://www.basiliskgames.com/book1.htm"
SRC_URI="eschalon_book_1_demo.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
RESTRICT="fetch strip"

RDEPEND="virtual/glu
	virtual/opengl
        x86? ( 
	    x11-libs/libX11 
	    x11-libs/libXext 
	    x11-libs/libXau 
	    x11-libs/libXdmcp 
	    x11-libs/libXxf86vm 
	)
        amd64? ( app-emulation/emul-linux-x86-xlibs ) "

S="${WORKDIR}/eschalon_book_1_demo"
dir="${GAMES_PREFIX_OPT}/${PN}"
Ddir="${D}/${dir}"

pkg_nofetch() {
        einfo "Please download ${At} from:"
        einfo ${HOMEPAGE}
}

src_install() {
	dodir "${dir}"
	insinto "${dir}"
	exeinto "${dir}" 

	dohtml "help.html"
	dodoc "license.txt"
	mv -f "Eschalon Players Manual.pdf" "${D}/usr/share/doc/${PF}/"	
	
	doins -r data music sound gfx.pak eschalon.cfg || die "cp failed"
	doexe eschalon_book_1_demo

	fperms 660 "${dir}"/eschalon.cfg

	games_make_wrapper ${PN} ./eschalon_book_1_demo "${dir}" "${dir}"

        newicon launch_icon.png ${PN}.png || die

	make_desktop_entry ${PN} "Eschalon Book I (Demo)" ${PN}.png
	
	prepgamesdirs
}

