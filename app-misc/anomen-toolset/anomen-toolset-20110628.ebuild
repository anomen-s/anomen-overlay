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
IUSE="subversion"

DEPEND=""
RDEPEND="
	subversion? ( dev-vcs/subversion )
	virtual/libiconv
	"

src_unpack() {
	cd "${WORKDIR}"
	mkdir {bin,sbin,lib}

	cp -t bin "${FILESDIR}"/{decwin,chmod.std,psm,rm.lf,treecmp,treeprune}
	cp -t lib "${FILESDIR}"/{treecmp.diff,treecmp.sha}
	use "subversion" && cp -t bin "${FILESDIR}"/{rm.svn,svn.grep,svn.addall,svn.src}

	cp -t sbin "${FILESDIR}"/revdep-list.sh

}

src_install() {
	into /usr/local
	dobin bin/*
	dosbin sbin/*
	
	insinto /usr/local/lib/anomen-toolset
	doins lib/*
	fperms 0755 /usr/local/lib/anomen-toolset/treecmp.{sha,diff}
}

