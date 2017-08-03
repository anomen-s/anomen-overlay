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
IUSE="subversion +xml +jad +mediainfo"

DEPEND=""
RDEPEND="
	subversion? ( dev-vcs/subversion )
	xml? ( dev-libs/libxml2 )
	jad? ( dev-java/jad-bin )
	mediainfo? ( media-video/mediainfo )
	virtual/libiconv
	"

src_unpack() {
	mkdir "${WORKDIR}/${P}"
	cd "${WORKDIR}/${P}"
	mkdir bin sbin lib

	cp -t bin "${FILESDIR}"/{bom,chmod.std,decwin,psm,treecmp,treeprune,flatten,unzipd}
	cp -t lib "${FILESDIR}"/{treecmp.diff.sh,treecmp.sha.sh}
	use "subversion" && cp -t bin "${FILESDIR}"/{rm.svn,svn.grep,svn.addall,svn.src,svn.mv}
	use "mediainfo" &&  cp -t bin "${FILESDIR}"/mi
	use "xml" && cp -t bin "${FILESDIR}"/xmlformat
	use "jad" && cp -t bin "${FILESDIR}"/jadd

	cp -t sbin "${FILESDIR}"/revdep-list.sh

}

src_install() {
	into /usr
	dobin bin/*
	dosbin sbin/*
	
	insinto /usr/libexec/anomen-toolset
	doins lib/*
	fperms 0755 /usr/libexec/anomen-toolset/treecmp.{sha,diff}.sh
}

