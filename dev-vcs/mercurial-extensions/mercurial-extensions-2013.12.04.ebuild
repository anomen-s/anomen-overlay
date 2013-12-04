# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="4"

DESCRIPTION="Various Mercurial extensions"
HOMEPAGE="http://mercurial.selenic.com/"
SRC_URI="
  https://bitbucket.org/Mekk/mercurial_keyring/raw/fb4371a55e795782738fec1f85b5635e59ad8f44/mercurial_keyring.py
  https://bitbucket.org/gobell/hg-zipdoc/raw/a2ca45ccfd648e714ae6f1f4ad437260aa161496/zipdoc.py"

LICENSE="GPL-2+ as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="dev-vcs/mercurial"

src_unpack() {
	mkdir "${WORKDIR}/${P}"
	cp "${DISTDIR}"/*.py "${WORKDIR}/${P}"
}

src_install() {
	local dir=/usr/libexec/hgext
	insinto "${dir}"
	doins  *.py
}
