# frozen_string_literal: true

#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook Name:: privoxyak
# Recipe:: whitelist_elrepo
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

node['privoxyak']['elrepo_versions'].each do |version|
  basename = "mirrors-elrepo.el#{version}"

  rf = remote_file "#{Chef::Config[:file_cache_path]}/#{basename}.txt" do
    source "http://mirrors.elrepo.org/#{basename}"
    sensitive true
  end

  ruby_block "whitelist_elrepo_#{version}" do
    block do
      patterns = File.open(rf.path) do |file|
        file.each_line.map do |line|
          # Strip elrepo/elX/$basearch/ so that these work for the
          # extras, testing, and kernel repositories too.
          line.sub! %r{[^/]+/el#{version}/\$basearch/$.*}m, ''
          Chef::Privoxyak::Helpers.action_pattern line
        end
      end

      node.default['privoxyak']['whitelist']["ELRepo-#{version}"] =
        Chef::Privoxyak::Helpers.normalize_patterns(patterns)
    end
  end

  node.default['privoxyak']['whitelist']['Mirror Lists'] <<
    Chef::Privoxyak::Helpers.action_pattern(rf.source.first)
end
