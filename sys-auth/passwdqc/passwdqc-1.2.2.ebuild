# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_passwdqc/pam_passwdqc-1.0.5.ebuild,v 1.17 2010/01/07 15:54:56 fauli Exp $

EAPI="2"

inherit pam eutils toolchain-funcs

DESCRIPTION="Password strength checking for PAM aware password changing programs"
HOMEPAGE="http://www.openwall.com/passwdqc/"
SRC_URI="http://www.openwall.com/${PN}/${P}.tar.gz"

LICENSE="BSD as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="pam"

DEPEND="pam? (
		virtual/pam
		!sys-auth/pam_passwdqc
	)"

src_compile() {
	emake \
		OPTCFLAGS="${CFLAGS}" \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		$( use pam && echo all || echo utils ) \
		|| die "emake failed"
}

src_install() {
	dopammod pam_passwdqc.so

	doman *.[1-8]
	dodoc README PLATFORMS INTERNALS
	dobin pwqgen pwqcheck
	dolib libpasswdqc.so.*
	dosym libpasswdqc.so.* /usr/$(get_libdir)/libglfw.so
	insinto /etc
	doins passwdqc.conf
}

pkg_postinst() {
	elog
	elog "To activate pam_passwdqc use pam_passwdqc.so instead"
	elog "of pam_cracklib.so in /etc/pam.d/system-auth."
	elog "Also, if you want to change the parameters, read up"
	elog "on the pam_passwdqc(8) man page."
	elog
}
