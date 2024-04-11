# Copyright 2024 Gentoo Authors
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
	>=sys-auth/polkit-123"
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
	mv "${WORKDIR}/target/release" "${S}"
	mv "${WORKDIR}/packaging/files/usr" "${S}/usr"
}

src_install() {
	# Ensure root actually owns everything in the temporary directory
	chown -R portage:portage "${S}"

	dobin gpclient
	dobin gpauth
	dobin gpservice
	dobin gpgui-helper

	domenu "${S}/usr/share/applications/gpgui.desktop"

	insinto /usr/share/icons
	doins -r "${S}/usr/share/icons/hicolor"

	insinto /usr/share/polkit-1/actions
	doins "${S}/usr/share/polkit-1/actions/com.yuezk.gpgui.policy"
}
