# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit user systemd

GITHUB_USER="syncthing"
GITHUB_REPO="syncthing"
GITHUB_TAG="${PV}"

DESCRIPTION="Open Source Continuous File Synchronization"
HOMEPAGE="http://syncthing.net/"

SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/v${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"

DEPEND=">=dev-lang/go-1.4.2"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

configDir="~/.config/syncthing"
config="${configDir}/config.xml"

src_compile() {
	# Create directory structure recommended by SyncThing Documentation
	# Since Go is "very particular" about file locations.
	local newBaseDir="src/github.com/${PN}"
	local newWorkDir="${newBaseDir}/${PN}"

	mkdir -p "${newBaseDir}"
	mv "${P}" "${newWorkDir}"

	cd "${newWorkDir}"

	# Build SyncThing ;D
	go run build.go -version v${PV} -no-upgrade=true

	# Move out of the go structure
	cd ..
	mv "${newWorkDir}" "${P}"
}

src_install() {
	# Copy compiled binary over to image directory
	dobin "bin/${PN}"

	# Install the OpenRC init/conf files
	doinitd "${FILESDIR}/init.d/${NAME}"
	doconfd "${FILESDIR}/conf.d/${NAME}"

	# Install the systemd service files
	if use systemd;	then
		local systemdServiceFile="etc/linux-systemd/system/${PN}@.service"
		systemd_dounit "${systemdServiceFile}"

		local systemdUserFile="etc/linux-systemd/user/${PN}.service"
		systemd_dounit "${systemdUserFile}"
	fi
}

pkg_postinst() {
	elog "In order to be able to view the Web UI remotely (from another machine),"
	elog "edit your ${config} and change the 127.0.0.1:8080 to 0.0.0.0:8080 in"
	elog "the 'address' section. This file will only be generated once you start syncthing."
}
