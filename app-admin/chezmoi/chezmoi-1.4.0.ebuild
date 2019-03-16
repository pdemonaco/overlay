# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# List dependencies via the following:
# go get -u github.com/twpayne/chezmoi
# go list -f '{{ .Deps }}' -json github.com/twpayne/chezmoi
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
	"gopkg.in/yaml.v2 v2.2.2 github.com/go-yaml/yaml"
	"github.com/armon/consul-api eb2c6b5be1b66bab83016e0b05f01b8d5496ffbd" # Dependencies for spf13/viper
	"github.com/coreos/etcd v3.3.10" # incompatible
	"github.com/coreos/go-etcd v2.0.0" # incompatible
	"github.com/coreos/go-semver v0.2.0"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/hashicorp/hcl v1.0.0"
	"github.com/magiconair/properties v1.8.0"
	"github.com/mitchellh/mapstructure v1.1.2"
	"github.com/pelletier/go-toml v1.2.0"
	"github.com/spf13/afero v1.1.2"
	"github.com/spf13/cast v1.3.0"
	"github.com/spf13/jwalterweatherman v1.0.0"
	"github.com/spf13/pflag v1.0.3"
	"github.com/stretchr/testify v1.2.2"
	"github.com/ugorji/go d75b2dcb6bc890b13ac61b764f5dc5e5a5591dce"
	"github.com/xordataexchange/crypt b2862e3d0a775f18c7cfe02273500ae307b61218"
	"golang.org/x/text v0.3.0 github.com/golang/text" )

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
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
		GOCACHE="${T}/go-cache" \
		go build -o "${T}/${PN}" -v -work -x \
		-ldflags "-s -w -X ${CMD_VERSION} -X ${CMD_DATE}" \
		"${EGO_PN}"
}

src_install() {
	einstalldocs
	dobin "${T}/chezmoi"
}
