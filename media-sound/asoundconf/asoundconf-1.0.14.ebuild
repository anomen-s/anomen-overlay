# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

#inherit eutils multilib rpm

DESCRIPTION="Asoundconf is a python script to change your default sound card"
HOMEPAGE="https://code.launchpad.net/asoundconf-ui"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/a/alsa-utils/alsa-utils_${PV}-1ubuntu4_i386.deb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="virtual/python
	>=media-sound/alsa-utils-1.0.14"
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
	doexe "${S}"/usr/bin/asoundconf
	doman "${S}"/usr/share/man/man1/asoundconf.1.gz
}
