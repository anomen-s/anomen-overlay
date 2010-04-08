# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-utils-2

DESCRIPTION="Glassfish Application Server"
HOMEPAGE="https://glassfish.dev.java.net/"

INSTALL_FILE="glassfish-installer-v${PV}-b31g-linux.jar"
SRC_URI="http://java.net/download/javaee5/v${PV}_branch/promoted/Linux/${INSTALL_FILE}"
RESTRICT="mirror strip binchecks"

LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
SLOT="${PV}"
KEYWORDS="~x86 ~amd64"
IUSE="cluster ml"
DEPEND=">=virtual/jdk-1.5"
RDEPEND="${DEPEND}"

GLASSFISH_INSTALL_BASE="/opt/glassfish-v${PV}"
GLASSFISH_DOMAINS="/var/opt/glassfish/domains"
GLASSFISH_WORKDIR="${WORKDIR}/glassfish"
GLASSFISH_DOMAINS_WORKDIR="${WORKDIR}/domains"
GLASSFISH_ENVD_FILE="99glassfish"
GLASSFISH_GENTOO_README="${GLASSFISH_INSTALL_BASE}/README.gentoo"

stop_domains() {
	einfo "Stopping any running Glassfish domains..."
	local domains=`$1/bin/asadmin list-domains | grep "running" | grep -v "not" | cut -f 1 -d" "`
	for domain in $domains; do
	  einfo "`$1/bin/asadmin stop-domain $domain`"
	done
	einfo "Glassfish domains stopped."
}

pkg_setup() {
	java-pkg_init
	if has_version ${CATEGORY}/${PN}; then
		einfo "Glassfish already installed..."
		local gfhome=`grep GLASSFISH_HOME /etc/env.d/${GLASSFISH_ENVD_FILE} | cut -f 2 -d"="`
		stop_domains "$gfhome"
		einfo "Reinstalling Glassfish..."
	fi
	enewgroup glassfish
	enewuser glassfish -1 -1 /dev/null glassfish
}

src_unpack() {
# unsetting the DISPLAY is required to stop the glassfish installer popping up a
# graphical license display.
	unset DISPLAY
	echo "a\n" | java -Xmx256m -jar "${DISTDIR}/${INSTALL_FILE}"
}

src_install() {
	cd ${GLASSFISH_WORKDIR}
	chmod -R +x lib/ant/bin
	local setupfile
	if use cluster; then
		setupfile="setup-cluster.xml"
	else
		setupfile="setup.xml"
	fi

	sed -i -e "s@.{install.home}/domains@${GLASSFISH_DOMAINS_WORKDIR}@" "${GLASSFISH_WORKDIR}/${setupfile}"

# The ant setup writes 2 files into the home directory of the installing user.
# Attempts to set HOME="..." failed, probably because of ant.
	addwrite /root/.asadmintruststore
	addwrite /root/.asadminpass
	addwrite /root/cf.out
	lib/ant/bin/ant -f ${setupfile}


# Remove sunos files as we don't need them
	find ${GLASSFISH_WORKDIR} -type d -name sunos -prune -exec rm -rf {} \;

# Glassfish has a number of hardcoded paths in various files after the setup is
# run.  These need to be modified to work in the real install location.
	einfo "Fixing hardcoded paths"
	for file in `grep -rl "${GLASSFISH_WORKDIR}" ${WORKDIR}`; do
		einfo "Fixing path in file: $file"
		sed -i -e "s@${GLASSFISH_WORKDIR}@${GLASSFISH_INSTALL_BASE}@g" $file
	done
	for file in `grep -rl "${GLASSFISH_DOMAINS_WORKDIR}" ${WORKDIR}`; do
		einfo "Fixing path in file: $file"
		sed -i -e "s@${GLASSFISH_DOMAINS_WORKDIR}@${GLASSFISH_DOMAINS}@g" $file
	done
	einfo "Fixing hardcoded paths - done"

	#diropts -m775 -o glassfish -g glassfish
	dodir ${GLASSFISH_INSTALL_BASE}
	cp -pPR ${GLASSFISH_WORKDIR}/* "${D}${GLASSFISH_INSTALL_BASE}"
	#chmod -R 775 "${D}"${GLASSFISH_INSTALL_BASE}

	dodir ${GLASSFISH_DOMAINS}
	cp -pPR ${GLASSFISH_DOMAINS_WORKDIR}/* "${D}${GLASSFISH_DOMAINS}"

	dosym ../../var/opt/glassfish/domains ${GLASSFISH_INSTALL_BASE}/domains
	fowners -R glassfish:glassfish ${GLASSFISH_DOMAINS}
	fperms a+w -R ${GLASSFISH_DOMAINS}

	local envd_dir="${D}/etc/env.d/" 
	mkdir -p "${envd_dir}"
	echo "PATH=${GLASSFISH_INSTALL_BASE}/bin" > "${envd_dir}"${GLASSFISH_ENVD_FILE}
	echo "GLASSFISH_HOME=${GLASSFISH_INSTALL_BASE}" >> "${envd_dir}"${GLASSFISH_ENVD_FILE}

	cat <<- EOF > "${D}"${GLASSFISH_GENTOO_README}
	Glassfish Application Server has been installed using the glassfish
	user and glassfish group.  To use Glassfish as another user, add the
	glassfish group to the user.
	
	To use the Glassfish commands, do 'source /etc/profile'.  This will
	add the ${GLASSFISH_INSTALL_BASE}/bin to your PATH and create the
	GLASSFISH_HOME environment variable as ${GLASSFISH_INSTALL_BASE}.
	
	To get started with Glassfish, see the Quick Start Guide at:
	https://glassfish.dev.java.net/downloads/quickstart/index.html

	If you remove Glassfish, some files may still exist in ${GLASSFISH_INSTALL_BASE}
	from running Glassfish, e.g. log files, new domains, etc.  The removal
	process deliberately leaves these files alone.
	EOF
}

pkg_postinst() {
	einfo "${GLASSFISH_GENTOO_README} contains more information on this installation."
}

pkg_prerm() {
	stop_domains ${GLASSFISH_INSTALL_BASE}
}
