# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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

USER="factorio"
GROUP="factorio"

pkg_setup() {
	enewgroup "${USER}"
	enewuser "${USER}" -1 -1 -1 "${GROUP}"
}

src_install() {
	insinto /opt
	doins -r factorio
}
