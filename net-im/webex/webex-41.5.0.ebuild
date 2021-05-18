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

	# Copy the extracted files into the destdir
	cp -rpP "${S}/usr" "${D}" || \
		die "Failed to copy install files into the target!"

	# Create the opt directory
	local dest="/opt/Webex"
	dodir "${dest}" || die "Failed to create ${dest}"

	# Copy the opt subdirectory from it's temp output
	cp -pPR "${S}/opt/Webex" "${D}/opt/Webex/" || \
		die "Failed to copy install files into target"

	# Create a symlink for the Webex binary
	dosym "${dest}/bin/CiscoCollabHost" "/usr/bin/${PN}" || die "Failed to create symlink"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
