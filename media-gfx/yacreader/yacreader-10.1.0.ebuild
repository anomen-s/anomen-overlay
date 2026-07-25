# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

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
	dev-qt/qtbase:6[gui,network,opengl,sql,widgets]
	dev-qt/qt5compat:6
	dev-qt/qtdeclarative:6
	dev-qt/qtmultimedia:6
	dev-qt/qtshadertools:6
	dev-qt/qtspeech:6
	dev-qt/qtsvg:6
	virtual/glu
	app-arch/unarr
	webp? ( media-libs/libwebp dev-qt/qtimageformats:6 )
	pdf? ( app-text/poppler:=[qt6] )
	qrencode? ( media-gfx/qrencode:= )
"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DDECOMPRESSION_BACKEND=unarr
		-DPDF_BACKEND=$(usex pdf poppler no_pdf)
		-DBUILD_TESTS=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
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
