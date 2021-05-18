# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

DESCRIPTION="Webex Teams"
HOMEPAGE="https://teams.webex.com"
SRC_URI="https://binaries.webex.com/WebexDesktop-CentOS-Official-Package/Webex.rpm
-> ${P}.rpm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

DEPEND="sys-apps/lshw
	media-libs/alsa-lib
	app-accessibility/at-spi2-atk
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXrandr
	x11-libs/libnotify
	app-crypt/libsecret
	dev-libs/wayland
	x11-libs/libxkbcommon
	media-libs/mesa
	dev-libs/nss
	x11-libs/pango
	media-sound/pulseaudio
	sys-power/upower
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-wm"
RDEPEND="${DEPEND}"
BDEPEND=""

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
