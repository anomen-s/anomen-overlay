# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=(python2_7 python3_4 python3_5)
inherit python-any-r1

DESCRIPTION="SSH server auditing (banner, key exchange, encryption, mac, compression, etc)"
HOMEPAGE="https://github.com/arthepsy/ssh-audit"
SRC_URI="https://github.com/arthepsy/ssh-audit/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

# Tests require prospector which is not packaged

src_install() {
	default

	newbin ssh-audit.py ssh-audit
}
