# frozen_string_literal: true

#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook:: privoxyak
# Recipe:: whitelist_centos
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

require 'rexml/document'

node['privoxyak']['epel_versions'].each do |version|
  basename = "metalink?repo=epel-#{version}&arch=x86_64"

  rf = remote_file "#{Chef::Config[:file_cache_path]}/#{basename}.xml" do
    source "https://mirrors.fedoraproject.org/#{basename}"
    sensitive true
  end

  ruby_block "whitelist_epel_#{version}" do
    block do
      xml = REXML::Document.new File.read(rf.path)

      patterns = xml.elements.collect('/metalink/files/file/resources/url') do |elem|
        Chef::Privoxyak::Helpers.action_pattern elem.text
      end

      node.default['privoxyak']['whitelist']["EPEL-#{version}"] =
        Chef::Privoxyak::Helpers.normalize_patterns(patterns)
    end
  end
end

node.default['privoxyak']['whitelist']['Mirror Lists'].push(
  'download.fedoraproject.org',
  'mirrors.fedoraproject.org'
)
