# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm

DESCRIPTION="Puppet Development Kit"
HOMEPAGE="https://puppet.com/docs/pdk/1.x/pdk.html"
SRC_URI="http://yum.puppetlabs.com/puppet5/el/7/x86_64/${P}-1.el7.x86_64.rpm"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	# Ensure root actually owns everything in the temporary directory
	chown -R portage:portage "${WORKDIR}"

	# Create the output directory
	local dest="/opt/puppetlabs/${PN}"
	dodir "${dest}" || die "Failed to create ${dest}"

	# Copy the pdk subdirectory from it's temp output
	cp -pPR "${WORKDIR}/opt/puppetlabs/pdk" "${D}/opt/puppetlabs/" || \
		die "Failed to copy install files into target"

	# Create a symlink for the pdk binary
	dosym "${dest}/bin/${PN}" "/usr/bin/${PN}" || die "Failed to create symlink"
}
