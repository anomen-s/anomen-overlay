# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
EAPI="5"

DESCRIPTION="Various Mercurial extensions"
HOMEPAGE="http://mercurial.selenic.com/"
SRC_URI="
  https://bitbucket.org/Mekk/mercurial_keyring/raw/8b2977b/mercurial_keyring.py -> 8b2977b-mercurial_keyring.py
  https://bitbucket.org/gobell/hg-zipdoc/raw/3cadb68/zipdoc.py -> 3cadb68-zipdoc.py
  https://bitbucket.org/birkenfeld/hgchangelog/raw/f043cc9/hgchangelog.py -> f043cc9-hgchangelog.py
  https://bitbucket.org/jinhui/hg-cloc/raw/9a7c5cf25816/cloc.py -> 9a7c5cf25816-cloc.py
  https://bitbucket.org/abuehl/hgext-cifiles/raw/091b6a4b561b/cifiles.py -> 091b6a4b561b-cifiles.py
  https://bitbucket.org/face/timestamp/raw/e85aaaa0a21a/casestop.py -> e85aaaa0a21a-casestop.py
  https://bitbucket.org/peerst/hgcollapse/raw/3616724/hgext/collapse.py -> 3616724-collapse.py
  https://bitbucket.org/marmoute/mutable-history/raw/970a4c1/hgext/evolve.py -> 970a4c1-evolve.py
  "
# removed:  https://bitbucket.org/dwt/hg-info/

RESTRICT="mirror"
LICENSE="GPL-2+ as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="dev-vcs/mercurial"

S="${WORKDIR}"

src_unpack() {
	cd "${DISTDIR}"
	for FILE in *.py
	do
	    cp "${FILE}" "$S/${FILE#*-}"
	done
}

src_install() {
	local dir=/usr/libexec/hgext
	insinto "${dir}"
	doins  *.py
}
