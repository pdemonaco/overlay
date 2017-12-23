# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/gilbertchen/${PN}"
EGITHUB_TAG="${PV}"
inherit golang-build

DESCRIPTION="A new generation cross-platform cloud backup tool"
HOMEPAGE="https://duplicacy.com"
SRC_URI="https://${EGO_PN}/archive/v${EGITHUB_TAG}.tar.gz -> ${P}.tar.gz"

LICENSE="Duplicacy"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/go-1.8"
RDEPEND="${DEPEND}"

src_compile() {
	default
	GOPATH="${S}" go install "${EGO_PN}/..." || die
}

src_install() {
	dobin bin/*
}
