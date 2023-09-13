# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils git-r3

DESCRIPTION="Media Metadata Manager"
HOMEPAGE="http://www.mediaelch.de/"
MIXED_CASE="MediaElch"

EGIT_REPO_URI="https://github.com/Komet/${MIXED_CASE}"
EGIT_COMMIT="v${PV}"

SRC_URI="https://github.com/Komet/MediaElch/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

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
BDEPEND=""

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
