# encoding: utf-8
# Author:: Joshua Timberman(<joshua@opscode.com>)
# Author:: Christopher Coffey(<christopher.coffey@rackspace.com>)
#
# Copyright:: Copyright (c) 2012, Opscode, Inc.
# Copyright:: Copyright (c) 2014, Rackspace, US Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'rackspace_postfix'

execute 'update-postfix-aliases' do
  command 'newaliases'
  action :nothing
end

template node['rackspace_postfix']['aliases_db'] do
  cookbook node['rackspace_postfix']['aliases_template_source']
  source 'aliases.erb'
  notifies :run, 'execute[update-postfix-aliases]'
end
