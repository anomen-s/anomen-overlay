# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Fake (honey pot) SMTP server"
HOMEPAGE="https://sourceforge.net/projects/spamsink/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ia64"
IUSE=""
RESTRICT=""

DEPEND=""
RDEPEND="
	dev-perl/SMTP-Server
	dev-perl/Net-DNS"

S="${WORKDIR}/${PF}"



src_install() {
	dobin spamsink.pl spamsink_relay.pl
	
}
