# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

DESCRIPTION="SMBNetFS is a Linux/FreeBSD filesystem that allow you to use samba/microsoft network in the same manner as the network neighborhood in Microsoft Windows."
HOMEPAGE="http://sourceforge.net/projects/smbnetfs"
SRC_URI="mirror://sourceforge/smbnetfs/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=sys-fs/fuse-2.3
	|| ( >=net-fs/samba-libs-3.2[smbclient] >=net-fs/samba-3.0  )"

DEPEND="${RDEPEND}
	virtual/libc
	sys-devel/make"

src_install() {
	make install DESTDIR=${D} || die "make install failed"
	dodoc COPYING AUTHORS ChangeLog README INSTALL RUSSIAN.FAQ
}

pkg_postinst() {
	einfo ""
	einfo "For quick usage, exec:"
	einfo "'modprobe fuse'"
	einfo "'smbnetfs -oallow_other /mnt/samba'"
	einfo ""
}
