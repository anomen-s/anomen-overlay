# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

EGIT_REPO_URI="https://github.com/groeck/it87.git"

inherit git-r3 eutils flag-o-matic linux-info linux-mod toolchain-funcs

DESCRIPTION="Linux IT87 module"
HOMEPAGE="https://github.com/groeck/it87.git"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
RESTRICT=""

CONFIG_CHECK="HWMON ~!CONFIG_SENSORS_IT87"

DEPEND="dev-vcs/git"

RDEPEND=""

DOCS=( TODO README )

MODULE_NAMES="it87(misc:${S})"
BUILD_TARGETS="modules"

src_prepare() {
	# Set kernel build dir
	sed -i 's@^KERNEL_BUILD.*@KERNEL_BUILD := $(KERNEL_MODULES)/build@' "${S}/Makefile" || die "Could not fix build path"
}
