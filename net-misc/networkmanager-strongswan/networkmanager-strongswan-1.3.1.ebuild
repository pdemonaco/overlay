# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils versionator

# NetworkManager likes itself with capital letters
MY_P=${P/networkmanager/NetworkManager}
MYPV_MINOR=$(get_version_component_range 1-2)

DESCRIPTION="NetworkManager StrongSwan plugin"
HOMEPAGE="http://www.strongswan.org/"
SRC_URI="http://download.strongswan.org/NetworkManager/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-libs/dbus-glib-0.102
	>=net-misc/networkmanager-0.9.0
	>=net-misc/strongswan-5.1.0[networkmanager]
	>=x11-libs/gtk+-2.6"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	dev-util/pkgconfig
"

S=${WORKDIR}/${MY_P}

src_configure() {
	ECONF="--sysconfdir=/etc --prefix=/usr --libexecdir=/usr/libexec"

	econf ${ECONF} \
		$(use_disable nls) \
		$(use_with charon "${ROOT}/usr/libexec/ipsec/charon-nm")
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc NEWS
}
