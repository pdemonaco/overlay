# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Continuous local or offsite backup system"
HOMEPAGE="https://www.crashplan.com"

# Main package & internal JRE
CODE42_DOWNLADS="https://download.code42.com/installs"
SRC_URI="${CODE42_DOWNLADS}/linux/install/CrashPlan/CrashPlan_${PV}_Linux.tgz -> ${P}.tgz
	amd64?	( ${CODE42_DOWNLADS}/proserver/jre/jre-8-linux-x64.tgz -> ${P}-jre-8-x64.tgz )
	x86?	( ${CODE42_DOWNLADS}/proserver/jre/jre-8-linux-i586.tgz -> ${P}-jre-8-x86.tgz )"
PJRE_X64="${P}-jre-8-x64.tgz"
PJRE_X86="${P}-jre-8-x86.tgz"

LICENSE="Code42-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/sed sys-apps/grep app-arch/cpio
	app-arch/gzip sys-apps/coreutils"
RDEPEND="${DEPEND}"

# Crashplan Variables
TARGETDIR=/opt/${PN}
BINSDIR=/usr/sbin
MANIFESTDIR=/opt/${PN}/manifest
INITDIR=/etc/init.d
JAVACOMMON=/opt/${PN}/jre/bin/java
APP_BASENAME="CrashPlan"

src_unpack() {
	unpack ${P}.tgz

	# Build our proto-install directory
	mkdir "${WORKDIR}/${PN}"
	cd "${WORKDIR}/${PN}"

	# Attempt to unpack that weird CPI file
	gzip -d -c "${WORKDIR}/${PN}-install/${APP_BASENAME}_${PV}.cpi" | \
		cpio -i --no-preserve-owner || die "failed to extract cpi file!"

	# Extract the appropriate JRE
	case ${ARCH} in
		amd64)
			unpack ${PJRE_X64} || die "couldn't unpack ${PJRE_X64}"
			;;
		x86)
			unpack ${PJRE_X86} || die "couldn't unpack ${PJRE_X86}"
			;;
	esac

	# Deploy the files
	mv "${WORKDIR}/${PN}" "${S}"
}

src_install() {
	# Store the variables which the normal crashplan installer expects
	# It's not clear whether these are actually necessary for us
	local VARS="install.vars"
	echo "" > ${VARS}
	echo "TARGETDIR=${TARGETDIR}" >> ${VARS}
	echo "BINSDIR=${BINSDIR}" >> ${VARS}
	echo "MANIFESTDIR=${MANIFESTDIR}" >> ${VARS}
	echo "INITDIR=${INITDIR}" >> ${VARS}
	echo "JAVACOMMON=${JAVACOMMON}" >> ${VARS}

	# Something about the "ATOM SHELL"
	# TODO

	# Custom?
	# TODO

	# Update file storage configuration
	if grep "<manifestPath>.*</manifestPath>" \
		conf/default.service.xml > /dev/null; then
		sed -i "s|<manifestPath>.*</manifestPath>|<manifestPath>${MANIFESTDIR}</manifestPath>|g" \
			conf/default.service.xml
	else
		sed -i "s|<backupConfig>|<backupConfig>\n\t\t\t<manifestPath>${MANIFESTDIR}</manifestPath>|g" \
			conf/default.service.xml
	fi
	
	# Ensure root actually owns everything in the temporary directory
	chown -R portage:portage "${S}"

	local dest="/opt/${PN}"
	local tdest="${D}/opt/${PN}"

	# Copy in the main application
	dodir "${dest}" || die "Failed to make ${dest}"
	local ins_files=$(ls "${S}")
	for file in $ins_files; do
		cp -pPR "${S}/${file}" "${tdest}" || die "Failed to copy install files into target"
	done

	# Set the appropriate permissions on the log subdirectory
	chmod 777 "${tdest}/log"

	# Install the various script files
	local basename="CrashPlan"

	insopts -m755
	insinto "${dest}/bin"
	doins "${WORKDIR}/${PN}-install/scripts/${basename}Engine" || die
	doins "${WORKDIR}/${PN}-install/scripts/${basename}Desktop" || die
	insopts -m644
	doins "${WORKDIR}/${PN}-install/scripts/run.conf" || die

	# Create the init script
	cp -pP "${FILESDIR}/${PF}" "${WORKDIR}/${PN}"
	doinitd "${WORKDIR}/${PN}" || die

	# Create a shortcut for the desktop app
	dosym "${dest}/bin/${basename}Desktop" "/usr/bin/${PN}" || die
}

pkg_postinst() {
	INOTIFY_WATCHES=$(cat /proc/sys/fs/inotify/max_user_watches)
	if [[ $INOTIFY_WATCHES -le 8192 ]]; then
		ewarn "Current configuration limits your max real-time file watches to ${INOTIFY_WATCHES}."
		ewarn "A larger value is recommended; see the CrashPlan support site for details."
		ewarn
	fi

	einfo "To start the service run the following: "
	einfo "	eselect rc start crashplan"
	einfo
	einfo "Also, note that it may be desirable to add to the default runlevel"
	einfo "	eselect rc add crashplan default"
}
