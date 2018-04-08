# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="Headless server for Factorio."
HOMEPAGE="https://www.factorio.com"

BASE_URI="https://www.factorio.com/get-download/${PV}/headless/"
SRC_URI="${SRC_URI}
	amd64? ( ${BASE_URI%/}/linux64 -> factorio_headless_x64_${PV}.tar.xz )"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=sys-libs/glibc-2.18"
RDEPEND="${DEPEND}"

TARGET_DIR="/opt/factorio"

SERVICE_USER="factorio"
SERVICE_GROUP="${SERVICE_USER}"

pkg_setup() {
	enewgroup "${SERVICE_GROUP}"
	enewuser "${SERVICE_USER}" -1 -1 -1 "${SERVICE_GROUP}"
}

src_unpack() {
	unpack ${A}
	mv factorio "${S}"
}

src_install() {
	# Create the main install directory in /opt
	dodir "${TARGET_DIR}" || die
	insinto "${TARGET_DIR}"

	# Install the data directory and the config file
	doins -r data || die 
	doins config-path.cfg || die

	# Install the binary as a binary
	dodir "${TARGET_DIR}/bin/x64/" || die
	exeinto "${TARGET_DIR}/bin/x64/"
	doexe bin/x64/factorio || die

	# Create the init script & the config file
	newinitd "${FILESDIR}/init_${PVR}" "${PN}" || die
	newconfd "${FILESDIR}/conf_${PVR}" "${PN}" || die

	# Create the default config files
	diropts -m 0755
	dodir /etc/factorio || die

	insinto /etc/factorio
	insopts -o root -g "${SERVICE_GROUP}" -m 0644
	newins data/server-settings.example.json server-settings.json || die

	# Log directory
	diropts -m 0775
	dodir /var/log/factorio || die
}

pkg_postinst() {
	# We need the whole install directory to be owned by the new factorio users
	chown -R "${SERVICE_USER}:${SERVICE_GROUP}" /opt/factorio || die

	einfo "Please read the multiplayer guide at"
	einfo "https://wiki.factorio.com/Multiplayer#Setting_up_a_Linux_Factorio_server"
	einfo "for further details regarding setup."
}
