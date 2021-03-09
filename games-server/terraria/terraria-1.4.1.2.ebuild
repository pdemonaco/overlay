# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PV_NUMBER="${PV//[.]/}"

DESCRIPTION="Dig, Fight, Build!"
HOMEPAGE="https://terraria.org"
BASE_URI="https://terraria.org/system/dedicated_servers/archives/000/000/042/original"
SRC_URI="${BASE_URI}/terraria-server-${PV_NUMBER}.zip -> terraria-server_${PV}.zip"

# This isn't the right license, but I'm not going to figure out the right one
# now
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

TARGET_DIR="/opt/terraria"

src_unpack() {
	unpack ${A}
	mv "${PV_NUMBER}/Linux" "${S}"
}

src_install() {
	# Create the install directory in /opt
	dodir "${TARGET_DIR}" || die
	insinto "${TARGET_DIR}"

	# Install the libraries
	doins -r lib || die
	doins -r lib64 || die

	# Install the dlls
	doins *.dll || die

	# Install the config files
	doins *.config || die

	# Install various scripts and rando files
	doins monoconfig || die
	doins monomachineconfig || die
	doins open-folder || die
	doins TerrariaServer || die
	doins Terraria.png || die
	doins changelog.txt || die

	# Install the binary
	exeinto "${TARGET_DIR}"
	doexe TerrariaServer.bin.x86_64
}
