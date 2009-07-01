# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tuxonice-userui/tuxonice-userui-0.7.3.ebuild,v 1.3 2009/02/22 20:46:03 nelchael Exp $

EAPI="2"

inherit mount-boot eutils

DESCRIPTION="Installs copy of TuxOnIce UI into the /boot partition"
HOMEPAGE="http://www.tuxonice.net"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="binchecks strip"

IUSE="fbsplash"
DEPEND="=sys-apps/tuxonice-userui-${PV}[fbsplash=]"
RDEPEND="${DEPEND}"

src_unpack() {
	mkdir -p "${S}"
	cp -p "${ROOT}/sbin/tuxoniceui_text" "$S"
	
	if use fbsplash; then
	    cp -p "${ROOT}/sbin/tuxoniceui_fbsplash" "$S"
	    cp -p "${ROOT}/etc/splash/tuxonice" "$S"
	fi
}

src_compile() {
	:
}

src_install() {
	into /boot
	dosbin tuxoniceui_text

	if use fbsplash; then
	    into /boot
	    dosbin tuxoniceui_fbsplash
	    into /boot/etc/splash
		doins tuxonice
	fi
}

