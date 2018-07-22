# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils rpm

UPSTREAM_PV="1.0.5-1"

DESCRIPTION="Brother DS-620 Scanner DRivers"
HOMEPAGE="http://support.brother.com/g/b/producttop.aspx?c=us&lang=en&prod=ds620_all"
SRC_URI="http://support.brother.com/g/b/downloadend.aspx?c=us&lang=en&prod=ds620_all&os=127&dlid=dlf100974_000&flang=4&type3=564 -> libsane-dsseries-${UPSTREAM_PV}.x86_64.rpm"

LICENSE="Brother-DSSeries"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="fetch strip"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	rpm_src_unpack libsane-dsseries-${UPSTREAM_PV}.x86_64.rpm
	rm -r "${S}/usr/local" "${S}/etc/udev/" || die
}

src_install() {
	doins -r *
}
