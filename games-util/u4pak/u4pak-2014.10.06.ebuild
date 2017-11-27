# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="6"

DESCRIPTION="Tool for [un]packing Unreal Engine 4 .pak archives"
HOMEPAGE="https://github.com/panzi/u4pak"
SRC_URI="https://raw.githubusercontent.com/panzi/u4pak/66ab16e/u4pak.py -> 66ab16e-u4pak.py"

RESTRICT="mirror"
LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="-fuse"

DEPEND="fuse? ( dev-python/llfuse )"
RDEPEND=""

S="${WORKDIR}"

src_unpack() {
	cd "${DISTDIR}"
	cp *-u4pak.py "$S/u4pak"
}

src_install() {
	dobin u4pak
}
