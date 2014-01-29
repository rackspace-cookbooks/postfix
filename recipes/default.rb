# encoding: utf-8
# Author:: Joshua Timberman(<joshua@opscode.com>)
# Author:: Christopher Coffey(<christopher.coffey@rackspace.com>)
#
# Cookbook Name:: rackspace_postfix
# Recipe:: default
#
# Copyright 2009-2012, Opscode, Inc.
# Copyright 2014, Rackspace, US Inc.
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

package 'postfix'

if node['rackspace_postfix']['use_procmail']
  package 'procmail'
end

case node['platform_family']
when 'rhel'
  service 'sendmail' do
    action :nothing
  end

  execute 'switch_mailer_to_postfix' do
    command '/usr/sbin/alternatives --set mta /usr/sbin/sendmail.postfix'
    notifies :stop, 'service[sendmail]'
    notifies :start, 'service[postfix]'
    not_if '/usr/bin/test /etc/alternatives/mta -ef /usr/sbin/sendmail.postfix'
  end
end

if !node['rackspace_postfix']['sender_canonical_map_entries'].empty? # rubocop:disable FavorUnlessOverNegatedIf
  template "#{node['rackspace_postfix']['conf_dir']}/sender_canonical" do
    owner 'root'
    group 'root'
    mode  '0644'
    notifies :restart, 'service[postfix]'
  end

  if !node['rackspace_postfix']['config']['main'].key?('sender_canonical_maps') # rubocop:disable FavorUnlessOverNegatedIf
    node.set['rackspace_postfix']['main']['sender_canonical_maps'] = "hash:#{node['rackspace_postfix']['conf_dir']}/sender_canonical"
  end
end

template "#{node['rackspace_postfix']['conf_dir']}/main.cf" do
  source "main.cf.erb"
  owner 'root'
  group 'root'
  mode  '0644'
  notifies :restart, 'service[postfix]'
  variables(settings: node['rackspace_postfix']['main'])
  cookbook node['rackspace_postfix']['main_template_source']
end

template "#{node['rackspace_postfix']['conf_dir']}/master.cf" do
  source "master.cf.erb"
  owner 'root'
  group 'root'
  mode  '0644'
  notifies :restart, 'service[postfix]'
  variables(settings: node['rackspace_postfix']['master'])
  cookbook node['rackspace_postfix']['master_template_source']
end

service 'postfix' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
