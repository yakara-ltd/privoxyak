# frozen_string_literal: true

#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook Name:: privoxyak
# Recipe:: whitelist_cpan
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

basename = 'mirrors.json'

rf = remote_file "#{Chef::Config[:file_cache_path]}/cpan-#{basename}" do
  source "https://www.cpan.org/indices/#{basename}"
  sensitive true
end

ruby_block 'whitelist_cpan' do
  block do
    patterns = JSON.parse(File.read(rf.path)).map do |data|
      Chef::Privoxyak::Helpers.action_pattern data['http']
    end

    node.default['privoxyak']['whitelist']['CPAN'] =
      Chef::Privoxyak::Helpers.normalize_patterns(patterns)
  end
end
