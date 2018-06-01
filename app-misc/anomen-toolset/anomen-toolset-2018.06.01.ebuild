# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="4"

DESCRIPTION="Anomen's collection of simple shell scripts"
HOMEPAGE="https://github.com/anomen-s/anomen-overlay/tree/master/app-misc/anomen-toolset"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+xml +jad +mediainfo +xdg +sudo"

DEPEND=""
RDEPEND="
	xml? ( dev-libs/libxml2 )
	jad? ( dev-java/jad-bin )
	mediainfo? ( media-video/mediainfo )
	xdg? ( x11-misc/xdg-utils )
	virtual/libiconv
	sudo? ( app-admin/sudo dev-libs/openssl app-misc/screen  )
	"

src_unpack() {
	mkdir "${WORKDIR}/${P}"
	cd "${WORKDIR}/${P}"
	mkdir bin sbin lib

	cp -t bin "${FILESDIR}"/{bom,chmod.std,decwin,psm,treecmp,treeprune,flatten,unzipd,shit}
	cp -t lib "${FILESDIR}"/{treecmp.diff.sh,treecmp.sha.sh}
	use "mediainfo" &&  cp -t bin "${FILESDIR}"/mi
	use "xml" && cp -t bin "${FILESDIR}"/xmlformat
	use "jad" && cp -t bin "${FILESDIR}"/jadd
	use "xdg" && cp -t bin "${FILESDIR}"/assoc
	use "sudo"  && cp -t bin "${FILESDIR}"/ffp
}

src_install() {
	into /usr
	dobin bin/*
	
	insinto /usr/libexec/anomen-toolset
	doins lib/*
	fperms 0755 /usr/libexec/anomen-toolset/treecmp.{sha,diff}.sh
}

