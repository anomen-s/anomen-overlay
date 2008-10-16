# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

DESCRIPTION="Asoundconf is a python script to change your default sound card"
HOMEPAGE="https://code.launchpad.net/asoundconf-ui"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/universe/a/${PN}/${PN}_${PV}-0ubuntu2_all.deb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-python/pygtk
	media-sound/asoundconf"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	ar x "${DISTDIR}"/${A} || die "Unpack failed"
	rm ${S}/control.tar.gz
	rm ${S}/debian-binary
	tar xf ${S}/data.tar.gz || die "Unpack failed"
	rm ${S}/data.tar.gz
}

src_install() {
	exeinto /usr/bin
	doexe "${S}"/usr/bin/asoundconf-gtk
	dodoc  "${S}"/usr/share/doc/asoundconf-gtk/{README,copyright}
	doman "${S}"/usr/share/man/man8/asoundconf-gtk.8.gz
	insinto /usr/share/applications
	doins "${S}"/usr/share/applications/asoundconf-gtk.desktop
}
