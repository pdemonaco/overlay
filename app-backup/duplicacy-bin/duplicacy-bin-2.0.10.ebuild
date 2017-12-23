# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Convert the package name to exclude the binary
BASE_PN="${PN/-bin}"
BIN_X64="${PN}_x64"
BIN_X86="${PN}_i386"

DESCRIPTION="A new generation cross-platform cloud backup tool"
HOMEPAGE="https://duplicacy.com"

BASE_URI="https://github.com/gilbertchen/duplicacy/releases/download/"
SRC_URI="${SRC_URI}
	amd64? ( ${BASE_URI%/}/v${PV}/${BASE_PN}_linux_x64_${PV} -> ${BIN_X64} )
	x86? ( ${BASE_URI%/}/v${PV}/${BASE_PN}_linux_i386_${PV} -> ${BIN_X86} )"

#https://github.com/gilbertchen/duplicacy/releases/download/v2.0.10/duplicacy_linux_x64_2.0.10

LICENSE="Duplicacy"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/go-1.8"
RDEPEND="${DEPEND}"

src_install() {
	if use x86; then
		mv "${BIN_X86}" "${BASE_PN}"
	elif use amd64; then
		mv "${BIN_X64}" "${BASE_PN}"
	fi

	dobin "${BASE_PN}"
}
