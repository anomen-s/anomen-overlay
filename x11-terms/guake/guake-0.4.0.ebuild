# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="Guake is a drop-down terminal for Gnome"
HOMEPAGE="http://guake-terminal.org/"
SRC_URI="http://trac.guake-terminal.org/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	dev-python/gnome-python
	dev-python/notify-python
	x11-libs/vte"

src_compile() {
	if !built_with_use x11-libs/vte python ; then
                eerror "This package requires x11-libs/vte with compiled with python support."
                die "Please reemerge x11-libs/vte with USE=\"python\"."
        fi
	econf || die "configuration failed"
	emake || die "make failed"
}

src_install() {
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"
	emake DESTDIR="${D}" install || die "installation failed"
	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
	
}

pkg_preinst() {
	gnome2_gconf_savelist
}

