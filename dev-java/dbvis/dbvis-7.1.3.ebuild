# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# TODO: jdbc symlinks

EAPI="2"

IUSE="postgresql mysql mssql jtds"

inherit eutils versionator java-utils-2

MY_PV=$(replace_all_version_separators '_')
At=dbvis_unix_${MY_PV}.tar.gz

DOWNLOAD_URL="http://www.dbvis.com/"

DESCRIPTION="DB Visualizer (Free Version)"
HOMEPAGE="http://www.dbvis.com/"
SRC_URI="http://www.dbvis.com/product_download/${P}/media/${At}"

SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="Apache-1.1"
RESTRICT="mirror"

RDEPEND="virtual/jre
	postgresql? ( dev-java/jdbc-postgresql )
	mssql? ( dev-java/jdbc-mssqlserver )
	jtds? ( dev-java/jtds:1.2 )
	mysql? ( dev-java/jdbc-mysql )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/DbVisualizer-${PV}"
INSTALLDIR="/opt/DbVisualizer-${PV}"

src_unpack() {
	unpack ${A}

	cd ${S}

	if use mssql ; then
		mkdir jdbc/mssql
		java-pkg_jar-from --into jdbc/mssql  jdbc-mssqlserver-2005
	fi

	if use jtds ; then
		rm jdbc/jtds/*
		java-pkg_jar-from --into jdbc/jtds jtds-1.2
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

	insinto ${INSTALLDIR}

	doins -r .install4j *

	fperms +x ${INSTALLDIR}/{dbvis,dbviscmd.sh,dbvisgui.sh}

	dosed -e "3i cd ${INSTALLDIR}" ${INSTALLDIR}/dbvis || die patch failed
	dosed -e "s@^app_home=\.\$@app_home=${INSTALLDIR}@" ${INSTALLDIR}/dbvis || die patch failed

	dosym ${INSTALLDIR}/dbvis /opt/bin/${PN}

	newicon .install4j/i4j_extf_2_1bd0g0g_x4q5yx.png ${PN}.png
	make_desktop_entry ${PN} "DbVisualizer ${PV}" ${PN} "Development;Database" 
}

