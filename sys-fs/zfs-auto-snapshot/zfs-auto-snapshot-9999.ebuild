# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

USER="zfsonlinux"
REPO="${PN}"
EGIT_REPO_URI="git://github.com/${USER}/${PN}.git"

DESCRIPTION="Automated Snapshot Service for zfsonlinux"
HOMEPAGE="http://github.com/zfsonlinux/zfs-auto-snapshot"
SRC_URI=""

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-fs/zfs
	virtual/cron"
RDEPEND="${DEPEND}"

src_install () {
	emake DESTDIR="${D}" install
	dodoc README
}
