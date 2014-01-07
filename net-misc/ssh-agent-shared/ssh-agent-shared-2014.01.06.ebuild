# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="4"

DESCRIPTION="Anomen's wrapper for ssh-agent"
HOMEPAGE="http://repo.or.cz/w/anomen-overlay.git/tree/HEAD:/net-misc/ssh-agent-shared"
SRC_URI=""

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="
	net-misc/openssh
	>=dev-lang/python-2.6"

src_unpack() {
	mkdir "${WORKDIR}/${P}"
	cd "${WORKDIR}/${P}"
	mkdir bin
	cp -t bin "${FILESDIR}"/ssh-agent-shared

}

src_install() {
	into /usr
	dobin bin/*
}

