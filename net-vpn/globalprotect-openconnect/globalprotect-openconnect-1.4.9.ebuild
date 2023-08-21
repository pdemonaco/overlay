# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="GlobalProtect GUI client with SAML Authentication"
HOMEPAGE="https://github.com/yuezk/GlobalProtect-openconnect"
SRC_URI="https://github.com/yuezk/GlobalProtect-openconnect/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="mirror"

DEPEND=">=net-vpn/openconnect-9.0.0
	dev-qt/qtcore:5
	dev-qt/qtwebengine:5
	dev-qt/qtwebsockets:5
	dev-qt/qtdbus:5
	dev-libs/qtkeychain"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-SingleApplication.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_CXX_FLAGS_RELEASE=-s
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	cmake_build
}
