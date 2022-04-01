# frozen_string_literal: true

#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook:: privoxyak
# Attributes:: default
#
# Copyright:: (C) 2017 Yakara Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['privoxyak']['elrepo_versions'] = [7]
default['privoxyak']['epel_versions'] = [7]
default['privoxyak']['limit_connect'] = [{ 443 => '/' }]
default['privoxyak']['syslog'] = false

default['privoxyak']['whitelist'] = {}
default['privoxyak']['whitelist']['Mirror Lists'] = []

config = default['privoxyak']['config']

config['confdir'] = '/etc/privoxy'
config['logdir'] = '/var/log/privoxy'

config['actionsfile'] = %w(match-all.action default.action limit-connect.action user.action)
config['filterfile'] = %w(default.filter user.filter)
config['logfile'] = 'logfile'
config['listen_address'] = '127.0.0.1:8118'
config['toggle'] = true
config['enable_remote_toggle'] = false
config['enable_remote_http_toggle'] = false
config['enable_edit_actions'] = false
config['enforce_blocks'] = false
config['buffer_limit'] = 4096
config['enable_proxy_authentication_forwarding'] = false
config['forwarded_connect_retries'] = 0
config['accept_intercepted_requests'] = false
config['allow_cgi_request_crunching'] = false
config['split_large_forms'] = false
config['keep_alive_timeout'] = 5
config['tolerate_pipelining'] = true
config['socket_timeout'] = 300
