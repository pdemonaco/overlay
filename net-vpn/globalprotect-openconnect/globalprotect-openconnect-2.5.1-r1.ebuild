# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm desktop xdg-utils

DESCRIPTION="GlobalProtect GUI client with SAML Authentication"
HOMEPAGE="https://github.com/yuezk/GlobalProtect-openconnect"
#SRC_URI="https://github.com/yuezk/GlobalProtect-openconnect/releases/download/v${PV}/${P}.tar.gz"
SRC_URI="https://github.com/yuezk/GlobalProtect-openconnect/releases/download/v${PV}/${P}-1.x86_64.rpm"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND=">=net-vpn/openconnect-9.0.0
	>=gnome-base/gnome-keyring-42.1
	>=dev-lang/perl-5.38.2
	dev-libs/libayatana-appindicator
	>=sys-libs/glibc-2.38
	x11-libs/cairo
	>=dev-libs/openssl-3.0.0
	sys-apps/dbus
	>=sys-devel/gcc-4.2.0
	x11-libs/gtk+:3
	>=x11-libs/gdk-pixbuf-2.42
	>=dev-libs/glib-2.82.5
	dev-libs/gmp
	>=dev-libs/nettle-3.6
	net-libs/webkit-gtk:4.1
	>=app-arch/lz4-1.10
	>=app-arch/xz-utils-5.8.2
	>=net-libs/libsoup-3
	>=net-libs/gnutls-3.8.11[pkcs11]
	|| (
	sys-libs/zlib-ng[compat,abi_x86_64(-)]
	sys-libs/zlib[abi_x86_64(-)]
	)
	net-vpn/vpnc-scripts"
#BDEPEND=">=dev-lang/rust-1.75.0
#	net-libs/webkit-gtk:4
#	dev-libs/libappindicator
#	net-misc/curl
#	net-misc/wget
#	sys-apps/file"

src_unpack() {
	rpm_src_unpack ${A}

	# Make the "source" directory and move everything in
	mkdir "${S}"
	mv "${WORKDIR}/usr" "${S}/usr"
}

src_install() {
	# Ensure root actually owns everything in the temporary directory
	chown -R portage:portage "${S}"

	dobin "${S}/usr/bin/gpclient"
	dobin "${S}/usr/bin/gpauth"
	dobin "${S}/usr/bin/gpservice"
	dobin "${S}/usr/bin/gpgui-helper"
	dobin "${S}/usr/bin/gpgui"

	domenu "${S}/usr/share/applications/gpgui.desktop"

	insinto /usr/share/icons
	doins -r "${S}/usr/share/icons/hicolor"

	insinto /usr/share/polkit-1/actions
	doins "${S}/usr/share/polkit-1/actions/com.yuezk.gpgui.policy"
}

pkg_postinst() {
	# Updating the icon cache
	xdg_desktop_database_update
	xdg_icon_cache_update
}
