# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

DESCRIPTION="Full featured sync client for Google Drive and OneDrive"
HOMEPAGE="https://www.insynchq.com/"
SRC_URI_BASE="http://yum.insync.io/fedora/32"
SRC_URI="amd64? ( ${SRC_URI_BASE}/x86_64/insync-${PV}-fc30.x86_64.rpm )"

LICENSE="Insynchq"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror"

DEPEND=">=sys-libs/glibc-2.29
	x11-misc/xdg-utils"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	rpm_src_unpack ${A}

	# Make the "source" directory
	mkdir -p "${S}"
}

src_install() {
	# Copy the extracted files into the destdir
	cp -rpP "${WORKDIR}/usr" "${D}" || \
		die "Failed to copy install files into the target!"

	# I wasn't able to exclude this pre-compressed manpage with docompress -x, so I've resorted to decompressing it before installation
	gzip -d "${D}/usr/share/man/man1/insync.1.gz"
}

pkg_postinst() {
	elog "Headless operation is no longer supported by upstream"
	elog "Insync will only run as a logged-in X user"

	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
