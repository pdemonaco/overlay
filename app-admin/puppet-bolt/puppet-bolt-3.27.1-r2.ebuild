# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

DESCRIPTION="Stand alone task runner"
HOMEPAGE="https://www.puppet.com/docs/bolt/latest/bolt.html"
SRC_URI="http://yum.puppetlabs.com/puppet/el/8/x86_64/${P}-1.el8.x86_64.rpm"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror"

DEPEND="virtual/libcrypt
	sys-libs/readline"
RDEPEND="${DEPEND}"

src_unpack() {
	rpm_src_unpack ${A}

	# Make the "source" directory and move everything in
	mkdir "${S}"
	mv "${WORKDIR}/opt" "${S}/"
	mv "${WORKDIR}/usr" "${S}/"
}

src_install() {
	# Ensure portage actually owns everything in the temporary directory
	chown -R portage:portage "${S}"

	# Create the base directory and deploy the config files
	insinto /opt
	dodir puppetlabs/bolt
	doins -r opt/*

	# Generate the executable symlinks
	chmod 0755 -R "${D}/opt/puppetlabs/bolt/bin/"
	dosym "${dest}/bin/bolt" "/usr/bin/bolt" || die "Failed to create symlink"
}
