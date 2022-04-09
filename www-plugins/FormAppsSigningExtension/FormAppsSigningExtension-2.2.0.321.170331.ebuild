# Copyright 2020 Gianni Bombelli <bombo82@giannibombelli.it>
# Distributed under the terms of the GNU General Public License  as published by the Free Software Foundation;
# either version 2 of the License, or (at your option) any later version.

EAPI=7

inherit eutils rpm

DESCRIPTION="FormAppsSigningExtension"
HOMEPAGE="https://www.602.cz/formfiller"
SRC_URI="https://formulare.ricany.cz/fas/page/apps/FormAppsSigningExtension.noarch.rpm"

LICENSE="all-rights-reserved no-source-code"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
RESTRICT="mirror strip"

DEPEND=""
RDEPEND="virtual/jre"

S="${WORKDIR}"

src_unpack() {
	rpm_src_unpack
}

src_compile() { :; }
src_test() { :; }

src_install() {
	dobin usr/bin/FormAppsSigningExtension
	insinto "$INSTALL_DIR/usr"
	doins -r usr/lib usr/lib64 usr/share
}
