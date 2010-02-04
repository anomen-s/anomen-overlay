# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-DNS/Net-DNS-0.66.ebuild,v 1.4 2010/01/10 16:14:00 maekke Exp $

EAPI=2

MODULE_AUTHOR=MACGYVER
inherit perl-module

DESCRIPTION="Perl Net::DNS - Perl DNS Resolver Module"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple
		dev-perl/Test-Pod )"

SRC_TEST="do"

src_prepare() {
	perl-module_src_prepare
	mydoc="README"
	myconf="${myconf} --no-online-tests"
}
