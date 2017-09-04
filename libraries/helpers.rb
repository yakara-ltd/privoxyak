# frozen_string_literal: true

#
# Author:: James Le Cuirot <james.le-cuirot@yakara.com>
# Cookbook Name:: privoxyak
# Library:: helpers
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

class Chef
  module Privoxyak
    # privoxyak helpers.
    module Helpers
      def self.action_pattern(text)
        uri =
          begin
            URI.parse text
          rescue URI::InvalidURIError
            return nil
          end

        return nil unless uri.is_a?(URI::HTTP) && uri.host

        host = uri.host.tr('[]', '<>')
        port = uri.port != uri.default_port ? ":#{uri.port}" : nil
        path = uri.is_a?(URI::HTTPS) ? nil : Regexp.escape(uri.path)
        "#{host}#{port}#{path}".dup
      end

      def self.normalize_patterns(patterns)
        patterns.compact!
        patterns.sort!
        patterns.uniq!

        # Chomp / if pattern is host-only and remove patterns with
        # paths if the host-only equivalent is present.
        patterns.each_with_index do |p, i|
          slash = p.index('/')

          if slash.nil?
            host_only = true
          elsif slash >= p.size - 1
            host_only = true
            p.slice!(-1)
          else
            host_only = false
          end

          patterns.delete_at(i + 1) while
            host_only &&
            patterns[i + 1]&.start_with?("#{p}/")
        end

        patterns
      end
    end
  end
end
