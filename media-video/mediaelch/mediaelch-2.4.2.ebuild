# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils eutils multilib

DESCRIPTION="Media Metadata Manager"
HOMEPAGE="http://www.mediaelch.de/"
SRC_URI="https://github.com/Komet/MediaElch/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

MIXED_CASE="MediaElch"

DEPEND="dev-qt/qtsql:5
		dev-qt/qtscript:5
		dev-qt/qtquickcontrols:5
		dev-qt/qtxml:5
		dev-qt/qtxmlpatterns:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		media-video/mediainfo
		media-libs/libzen
		media-libs/phonon
		dev-libs/quazip
		dev-qt/qtconcurrent:5
		dev-qt/qtmultimedia:5[widgets]
		dev-qt/qtscript:5"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${P}.tar.gz"
	mv "${WORKDIR}/${MIXED_CASE}-${PV}" "${WORKDIR}/${P}" || die
}

src_configure()
{
	cd "${WORKDIR}/${P}" || die
	eqmake5 || die
}

src_install()
{
	cd "${WORKDIR}/${P}" || die
	emake INSTALL_ROOT="${D}" install || die
}
