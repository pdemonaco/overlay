# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

USER="OpenXenManager"
REPO="${PN}"
EGIT_REPO_URI="git://github.com/${USER}/${PN}.git"
inherit git-r3

DESCRIPTION="Opensource XenServer/XCP Management GUI"
HOMEPAGE="http://github.com/OpenXenManager/openxenmanager"
SRC_URI=""

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/configobj
	dev-python/pygtk
	dev-python/raven
	net-libs/gtk-vnc"
RDEPEND="${DEPEND}"
