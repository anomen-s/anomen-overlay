# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="3"

DESCRIPTION="Anomen's collection of simple shell scripts"
HOMEPAGE="http://repo.or.cz/w/anomen-overlay.git/tree/HEAD:/app-misc/anomen-toolset"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="subversion +ssh +xml +jad"

DEPEND=""
RDEPEND="
	subversion? ( dev-vcs/subversion )
	ssh? ( net-misc/openssh )
	xml? ( dev-libs/libxml2 )
	jad? ( dev-java/jad-bin )
	virtual/libiconv
	"

src_unpack() {
	cd "${WORKDIR}"
	mkdir bin sbin lib

	cp -t bin "${FILESDIR}"/{chmod.std,decwin,psm,treecmp,treeprune,flatten,unzipd}
	cp -t lib "${FILESDIR}"/{treecmp.diff.sh,treecmp.sha.sh}
	use "ssh" && cp -t bin "${FILESDIR}"/ssh-agent-shared
	use "subversion" && cp -t bin "${FILESDIR}"/{rm.svn,svn.grep,svn.addall,svn.src,svn.mv}
	use "xml" && cp -t bin "${FILESDIR}"/xmlformat
	use "xml" && cp -t bin "${FILESDIR}"/jadd

	cp -t sbin "${FILESDIR}"/revdep-list.sh

}

src_install() {
	into /usr/local
	dobin bin/*
	dosbin sbin/*
	
	insinto /usr/local/lib/anomen-toolset
	doins lib/*
	fperms 0755 /usr/local/lib/anomen-toolset/treecmp.{sha,diff}.sh
}

