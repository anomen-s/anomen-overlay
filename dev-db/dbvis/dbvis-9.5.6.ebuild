# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# TODO: jdbc symlinks

EAPI="5"

IUSE="postgresql mysql mssql jtds"

inherit eutils versionator java-utils-2

MY_PV=$(replace_all_version_separators '_')
At=dbvis_unix_${MY_PV}.tar.gz

DOWNLOAD_URL="http://www.dbvis.com/"

ICO="i4j_extf_2_1bd0g0g_1ns3hpr.png"

DESCRIPTION="DB Visualizer (Free Version)"
HOMEPAGE="http://www.dbvis.com/"
SRC_URI="http://www.dbvis.com/product_download/${P}/media/${At}"

SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="Apache-1.1"
RESTRICT="mirror"

RDEPEND="virtual/jre
	dev-java/java-config
	postgresql? ( dev-java/jdbc-postgresql )
	mssql? ( dev-java/jdbc-mssqlserver:4.2 )
	jtds? ( dev-java/jtds:1.3 )
	mysql? ( dev-java/jdbc-mysql )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/DbVisualizer"
INSTALLDIR="/opt/DbVisualizer-${PV}"

src_unpack() {
	unpack ${A}

	cd ${S}

	sed -e "3i cd ${INSTALLDIR}" \
	    -e '5i INSTALL4J_JAVA_HOME_OVERRIDE=`java-config -o`' -i dbvis || die patch failed

	if use mssql ; then
		mkdir jdbc/mssql
		java-pkg_jar-from --into jdbc/mssql jdbc-mssqlserver-4.2
	fi

	if use jtds ; then
		rm jdbc/jtds/*
		java-pkg_jar-from --into jdbc/jtds jtds-1.3
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

	fperms +x ${INSTALLDIR}/dbvis

	dosym ${INSTALLDIR}/dbvis /opt/bin/${PN}

	newicon ".install4j/${ICO}"  ${PN}.png
	make_desktop_entry ${PN} "DbVisualizer ${PV}" ${PN} "Development;Database" 
}

