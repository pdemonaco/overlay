# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(
	python3_6 python3_7
)

# Utility Scripts
GITHUB_URI='https://github.com/pdemonaco'
INIT_SCRIPTS='factorio-init'
MOD_UPDATER='factorio-mod-updater'
MOD_UPDATER_VER="0.2.1"
INIT_VER="0.2.1"

DESCRIPTION="Headless server for Factorio."
HOMEPAGE="https://www.factorio.com"
BASE_URI="${HOMEPAGE}/get-download/${PV}/headless/"
SRC_URI="${SRC_URI}
	amd64? ( ${BASE_URI%/}/linux64 -> factorio_headless_x64_${PV}.tar.xz )
	${GITHUB_URI}/${MOD_UPDATER}/archive/${MOD_UPDATER_VER}.tar.gz -> \
		${MOD_UPDATER}.${MOD_UPDATER_VER}.tar.gz
	${GITHUB_URI}/${INIT_SCRIPTS}/archive/${INIT_VER}.tar.gz -> \
		${INIT_SCRIPTS}.${INIT_VER}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND=">=sys-libs/glibc-2.18
	acct-user/factorio
	acct-group/factorio"
RDEPEND="${DEPEND}
	app-shells/bash
	dev-python/requests"

TARGET_DIR="/opt/factorio"
SERVICE_USER="factorio"
SERVICE_GROUP="${SERVICE_USER}"

src_unpack() {
	unpack ${A}
	mv factorio "${S}"

	# Capture the updater script
	mv "${MOD_UPDATER}-${MOD_UPDATER_VER}/mod_updater.py" "${S}"

	# Move the init script and config file
	mv ${INIT_SCRIPTS}-${INIT_VER}/{conf,init} "${S}"
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

	# Install the mod updater script
	exeinto "${TARGET_DIR}/bin"
	doexe mod_updater.py || die

	# Create the init script & the config file
	newinitd init "${PN}" || die
	newconfd conf "${PN}" || die

	# Create the default config files
	diropts -o root -g "${SERVICE_GROUP}" -m 0755
	dodir /etc/factorio || die

	insinto /etc/factorio
	insopts -o root -g "${SERVICE_GROUP}" -m 0644
	newins data/server-settings.example.json server-settings.json || die
	newins data/map-settings.example.json map-settings.json || die
	newins data/map-gen-settings.example.json map-gen-settings.json || die

	# Log directory
	diropts -o "${SERVICE_USER}" -g "${SERVICE_GROUP}" -m 0775
	dodir /var/log/factorio || die
	keepdir /var/log/factorio || die

	# Save directory
	diropts -o "${SERVICE_USER}" -g "${SERVICE_GROUP}" -m 0755
	dodir "${TARGET_DIR}/saves" || die
	keepdir "${TARGET_DIR}/saves" || die
}

pkg_postinst() {
	# We need the whole install directory to be owned by the new factorio users
	chown -R "${SERVICE_USER}:${SERVICE_GROUP}" /opt/factorio || die

	einfo "Please read the multiplayer guide at"
	einfo "https://wiki.factorio.com/Multiplayer#Setting_up_a_Linux_Factorio_server"
	einfo "for further details regarding setup."
	einfo
	einfo "To start the service run the following:"
	einfo "		eselect rc start ${PN}"
	einfo
	einfo "Also, note that it may be desirable to add this service to the"
	einfo "default runlevel: "
	einfo "		eselect rc add ${PN} default"
}
