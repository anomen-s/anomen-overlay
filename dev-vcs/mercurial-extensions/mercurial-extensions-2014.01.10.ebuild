# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="4"

DESCRIPTION="Various Mercurial extensions"
HOMEPAGE="http://mercurial.selenic.com/"
SRC_URI="
  https://bitbucket.org/Mekk/mercurial_keyring/raw/fb4371a55e795782738fec1f85b5635e59ad8f44/mercurial_keyring.py
  https://bitbucket.org/gobell/hg-zipdoc/raw/a2ca45ccfd648e714ae6f1f4ad437260aa161496/zipdoc.py
  https://bitbucket.org/birkenfeld/hgchangelog/raw/bb962d35fd2bcb396502f4e24840f24585614dec/hgchangelog.py
  https://bitbucket.org/jinhui/hg-cloc/raw/9a7c5cf25816b72ccb3eaf1fa3255e565a2e4e0a/cloc.py
  https://bitbucket.org/abuehl/hgext-cifiles/raw/091b6a4b561b65aa70f23f5cf8285e5e23676445/cifiles.py
  https://bitbucket.org/face/timestamp/raw/e85aaaa0a21a9710af1865b828188ff30e19399e/casestop.py"

RESTRICT="mirror"
LICENSE="GPL-2+ as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="dev-vcs/mercurial"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/*.py "${S}"
}

src_install() {
	local dir=/usr/libexec/hgext
	insinto "${dir}"
	doins  *.py
}
