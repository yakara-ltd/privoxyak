# frozen_string_literal: true

#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook Name:: privoxyak
# Recipe:: default
#
# Copyright (C) 2017 Yakara Ltd
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

include_recipe 'yum-epel' if platform_family?('rhel')

package 'privoxy'

systemd_service_drop_in 'syslog' do
  override 'privoxy.service'
  precursor 'Service' => { 'ExecStart' => nil }

  service do
    type 'simple'
    exec_start '/usr/sbin/privoxy --pidfile /run/privoxy.pid --user privoxy --no-daemon /etc/privoxy/config'
  end

  action node['privoxyak']['syslog'] ? :create : :delete
  notifies :restart, 'service[privoxy]'
end

template '/etc/privoxy/limit-connect.action' do
  source 'limit-connect.action.erb'
  owner 'root'
  group node['root_group']
  mode '0644'
  notifies :restart, 'service[privoxy]'
  variables limit_connects: node['privoxyak']['limit_connect']
end

template '/etc/privoxy/whitelist.action' do
  source 'whitelist.action.erb'
  owner 'root'
  group node['root_group']
  mode '0644'
  notifies :restart, 'service[privoxy]'

  variables(
    lazy do
      { whitelist: node['privoxyak']['whitelist'] }
    end
  )

  # https://github.com/chef/chef/issues/3615
  #
  # action(
  #   lazy do
  #     node['privoxyak']['whitelist'].empty? ? :delete : :create
  #   end
  # )
end

template '/etc/privoxy/config' do
  source 'privoxy.config.erb'
  owner 'root'
  group node['root_group']
  mode '0644'
  notifies :restart, 'service[privoxy]'

  variables(
    lazy do
      config = node['privoxyak']['config'].to_hash

      unless node['privoxyak']['whitelist'].empty?
        config['actionsfile'] << 'whitelist.action'
      end

      { config: config }
    end
  )
end

include_recipe 'selinux_policy::install'

addresses = Array(node['privoxyak']['config']['listen_address'])
ports = addresses.map { |a| a.slice(/(?<=:)\d+$/) }.compact.uniq

ports.each do |port|
  selinux_policy_port port do
    protocol 'tcp'
    secontext 'http_cache_port_t'
  end
end

service 'privoxy' do
  action %i[enable start]
end
