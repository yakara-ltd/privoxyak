# frozen_string_literal: true

name             'privoxyak'
maintainer       'James Le Cuirot'
maintainer_email 'james.le-cuirot@yakara.com'
license          'Apache-2.0'
description      'Installs and configures Privoxy'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
chef_version     '>= 13.0'

source_url 'https://github.com/yakara-ltd/privoxyak'
issues_url 'https://github.com/yakara-ltd/privoxyak/issues'

depends 'selinux_policy'
depends 'systemd'
depends 'yum-epel'

supports 'centos'
supports 'debian'
