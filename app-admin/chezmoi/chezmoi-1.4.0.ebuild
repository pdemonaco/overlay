# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_VENDOR=( "github.com/BurntSushi/toml v0.3.1"
	"github.com/Masterminds/semver v1.4.2"
	"github.com/Masterminds/sprig v2.17.1" #+incompatible
	"github.com/aokoli/goutils v1.1.0"
	"github.com/coreos/go-semver v0.2.0"
	"github.com/d4l3k/messagediff v1.2.1"
	"github.com/danieljoos/wincred v1.0.1"
	"github.com/godbus/dbus v4.1.0" # incompatible
	"github.com/google/renameio v0.1.0"
	"github.com/google/uuid v1.1.0 "
	"github.com/huandu/xstrings v1.2.0 "
	"github.com/imdario/mergo v0.3.7 "
	"github.com/inconshreveable/mousetrap v1.0.0 "
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/spf13/cobra v0.0.3"
	"github.com/spf13/viper v1.3.1"
	"github.com/stretchr/objx v0.1.1"
	"github.com/twpayne/go-shell v0.0.1"
	"github.com/twpayne/go-vfs v1.0.5"
	"github.com/twpayne/go-xdg 4973c34fec2fdad623049913f453d3bf3423e47f"
	"github.com/zalando/go-keyring 6d81c293b3fbc8a9b1bcf4bc9c167c2e1d1f52cf"
"golang.org/x/crypto c2843e01d9a2bc60bb26ad24e09734fdc2d9ec58 github.com/golang/crypto"
	"golang.org/x/sys 10058d7d4faa7dd5ef860cbd31af00903076e7b8 github.com/golang/sys"
	"gopkg.in/yaml.v2 v2.2.2 github.com/go-yaml/yaml" )

EGO_PN="github.com/twpayne/${PN}"

inherit golang-vcs-snapshot

DESCRIPTION="Manage your dotfiles across multiple machines, securely."
HOMEPAGE="https://github.com/twpayne/chezmoi"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=( "src/${EGO_PN}/README.md" )

src_compile() {
	CMD_VERSION="${EGO_PN}/cmd.version=${PV}"
	CMD_DATE="${EGO_PN}/cmd.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"

	ego_pn_check
	set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		GOCACHE="${T}/go-cache" \
		go build -v -work -x -ldflags "-X ${CMD_VERSION} -X ${CMD_DATE}" \
		-o "${PN}" "${EGO_PN}"
}

src_install() {
	einstalldocs
	dobin "${S}/chezmoi"
}
