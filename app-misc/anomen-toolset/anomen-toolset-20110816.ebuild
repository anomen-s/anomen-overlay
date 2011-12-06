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
IUSE="subversion +ssh +xml"

DEPEND=""
RDEPEND="
	subversion? ( dev-vcs/subversion )
	ssh? ( net-misc/openssh )
	xml? ( dev-libs/libxml2 )
	virtual/libiconv
	"

src_unpack() {
	cd "${WORKDIR}"
	mkdir {bin,sbin,libexec}

	cp -t bin "${FILESDIR}"/{decwin,chmod.std,psm,treecmp,treeprune}
	cp -t libexec "${FILESDIR}"/{treecmp.diff,treecmp.sha}
	use "ssh" && cp -t bin "${FILESDIR}"/ssh-agent-shared
	use "subversion" && cp -t bin "${FILESDIR}"/{rm.svn,svn.grep,svn.addall,svn.src,svn.mv}
	use "xml" && cp -t bin "${FILESDIR}"/xmlformat

	cp -t sbin "${FILESDIR}"/revdep-list.sh

}

src_install() {
	into /usr
	dobin bin/*
	dosbin sbin/*
	
	insinto /usr/libexec/anomen-toolset
	doins libexec/*
	fperms 0755 /usr/libexec/anomen-toolset/treecmp.{sha,diff}
}
