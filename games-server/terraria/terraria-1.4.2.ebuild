# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PV_NUMBER="${PV//[.]/}"

DESCRIPTION="Dig, Fight, Build!"
HOMEPAGE="https://terraria.org"
BASE_URI="https://terraria.org/system/dedicated_servers/archives/000/000/043/original"
SRC_URI="${BASE_URI}/terraria-server-${PV_NUMBER}.zip -> terraria-server_${PV}.zip"

# This isn't the right license, but I'm not going to figure out the right one
# now
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="acct-user/terraria
	acct-group/terraria"
RDEPEND="${DEPEND}"
BDEPEND=""

TARGET_DIR="/opt/terraria"
SERVICE_USER="terraria"
SERVICE_GROUP="terraria"

src_unpack() {
	unpack ${A}
	mv "${PV_NUMBER}/Linux" "${S}"

	# Move the sample config
	mv "${PV_NUMBER}/Windows/serverconfig.txt" "${S}"
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
	doins Terraria.png || die
	doins changelog.txt || die

	# Install the binary
	exeinto "${TARGET_DIR}"
	doexe TerrariaServer*

	# Create the config file
	diropts -o root -g "${SERVICE_GROUP}" -m 0644
	dodir /etc/terraria || die
	insinto /etc/terraria
	insopts -o root -g "${SERVICE_GROUP}" -m 0644
	doins serverconfig.txt || die

	# Create world 
	diropts -o "${SERVICE_USER}" -g "${SERVICE_GROUP}" -m 0755
	dodir "${TARGET_DIR}/worlds" || die
}
