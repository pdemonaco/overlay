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

pkg_setup() {
	enewgroup factorio
	enewuser factorio -1 -1 -1 factorio
}

src_unpack() {
	unpack ${A}
	mv factorio "${S}"
}

src_install() {
	dodir "${TARGET_DIR}"
	insinto "${TARGET_DIR}"
	doins -r data
	doins config-path.cfg
	dodir "${TARGET_DIR}/bin/x64/"
	exeinto "${TARGET_DIR}/bin/x64/"
	doexe bin/x64/factorio
}

pkg_postinst() {
	chown -R factorio:factorio /opt/factorio || die

	elog "Please read the multiplayer guide at"
	elog "https://wiki.factorio.com/Multiplayer#Setting_up_a_Linux_Factorio_server"
	elog "for further details regarding setup."
}
