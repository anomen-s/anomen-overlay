# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp

DESCRIPTION="Wiki primarily designed as a tool to support easy, collaborative
authoring and maintenance of web sites"
HOMEPAGE="http://www.pmwiki.org/"
SRC_URI="http://www.pmwiki.org/pub/pmwiki/${P}.tgz http://www.pmwiki.org/pub/pmwiki/older-releases/${P}.tgz"

LICENSE="GPL-2"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="dev-lang/php"

src_install() {
	webapp_src_preinst

	# Creating a default config file
	cp "${FILESDIR}/sample-config.php" local/config.php

	# This directory is needed by pmwiki, here it stores its files
	mkdir "${D}/${MY_HTDOCSDIR}/wiki.d"
	keepdir "${D}/${MY_HTDOCSDIR}/wiki.d"
	webapp_serverowned "${MY_HTDOCSDIR}/wiki.d"
	
	# Create the files upload directory
	mkdir "${D}/${MY_HTDOCSDIR}/uploads"
	keepdir "${D}/${MY_HTDOCSDIR}/uploads"
	webapp_serverowned "${MY_HTDOCSDIR}/uploads"

	# Removing unecessary files
	rm COPYING
	
	# Install to webapp-config master directory
	cp -a * "${D}/${MY_HTDOCSDIR}"

	webapp_configfile "${MY_HTDOCSDIR}/local/config.php"
	
	webapp_postinst_txt en "${FILESDIR}/postinstall-en.txt"

	webapp_src_install
}
