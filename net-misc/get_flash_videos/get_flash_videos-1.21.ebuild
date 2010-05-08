# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit git

EGIT_REPO_URI="git://github.com/monsieurvideo/get-flash-videos.git"
EGIT_COMMIT="v${PV}"

DESCRIPTION="Downloads videos from various Flash-based video hosting sites"
HOMEPAGE="http://code.google.com/p/get-flash-videos/"

LICENSE="APACHE"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="rtmpdump simplexml crypt amf zlib"

RDEPEND="
	dev-lang/perl
	dev-perl/WWW-Mechanize
	perl-core/Module-CoreList
	rtmpdump? ( net-misc/rtmpdump )
	simplexml? ( dev-perl/XML-Simple )
	crypt? ( dev-perl/Crypt-Rijndael )
	amf? ( dev-perl/Data-AMF )
	zlib? ( perl-core/IO-Compress )" 

DEPEND="
	${RDEPEND}
	dev-vcs/git
	dev-perl/UNIVERSAL-require"

src_compile() {
	emake default || die

	# man page compilation
	emake "${PN}.1.gz" || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
