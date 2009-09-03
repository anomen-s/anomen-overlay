# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils font java-pkg-2

DESCRIPTION="Czech Economic System."
SRC_URI="http://www.winstrom.cz/download/${PV%.*}/${P}.tar.gz"
HOMEPAGE="http://www.winstrom.cz/"
LICENSE="WinStorm"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE="logrotate server"
RESTRICT="nomirror"

DEPEND=""
RDEPEND="|| (
		>=dev-java/sun-jre-bin-1.6
		>=dev-java/sun-jdk-1.6
	)
	server? ( >=virtual/postgresql-server-8.3 )
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
	cd "${S}"
	if use server; then
		# configuration
		insinto /etc/${PN}
		#doins etc/${PN}/ws.cenServer.xml
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
	FONT_SUFFIX="ttf"
	FONT_S=${S}/usr/share/fonts/truetype
	FONT_PN=${PN}
	font_src_install

	# icon
	doicon usr/share/pixmaps/${PN}.png

	# doc
	dodoc usr/share/doc/${PN}/*

	# create wrapper script for the server
	java-pkg_dolauncher ${PN}-server --main cz.winstrom.net.server.WinStromServer --pkg_args "-c /etc/winstrom/winstrom-server.xml --daemon" --java_args "-Xmx20m -client -XX:MinHeapFreeRatio=10 -XX:MaxHeapFreeRatio=10 -Djava.awt.headless=true -XX:CompileThreshold=16384"
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
	java-pkg_dolauncher ${PN} --main org.codehaus.classworlds.Launcher --java_args "-splash:/usr/share/${PN}/${PN}.png -Xmx256m -client -Dwinstromdir=/usr/share/${PN}/lib -Dclassworlds.conf=/usr/share/${PN}/lib/launcher.txt"

	# desktop entry
	make_desktop_entry ${PN} "WinStrom" ${PN}.png "Office"
}


pkg_postinst() {
	elog
	if use server ;then
		elog "To make WinStrom working, you have to start up the PostgreSQL server first."
		elog "Then, you have to create WinStrom DB admin (with password '7971'):"
		elog "$ createuser -a -d -P -E -U postgres -W dba"
		elog
		elog "First you have to start up the WinStrom server by /etc/init.d/winstrom-server."
		elog "Then you can start up the application by /usr/bin/winstrom."
		elog
	fi
	elog "Fist time you start the WinStrom application, go into the Data source management"
	elog "and Add new Data source with Server address 127.0.0.1 and Server port 5434."
	elog
}
