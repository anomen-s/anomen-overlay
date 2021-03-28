# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="A Collection of Postscript Type1 Fonts"
HOMEPAGE="http://www.gimp.org"
SRC_URI="mirror://gimp/fonts/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="X"
RESTRICT="mirror bindist"

S="${WORKDIR}/sharefont"

DOCS="README *.shareware"
FONT_S="${S}"
FONT_SUFFIX="pfb"
