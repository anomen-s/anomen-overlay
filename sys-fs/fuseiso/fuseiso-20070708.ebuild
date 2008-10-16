# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/sshfs-fuse/sshfs-fuse-1.4.ebuild,v 1.1 2006/01/16 15:23:49 genstef Exp $

DESCRIPTION="FUSE module to mount ISO9660 images"
SRC_URI="http://switch.dl.sourceforge.net/sourceforge/fuseiso/${P}.tar.bz2"
HOMEPAGE="http://fuse.sourceforge.net/wiki/index.php/FuseIso"
LICENSE="GPL"
SLOT="0"
DEPEND=">=sys-fs/fuse-2.2.1
	>=dev-libs/glib-2.4.2"
KEYWORDS="~x86 ~amd64"
IUSE=""

src_install () {
	make DESTDIR=${D} install || die "make install failed"
	dodoc README NEWS ChangeLog AUTHORS
}

