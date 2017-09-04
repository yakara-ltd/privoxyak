privoxyak Cookbook
==================
Installs and configures [Privoxy](https://www.privoxy.org).

Requirements
------------
This cookbook has been tested on:

- CentOS 7
- Debian 8
- Chef 12.16

Usage
-----
#### privoxyak::default
Installs privoxy from distribution repositories (EPEL for RHEL) and configures it entirely from attributes.

The `/etc/privoxy/config` file is generated from all attributes under `node['privoxy']['config']`. Underscores in the key names are converted to dashes and boolean values are converted to 0/1. The default values in this cookbook mirror those from upstream.

A `limit-connect.action` file is created from `node['privoxy']['limit_connect']`. The default value of `[{ 443 => '/' }]` creates a rule that permits direct connections on port 443 to any allowed host, as would generally be required for HTTPS. You can replace this rule or add additional rules to disable all direct connections, permit connections on any port, or permit connections to specific hosts on specific ports.

If `node['privoxy']['whitelist']` is non-empty (it is empty by default) then a `whitelist.action` file is created and added to the configuration. This starts by blocking all URLs and specific URLs can subsequently be unblocked. Set this attribute as a hash with values representing the rule patterns and keys to group them by comment. The whitelist recipes are used to populate the attribute from live mirror lists.

### privoxyak::whitelist_centos
Populates the whitelist with CentOS mirror URLs.

### privoxyak::whitelist_cpan
Populates the whitelist with CPAN mirror URLs.

### privoxyak::whitelist_elrepo
Populates the whitelist with ELRepo mirror URLs. The `node['privoxyak']['elrepo_versions']` attribute array determines which EL versions to fetch mirrors for. These URLs are suitable for all the ELRepo repositories, not just the main "elrepo" repository.

### privoxyak::whitelist_epel
Populates the whitelist with EPEL mirror URLs. The `node['privoxyak']['epel_versions']` attribute array determines which EL versions to fetch mirrors for.

### privoxyak::whitelist
Includes all of the whitelist recipes above.

Contributing
------------
You know what to do. ;)

License and Authors
-------------------
- Author:: James Le Cuirot (<james.le-cuirot@yakara.com>)

```text
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
```
