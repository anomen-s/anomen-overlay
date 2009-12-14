# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="C++ interface for GStreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/bindings/cplusplus.html"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug doc examples"

RDEPEND=">=media-libs/gstreamer-0.10.24
    >=dev-cpp/glibmm-2.21.1
    >=dev-cpp/libxmlpp-2.14
    >=dev-libs/libsigc++-2.0
    examples? ( >=dev-cpp/gtkmm-2.12.0 )"

DEPEND="${RDEPEND}
    dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README"

src_compile() {
	econf $(use_enable debug) \
              $(use_enable doc docs) \
              $(use_enable examples) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc ${DOCS} || die
}


