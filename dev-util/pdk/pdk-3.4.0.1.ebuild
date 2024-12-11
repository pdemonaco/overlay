# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

DESCRIPTION="Puppet Development Kit"
HOMEPAGE="https://puppet.com/docs/pdk/3.x/pdk.html"
SRC_URI="http://yum.puppetlabs.com/puppet/el/9/x86_64/${P}-1.el9.x86_64.rpm"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

RDEPEND="virtual/libcrypt"

src_unpack() {
	rpm_src_unpack ${A}

	# Make the "source" directory and move everything in
	mkdir "${S}"
	mv "${WORKDIR}/opt" "${S}/"
	mv "${WORKDIR}/usr" "${S}/"
}

src_install() {
	# Ensure root actually owns everything in the temporary directory
	chown -R portage:portage "${S}"

	# Create the output directory
	local dest="/opt/puppetlabs/${PN}"
	dodir "${dest}" || die "Failed to create ${dest}"

	# Copy the pdk subdirectory from it's temp output
	cp -pPR "${S}/opt/puppetlabs/pdk" "${D}/opt/puppetlabs/" || \
		die "Failed to copy install files into target"

	# Create a symlink for the pdk binary
	dosym "${dest}/bin/${PN}" "/usr/bin/${PN}" || die "Failed to create symlink"
}
