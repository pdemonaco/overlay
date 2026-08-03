# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RPM_COMPRESS_TYPE="zstd"

inherit rpm shell-completion

DESCRIPTION="Stand alone task runner"
HOMEPAGE="https://docs.openvoxproject.org/openbolt/latest/"
SRC_URI="http://yum.voxpupuli.org/openvox8/el/9/x86_64/${P}-1.el9.x86_64.rpm"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bash-completion"

RESTRICT="mirror"

src_unpack() {
	rpm_src_unpack ${A}

	# Make the "source" directory and move everything in
	mkdir "${S}"
	mv "${WORKDIR}/etc" "${S}/"
	mv "${WORKDIR}/opt" "${S}/"
	mv "${WORKDIR}/usr" "${S}/"
}

src_install() {
	default
	# Ensure portage actually owns everything in the temporary directory
	chown -R portage:portage "${S}"

	# Create the base directory and deploy the config files
	insinto /opt
	dodir puppetlabs/bolt
	doins -r opt/*

	# Generate the executable symlinks
	chmod 0755 -R "${D}/opt/puppetlabs/bolt/bin/"
	chmod 0755 "${D}/opt/puppetlabs/bin/bolt"
	dosym "../../../opt/puppetlabs/bin/bolt" "/usr/local/bin/bolt"

	# Add bash completion when it's enabled.
	if use bash-completion; then
		newbashcomp "opt/puppetlabs/bolt/lib/ruby/gems/"*"/gems/${PN}-${PV}/resources/bolt_bash_completion.sh" bolt
	fi
}
