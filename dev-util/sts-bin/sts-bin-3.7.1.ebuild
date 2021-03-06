# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils versionator

SRC_BASE="http://dist.springsource.com/release/STS/${PV}.RELEASE/dist/e4.5/spring-tool-suite-${PV}.RELEASE-e4.5.1-linux-gtk"

DESCRIPTION="Spring Tool Suite"
HOMEPAGE="http://spring.io/tools/sts"
SRC_URI="
	amd64? ( ${SRC_BASE}-x86_64.tar.gz )
	x86? ( ${SRC_BASE}.tar.gz )"

LICENSE="EPL-1.0"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="tc-server"

RDEPEND="
	>=virtual/jdk-1.7
	x11-libs/gtk+:2"

S=${WORKDIR}/sts-bundle

src_install() {
	local dest=/opt/${PN}-${SLOT}

	# Work area subdirectory
	local sts=sts-${PV}.RELEASE

	# Deploy everything but the executable
	insinto ${dest}
	doins -r ${sts}/artifacts.xml ${sts}/configuration  ${sts}/dropins ${sts}/features ${sts}/icon.xpm ${sts}/license.txt ${sts}/META-INF ${sts}/open_source_licenses.txt ${sts}/p2 ${sts}/plugins ${sts}/STS.ini

	# Install the exe
	exeinto ${dest}
	doexe ${sts}/STS

	# The readme is one html file
	dohtml -r ${sts}/readme

	# Also extract the tc server if specified
	use tc-server && doins -r pivotal-tc-server-developer-*.RELEASE

	# Configure the bin & install
	cp "${FILESDIR}"/stsrc-bin-${SLOT} "${T}" || die
	cp "${FILESDIR}"/sts-bin-${SLOT} "${T}" || die
	sed "s@%SLOT%@${SLOT}@" -i "${T}"/sts{,rc}-bin-${SLOT} || die

	insinto /etc
	newins "${T}"/stsrc-bin-${SLOT} stsrc-bin-${SLOT}

	newbin "${T}"/sts-bin-${SLOT} sts-bin-${SLOT}
	#make_desktop_entry "eclipse-bin-${SLOT}" "Eclipse ${PV} (bin)" "${dest}/icon.xpm"
}
