# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Maintainer: Tony Kay <tkay@uoregon.edu>
# Author: Tony Kay <tkay@uoregon.edu>

# TODO: jdbc symlinks

IUSE="postgresql mysql mssql"

inherit eutils versionator java-utils-2

MY_PV=$(replace_all_version_separators '_')
At=dbvis_unix_${MY_PV}.tar.gz

DOWNLOAD_URL="http://www.minq.se/products/{$PN}/download.html"

DESCRIPTION="Minq Software's DB Visualizer (Free Version)"
HOMEPAGE="http://www.minq.se/products/dbvis/"
SRC_URI="http://www.minq.se/product_download/${P}/media/${At}"

SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="Apache-1.1"
RESTRICT="mirror"

RDEPEND="virtual/jre 
	postgresql? ( dev-java/jdbc-postgresql )
	mssql? ( dev-java/jdbc-mssqlserver )
	mysql? ( dev-java/jdbc-mysql )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/DbVisualizer-${PV}"
INSTALLDIR="/opt/DbVisualizer"

src_unpack() {
	unpack ${A}

	cd ${S}

	epatch ${FILESDIR}/${PV}-dbvis.patch

	if use mssql ; then
		mkdir jdbc/mssql
		java-pkg_jar-from --into jdbc/mssql  jdbc-mssqlserver-2005
	fi

	if use mysql ; then
		rm jdbc/mysql/*
		java-pkg_jar-from --into jdbc/mysql  jdbc-mysql
	fi

	if use postgresql ; then
		rm jdbc/postgresql/*
		java-pkg_jar-from --into jdbc/postgresql  jdbc-postgresql
	fi

}

src_install() {

	if use mssql ; then
		mkdir jdbc/mssql
		java-pkg_jar-from --into jdbc/mssql  jdbc-mssqlserver-2005
	fi

	if use mysql ; then
		rm jdbc/mysql/*
		java-pkg_jar-from --into jdbc/mysql  jdbc-mysql
	fi
	
	if use postgresql ; then
		rm jdbc/postgresql/*
		java-pkg_jar-from --into jdbc/postgresql  jdbc-postgresql
	fi

	insinto ${INSTALLDIR}

	doins -r .install4j *

	fperms +x ${INSTALLDIR}/dbvis

	dosym ${INSTALLDIR}/dbvis /opt/bin/${PN}

	newicon .install4j/i4j_extf_2_1bd0g0g_1yp3pgl.png ${PN}.png
	make_desktop_entry ${PN} "DbVisualizer ${PV}" ${PN}.png "Development;Database" 
}

