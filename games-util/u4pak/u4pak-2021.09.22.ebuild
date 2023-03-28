# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="7"

COMMIT=d4f447f

DESCRIPTION="Tool for [un]packing Unreal Engine 4 .pak archives"
HOMEPAGE="https://github.com/panzi/u4pak"
SRC_URI="https://raw.githubusercontent.com/panzi/u4pak/${COMMIT}/u4pak.py -> ${COMMIT}-u4pak.py
	https://raw.githubusercontent.com/panzi/u4pak/${COMMIT}/README.md -> ${COMMIT}-README.md"

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
	cp ${COMMIT}-u4pak.py "$S/u4pak"
	cp ${COMMIT}-README.md "$S/README.md"
}

src_install() {
	dobin u4pak
	dodoc README.md
}
