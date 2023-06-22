# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

DESCRIPTION="A tool for building and distributing development environments"
HOMEPAGE="https://vagrantup.com"
SRC_URI="https://releases.hashicorp.com/${PN}/${PV}/${P}-1.x86_64.rpm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	rpm_src_unpack ${A}

	# Make the "source" directory and move everything in
	mkdir "${S}"
	mv "${WORKDIR}/opt" "${S}/"
	mv "${WORKDIR}/bin" "${S}/"
}

src_install() {
	# Ensure root actually owns everything in the temporary directory
	chown -R portage:portage "${S}"

	# Create the output directory
	local dest="/opt/${PN}"
	dodir "${dest}" || die "Failed to create ${dest}"

	# Copy the pdk subdirectory from it's temp output
	cp -pPR "${S}/opt/${PN}" "${D}/opt/" || \
		die "Failed to copy install files into target"

	# Create the wrapper script
	exeinto "${D}/usr/bin"
	doexe "${S}/bin/vagrant" || die "Failed to install wrapper script"
}
