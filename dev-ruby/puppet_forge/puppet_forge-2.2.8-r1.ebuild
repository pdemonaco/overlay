# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Access the Puppet Forge API from Ruby"
HOMEPAGE="https://github.com/puppetlabs/forge-ruby"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror"

ruby_add_rdepend "
	<dev-ruby/faraday-0.14.0
	<dev-ruby/faraday_middleware-0.13.0"

ruby_add_bdepend "
	=dev-ruby/semantic_puppet-1.0*
	dev-ruby/archive-tar-minitar
	dev-ruby/gettext-setup"

all_ruby_prepare() {
	sed -i -e '/faraday"/ s/0\.9\.0/0.12.2/' \
		-e '/faraday_middleware/ s/0\.11\.0/0.13/' \
		${RUBY_FAKEGEM_GEMSPEC} || die
}
