# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm desktop

DESCRIPTION="GlobalProtect GUI client with SAML Authentication"
HOMEPAGE="https://github.com/yuezk/GlobalProtect-openconnect"
#SRC_URI="https://github.com/yuezk/GlobalProtect-openconnect/releases/download/v${PV}/${P}.tar.gz"
SRC_URI="https://github.com/yuezk/GlobalProtect-openconnect/releases/download/v${PV}/${P}-1.x86_64.rpm"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

DEPEND=">=net-vpn/openconnect-9.0.0
	>=gnome-base/gnome-keyring-42.1
	>=dev-lang/perl-5.38.2
	>=sys-auth/polkit-123
	>=net-libs/webkit-gtk-2.46
	>=dev-libs/openssl-3.3.3
	>=net-libs/libsoup-2.74.3
	>=app-arch/xz-utils-5.6.4
	>=x11-libs/gtk+-2.24.33
	>=dev-libs/glib-2.82.5
	>=x11-libs/gdk-pixbuf-2.42
	>=x11-libs/cairo-1.18"
RDEPEND="${DEPEND}"
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
