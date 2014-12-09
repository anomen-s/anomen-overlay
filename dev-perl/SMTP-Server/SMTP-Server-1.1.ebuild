# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

MODULE_AUTHOR=MACGYVER
inherit perl-module

DESCRIPTION="Perl Net::SMTP::Server - Perl SMTP::SERVER Module"

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
