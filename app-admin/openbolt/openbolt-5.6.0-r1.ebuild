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

src_prepare() {
	default

	# Determine the vendored ruby gem directory (e.g. .../lib/ruby/gems/3.2.0)
	# by inspecting what the RPM actually shipped, rather than hardcoding a
	# ruby version that may change between openbolt releases.
	local gem_dirs=( "${S}"/opt/puppetlabs/bolt/lib/ruby/gems/*/ )

	[[ ${#gem_dirs[@]} -eq 1 ]] || die \
		"Expected exactly one vendored ruby gems dir, found: ${gem_dirs[*]}"

	local gem_home="${gem_dirs[0]%/}"
	gem_home="/opt/puppetlabs/bolt/lib/ruby/gems/${gem_home##*/}"

	einfo "Pinning bolt wrapper GEM_HOME/GEM_PATH to ${gem_home}"

	# The upstream wrapper does `env -u GEM_HOME -u GEM_PATH ...` before
	# exec'ing bolt. Unsetting (rather than setting) these causes RubyGems'
	# Gem::PathSupport to fall back to Gem.default_path, which unconditionally
	# prepends Gem.user_dir (e.g. ~/.local/share/gem/ruby/3.2.0). If the
	# invoking user has a system Ruby reporting the same ruby_version as
	# bolt's vendored Ruby, this pulls in ABI-incompatible native gems (e.g.
	# io-console) and bolt fails with a LoadError. Pin both vars explicitly
	# instead, so RubyGems never consults the user gem directory.
	local ins_home ins_path
	ins_home='/BOLT_ORIG_GEM_PATH=/i\  GEM_HOME='"${gem_home}"' \\'
	ins_path='/BOLT_ORIG_GEM_PATH=/i\  GEM_PATH='"${gem_home}"' \\'

	sed -i \
		-e '/^  -u GEM_HOME \\$/d' \
		-e '/^  -u GEM_PATH \\$/d' \
		-e "${ins_home}" \
		-e "${ins_path}" \
		"${S}/opt/puppetlabs/bin/bolt" || die

	# Confirm both the deletion and insertion actually applied (sed matches
	# nothing silently if upstream reorders/renames these lines in a future
	# release), and that the result is still valid shell.
	grep -q '^  -u GEM_HOME \\$' "${S}/opt/puppetlabs/bin/bolt" && \
		die "Failed to remove -u GEM_HOME from bolt wrapper"
	grep -q '^  -u GEM_PATH \\$' "${S}/opt/puppetlabs/bin/bolt" && \
		die "Failed to remove -u GEM_PATH from bolt wrapper"
	grep -qF "  GEM_HOME=${gem_home} \\" "${S}/opt/puppetlabs/bin/bolt" || \
		die "Failed to pin GEM_HOME in bolt wrapper"
	grep -qF "  GEM_PATH=${gem_home} \\" "${S}/opt/puppetlabs/bin/bolt" || \
		die "Failed to pin GEM_PATH in bolt wrapper"
	sh -n "${S}/opt/puppetlabs/bin/bolt" || \
		die "Patched bolt wrapper is not valid shell syntax"
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
