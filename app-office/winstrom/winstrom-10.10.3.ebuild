# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils font java-pkg-2 versionator

DESCRIPTION="Czech Economic System."
SRC_URI="http://www.winstrom.cz/download/$(get_version_component_range 1-2)/${P}.tar.gz"
HOMEPAGE="http://www.winstrom.cz/"
LICENSE="WinStorm"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE="logrotate server"
RESTRICT="nomirror"

DEPEND="|| (
		>=virtual/jre-1.6
		>=virtual/jdk-1.6
	)"
RDEPEND="server? ( >=dev-db/postgresql-server-8.3[tcl] )
	logrotate? ( app-admin/logrotate )"
	# not all packages available so use the included
#	>=dev-java/jdbc-postgresql-8.3_p603
#	>=dev-java/antlr-2.7.6
#	>=dev-java/apple-java-extensions-bin-1.2
#	=dev-java/asm-1.5.3
#	>=dev-java/bcprov-1.36
#	>=dev-java/jgoodies-binding-1.1.1
#	=dev-java/cglib-2.1.3
#	>=dev-java/commons-beanutils-1.7.0
#	>=dev-java/commons-codec-1.3
#	dev-java/commons-collections
#	>=dev-java/commons-digester-1.7
#	>=dev-java/commons-httpclient-3.1
#	>=dev-java/commons-logging-1.0.4
#	>=dev-java/dom4j-1.6.1
#	>=dev-java/ehcache-1.2.3
#	>=dev-java/hibernate-3.2.3
#	>=dev-java/hibernate-annotations-3.2.1
#	>=dev-java/itext-1.3.1
#	>=app-text/jasperreports-1.3.3
#	>=dev-java/javahelp-2.0.02
#	>=dev-java/jcommon-1.0.2
#	>=dev-java/jta-1.0.1
#	>=dev-java/junit-3.8.1
#	>=dev-java/log4j-1.2.12
#	>=dev-java/sun-javamail-1.4
#	>=dev-java/glassfish-persistence-1.0
#	>=dev-java/poi-3.1
#	>=dev-java/swing-layout-1.0.2
#	>=dev-java/swingx-0.9.3
#	>=dev-java/xstream-1.2.2
#	>=dev-java/c3p0-0.9.1
#	>=dev-util/eclipse-sdk-3.1.0" # jdtcore

S="${WORKDIR}/${P}"
LANGS="cs en sk"

FONT_PATH=/usr/share/fonts
FONT_SUFFIX="ttf"
FONT_S=${S}${FONT_PATH}/truetype
FONT_PN=${PN}

pkg_setup() {
	# user under which the winstrom server is running
	enewuser winstrom 120 -1 /tmp nobody
}

src_unpack() {
	# convert deb to tar.gz and unpack it
	unpack ${A}

	# change the postgres port
	sed -i 's/5435/5432/' ${S}/etc/winstrom/winstrom-server.xml || die

	# move winstrom jars into the temp dir, delete the rest and move it back
#	cd ${S}/usr/share/${PN}/lib
#	mkdir tmp
#	mv ./winstrom-* ./softeu-* ./tmp
#	rm -f *.jar
#	mv ./tmp/*.jar ./

	# link all system libraries
#	java-pkg_jar-from eclipse-ecj-3.1
#	...
}

src_compile() {
	:;
}

src_install() {
	if use server; then
		# configuration
		insinto /etc/${PN}
		doins etc/${PN}/winstrom-server.xml
		fowners winstrom:root /etc/${PN}/winstrom-server.xml
		fperms 600 /etc/${PN}/winstrom-server.xml

		# config script
		newconfd ${FILESDIR}/${PN}-server.conf ${PN}-server

		# init script
		newinitd ${FILESDIR}/${PN}-server.init ${PN}-server
	fi

	# logrotate script
	if use logrotate ; then
		insinto /etc/logrotate.d
		doins etc/logrotate.d/${PN}
	fi

	# splash screen
	insinto /usr/share/${PN}
	doins usr/share/${PN}/${PN}-logo-small.png
	doins usr/share/${PN}/${PN}-splash.png

	# libraries
	java-pkg_dojar usr/share/${PN}/lib/*.jar

	# launcher, server, client and VERSION
	insinto /usr/share/${PN}/lib
	doins usr/share/${PN}/lib/*.txt

	# fonts
	insinto ${FONT_PATH}/${FONT_PN}
	doins ${FONT_S}/*.${FONT_SUFFIX}
	# I don't know how to use the following command with the EAPI="2"
	#font_src_install

	# icon
	doicon usr/share/pixmaps/${PN}.png

	# doc
	dodoc usr/share/doc/${PN}/* || die

	# create wrapper script for the server
	java-pkg_dolauncher ${PN}-server --main cz.winstrom.net.server.WinStromServer --pkg_args "-c /etc/winstrom/winstrom-server.xml --daemon" --java_args "-Xmx200m -server -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=10 -Djava.awt.headless=true -XX:CompileThreshold=16384 -XX:-OmitStackTraceInFastThrow"
	dodir /usr/sbin
	mv ${D}/usr/bin/${PN}-server ${D}/usr/sbin || die

	# install mime types
	insinto /usr/share/mimelnk/application/
	doins usr/share/mimelnk/application/*
	insinto /usr/share/mime/packages/
	doins usr/share/mime/packages/*

	# default file
	dodir /etc/default
	head -n6 etc/default/${PN} | tail -n2 > ${D}/etc/default/${PN}

	# create wrapper script for the client
	java-pkg_dolauncher ${PN} --main org.codehaus.classworlds.Launcher --java_args "-splash:/usr/share/${PN}/${PN}.png -Xmx384m -client -XX:MaxPermSize=128m -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=20 -XX:-OmitStackTraceInFastThrow -Dwinstromdir=/usr/share/${PN}/lib -Dclassworlds.conf=/usr/share/${PN}/lib/launcher.txt"
	# desktop entry
	make_desktop_entry ${PN} "WinStrom" /usr/share/pixmaps/${PN}.png "Office"
}


pkg_postinst() {
	elog
	if use server ;then
		elog "To make WinStrom working, you have to start up the PostgreSQL server first."
		elog "Then, you have to create WinStrom DB admin (with password '7971'):"
		elog "$ createuser -a -d -P -E -U postgres -W dba"
		elog
		elog "Use the /etc/init.d/winstrom-server script to start up the WinStrom server."
		elog
	fi
	elog "You can start up the WinStrom application by /usr/bin/winstrom."
	elog
	elog "Fist time you start the WinStrom application, go into the 'Data source management'"
	elog "and 'Add' new 'Data source' with 'Server address' 127.0.0.1 and 'Server port' 5434."
	elog
}
