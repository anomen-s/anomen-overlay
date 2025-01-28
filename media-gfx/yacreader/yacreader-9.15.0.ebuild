# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="A comic reader for cross-platform reading and managing your comic collection"
HOMEPAGE="http://www.yacreader.com"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/YACReader/${PN}.git"
else
	SRC_URI="https://github.com/YACReader/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${P}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="pdf qrencode webp"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtmultimedia:5
	dev-qt/qtdeclarative:5
	dev-qt/qtopengl:5
	dev-qt/qtscript:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtnetwork:5
	webp? ( dev-qt/qtimageformats:5 )
	virtual/glu
	dev-qt/qtquickcontrols:5
	dev-qt/qtquickcontrols2:5
	dev-util/desktop-file-utils
	app-arch/unarr
	pdf? ( app-text/poppler:=[qt5] )
	qrencode? ( media-gfx/qrencode:= )
"
RDEPEND="${DEPEND}"

src_configure(){
	eqmake5
}

src_install(){
	INSTALL_ROOT="${D}" default
}

pkg_postinst(){
	xdg_pkg_postinst
	echo
	elog "Additional packages are required to open the most common comic archives:"
	elog
	elog "	cbr: app-arch/unrar"
	elog "	cbz: app-arch/unzip"
	elog
	elog "You can also add support for 7z files by installing app-arch/p7zip"
	elog "and LHA files by installing app-arch/lha."
	elog
	use webp || elog "Enable useflag webp if you want support for extra image files (WebP, ...)"
	use webp || elog "through dev-qt/qtimageformats"
	echo
}
