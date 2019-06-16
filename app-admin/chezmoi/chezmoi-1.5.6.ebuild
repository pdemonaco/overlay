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
	"github.com/danieljoos/wincred v1.0.1"
	"github.com/godbus/dbus v4.1.0" # incompatible
	"github.com/google/go-github/v25 v25.0.1 github.com/google/go-github"
	## dep google/go-github: start
	"github.com/golang/protobuf v1.2.0"
	"github.com/google/go-querystring v1.0.0"
	# github.com/golang/crypto
	"golang.org/x/net d8887717615a059821345a5c23649351b52a1c0b github.com/golang/net"
	# github.com/golang/oauth2
	# github.com/golang/sync
	## dep google/go-github: end
	"github.com/golang/appengine v1.1.0"
	"github.com/google/renameio v0.1.0"
	"github.com/google/uuid v1.1.0 "
	"github.com/huandu/xstrings v1.2.0 "
	"github.com/imdario/mergo v0.3.7 "
	"github.com/kr/text v0.1.0"
	## dep kr/pty: start
	"github.com/kr/pty v1.1.1"
	## dep kr/pty: end
	"github.com/mattn/go-isatty v0.0.7"
	## dep mattn/go-isatty: start
	# golang.org/x/sys
	## dep mattn/go-isatty: end
	"github.com/russross/blackfriday/v2 v2.0.1 github.com/russross/blackfriday"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0"
	"github.com/spf13/afero v1.2.2"
	# spf13/afero dep: start
	"golang.org/x/text v0.3.0 github.com/golang/text"
	# spf13/afero dep: end
	"github.com/spf13/cobra v0.0.4"
	## dep sfp13/cobra: start
	# github.com/BurntSushi/toml v0.3.1
	"github.com/cpuguy83/go-md2man v1.0.10"
	"github.com/inconshreveable/mousetrap v1.0.0"
	"github.com/mitchellh/go-homedir v1.1.0"
	"github.com/spf13/pflag v1.0.3"
	# github.com/spf13/viper v1.3.2
	# gopkg.in/yaml.v2 v2.2.2
	## dep sfp13/cobra: end
	"github.com/spf13/viper v1.3.2"
	## dep spf13/viper: start
	"github.com/armon/consul-api eb2c6b5be1b66bab83016e0b05f01b8d5496ffbd"
	"github.com/coreos/etcd v3.3.10" # incompatible
	"github.com/coreos/go-etcd v2.0.0" # incompatible
	"github.com/coreos/go-semver v0.2.0"
	# "github.com/coreos/go-semver v0.2.0"
	"github.com/fsnotify/fsnotify v1.4.7"
	"github.com/hashicorp/hcl v1.0.0"
	"github.com/magiconair/properties v1.8.0"
	"github.com/mitchellh/mapstructure v1.1.2"
	"github.com/pelletier/go-toml v1.2.0"
	# github.com/spf13/afero v1.1.2
	"github.com/spf13/cast v1.3.0"
	"github.com/spf13/jwalterweatherman v1.0.0"
	# "github.com/spf13/pflag v1.0.3"
	# github.com/stretchr/testify v1.2.2
	"github.com/ugorji/go/codec d75b2dcb6bc890b13ac61b764f5dc5e5a5591dce github.com/ugorji/go"
	"github.com/xordataexchange/crypt b2862e3d0a775f18c7cfe02273500ae307b61218"
	# golang.org/x/sys
	# golang.org/x/text
	# gopkg.in/yaml.v2 v2.2.2
	## dep spf13/viper: end
	"github.com/stretchr/objx v0.2.0"
	## dep stretcher/objx: start
	"github.com/davecgh/go-spew v1.1.1"
	# github.com/stretchr/testify v1.3.0
	## dep stretcher/objx: end
	"github.com/stretchr/testify v1.3.0"
	## dep stretchr/testify: start 
	# github.com/davecgh/go-spew v1.1.0
	# github.com/pmezard/go-difflib v1.0.0
	# github.com/stretchr/objx v0.1.0
	## dep stretchr/testify: end
	"github.com/twpayne/go-difflib v1.3.1"
	"github.com/twpayne/go-shell v0.0.1"
	"github.com/twpayne/go-vfs v1.1.0"
	## dep twpayne/go-vfs: start
	"github.com/hectane/go-acl dfeb47f3e2ef7e235d6cc6f42514a37b9767e41d"
	# github.com/stretchr/testify v1.3.0
	# golang.org/x/sys v0.0.0-20190523142557-0e01d883c5c5
	## dep twpayne/go-vfs: end
	"github.com/twpayne/go-vfsafero v1.0.0"
	# github.com/spf13/afero v1.1.2
	# github.com/twpayne/go-vfs v1.0.1
	# golang.org/x/text v0.3.0 // indirect
	"github.com/twpayne/go-xdg/v3 v3.1.0 github.com/twpayne/go-xdg"
	# github.com/stretchr/testify v1.3.0
	# github.com/twpayne/go-vfs v1.0.5
	"github.com/zalando/go-keyring 6d81c293b3fbc8a9b1bcf4bc9c167c2e1d1f52cf"
	"go.etcd.io/bbolt 4af6cfab7010371f25e79d9e104890c6377781ab github.com/etcd-io/bbolt"
	"golang.org/x/crypto c2843e01d9a2bc60bb26ad24e09734fdc2d9ec58 github.com/golang/crypto"
	"golang.org/x/oauth2 d2e6202438beef2727060aa7cabdd924d92ebfd9 github.com/golang/oauth2"
	"golang.org/x/sys 10058d7d4faa7dd5ef860cbd31af00903076e7b8 github.com/golang/sys"
	"gopkg.in/yaml.v2 v2.2.2 github.com/go-yaml/yaml"
	 )

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

DEPEND="dev-vcs/git"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.12"

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
