# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python

DESCRIPTION="Collection of python scripts for manipulating SVG files"
HOMEPAGE="http://lila-theme.berlios.de"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"

RESTRICT="nomirror nostrip"
SRC_URI="${HOMEPAGE}/files/utils/${P}.tar.bz2"

DEPEND="dev-lang/python
	dev-python/pyxml"

src_install() {
	# Getting python version...
	python_version
	export VERSION="python$PYVER"
	# Installing files...
	dodir $(python_get_libdir)/site-packages/svg
	cp ${S}/svg/* ${D}/$(python_get_libdir)/site-packages/svg	
	chmod 755 ${D}/$(python_get_libdir)/site-packages/svg

	dodir /usr/$(get_libdir)/${PN}
	cp ${S}/*.py ${D}/usr/$(get_libdir)/${PN}
	chmod 755 ${D}/usr/$(get_libdir)/${PN}

	dodir /usr/share/${PN}/svgcolor-xml
	cp -R ${S}/svgcolor-xml/* ${D}/usr/share/${PN}/svgcolor-xml
	chmod -R 755 ${D}/usr/share/${PN}/svgcolor-xml
	# Creating symlinks...
	dodir /usr/bin
	dosym /usr/$(get_libdir)/${PN}/svgcolor.py /usr/bin/svgcolor
	dosym /usr/$(get_libdir)/${PN}/svgdump.py /usr/bin/svgdump
	dosym /usr/$(get_libdir)/${PN}/svggrayscale.py /usr/bin/svggrayscale
	dosym /usr/$(get_libdir)/${PN}/svgoverlay.py /usr/bin/svgoverlay
	dosym /usr/$(get_libdir)/${PN}/svg-utils-info.py /usr/bin/svg-utils-info
	dosym /usr/$(get_libdir)/${PN}/svg-utils-test.py /usr/bin/svg-utils-test
}

pkg_postinst() {
	einfo "Installed library into /$(python_get_libdir)/site-packages/svg"
	einfo "Installed scripts into /usr/$(get_libdir)/svg-utils"
	einfo "Installed data into /usr/share/svg-utils"
	einfo "Symlinked scripts to /usr/bin"
}
