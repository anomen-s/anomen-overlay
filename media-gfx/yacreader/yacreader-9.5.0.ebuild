# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils eutils fdo-mime xdg-utils

DESCRIPTION="A comic reader for cross-platform reading and managing your digital comic collection"
HOMEPAGE="http://www.yacreader.com"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/YACReader/${PN}.git"
else
	SRC_URI="https://github.com/YACReader/${PN}/releases/download/${PV}/${P}-src.tar.xz"
	KEYWORDS="~x86 ~amd64 ~arm"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtmultimedia:5
	app-text/poppler[qt5]
	dev-qt/qtdeclarative:5
	virtual/glu
	dev-qt/qtquickcontrols:5
	dev-util/desktop-file-utils
	app-arch/unarr
	app-arch/unrar
	app-arch/unzip
	dev-qt/qtimageformats:5
	media-gfx/qrencode
	app-arch/lha
	app-arch/p7zip
"
RDEPEND="${DEPEND}"

src_configure(){
	eqmake5 YACReader.pro
}

src_install(){
	emake INSTALL_ROOT="${D}" install
}

pkg_postinst(){
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm(){
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
	xdg_icon_cache_update
}
