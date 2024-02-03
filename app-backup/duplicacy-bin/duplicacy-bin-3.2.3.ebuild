# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Convert the package name to exclude the binary
BASE_PN="${PN/-bin}"
BIN_X64="${P}_x64"
BIN_X86="${P}_i386"

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

RESTRICT="mirror"

DEPEND=">=dev-lang/go-1.8"
RDEPEND="${DEPEND}"

src_unpack() {
	# Create the source directory and move into it
	mkdir -p "${S}" || die
	pushd "${S}" || die

	# Copy the binary over from the distfiles directory
	if use x86; then
		cp "${DISTDIR}/${BIN_X86}" "${PN}" || die
	elif use amd64; then
		cp "${DISTDIR}/${BIN_X64}" "${PN}" || die
	fi

	# Get back out of there
	popd || die
}

src_install() {
	dobin "${PN}" || die
	dosym "${PN}" /usr/bin/duplicacy || die
}
