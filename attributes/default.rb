# encoding: utf-8
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Christopher Coffey <christopher.coffey@rackspace.com>
#
# Copyright:: Copyright (c) 2009, Opscode, Inc.
# Copyright:: Copyright (c) 2014, Rackspace, US Inc.
#
# License:: Apache License, Version 2.0
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

# Generic cookbook attributes
default['rackspace_postfix']['mail_type']  = 'client'
default['rackspace_postfix']['relayhost_role'] = 'relayhost'
default['rackspace_postfix']['multi_environment_relay'] = false
default['rackspace_postfix']['use_procmail'] = false
default['rackspace_postfix']['aliases'] = {}
default['rackspace_postfix']['main_template_source'] = 'rackspace_postfix'
default['rackspace_postfix']['master_template_source'] = 'rackspace_postfix'
default['rackspace_postfix']['aliases_template_source'] = 'rackspace_postfix'
default['rackspace_postfix']['sasl_auth_template_source'] = 'rackspace_postfix'
default['rackspace_postfix']['sender_canonical_map_entries'] = {}
default['rackspace_postfix']['conf_dir'] = '/etc/postfix'
default['rackspace_postfix']['aliases_db'] = '/etc/aliases'

# Non-default main.cf attributes
default['rackspace_postfix']['config']['main']['biff'] = 'no'
default['rackspace_postfix']['config']['main']['append_dot_mydomain'] = 'no'
default['rackspace_postfix']['config']['main']['myhostname'] = (node['fqdn'] || node['hostname']).to_s.chomp('.')
default['rackspace_postfix']['config']['main']['mydomain'] = (node['domain'] || node['hostname']).to_s.chomp('.')
default['rackspace_postfix']['config']['main']['myorigin'] = '$myhostname'
default['rackspace_postfix']['config']['main']['mydestination'] = [node['rackspace_postfix']['config']['main']['myhostname'], node['hostname'], 'localhost.localdomain', 'localhost'].compact
default['rackspace_postfix']['config']['main']['smtpd_use_tls'] = 'yes'
default['rackspace_postfix']['config']['main']['smtp_use_tls'] = 'yes'
default['rackspace_postfix']['config']['main']['alias_maps'] = ["hash:#{node['rackspace_postfix']['aliases_db']}"]
default['rackspace_postfix']['config']['main']['mailbox_size_limit'] = 0
default['rackspace_postfix']['config']['main']['recipient_delimiter'] = '+'
default['rackspace_postfix']['config']['main']['smtp_sasl_auth_enable'] = 'no'
default['rackspace_postfix']['config']['main']['mynetworks'] = '127.0.0.0/8'
default['rackspace_postfix']['config']['main']['inet_interfaces'] = 'loopback-only'

# Conditional attributes
case node['platform']
when 'rhel'
  cafile = '/etc/pki/tls/cert.pem'
else
  cafile = '/etc/postfix/cacert.pem'
end

if node['rackspace_postfix']['use_procmail']
  default['rackspace_postfix']['config']['main']['mailbox_command'] = '/usr/bin/procmail -a "$EXTENSION"'
end

if node['rackspace_postfix']['config']['main']['smtpd_use_tls'] == 'yes'
  default['rackspace_postfix']['config']['main']['smtpd_tls_cert_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
  default['rackspace_postfix']['config']['main']['smtpd_tls_key_file'] = '/etc/ssl/private/ssl-cert-snakeoil.key'
  default['rackspace_postfix']['config']['main']['smtpd_tls_CAfile'] = cafile
  default['rackspace_postfix']['config']['main']['smtpd_tls_session_cache_database'] = 'btree:${data_directory}/smtpd_scache'
end

if node['rackspace_postfix']['config']['main']['smtp_use_tls'] == 'yes'
  default['rackspace_postfix']['config']['main']['smtp_tls_CAfile'] = cafile
  default['rackspace_postfix']['config']['main']['smtp_tls_session_cache_database'] = 'btree:${data_directory}/smtp_scache'
end

if node['rackspace_postfix']['config']['main']['smtp_sasl_auth_enable'] == 'yes'
  default['rackspace_postfix']['config']['main']['smtp_sasl_password_maps'] = "hash:#{node['rackspace_postfix']['conf_dir']}/postfix/sasl_passwd"
  default['rackspace_postfix']['config']['main']['smtp_sasl_security_options'] = 'noanonymous'
  default['rackspace_postfix']['config']['sasl']['smtp_sasl_user_name'] = ''
  default['rackspace_postfix']['config']['sasl']['smtp_sasl_passwd']    = ''
  default['rackspace_postfix']['config']['main']['relayhost'] = ''
end

# # Default main.cf attributes according to `postconf -d`
# default['rackspace_postfix']['config']['main']['relayhost'] = ''
# default['rackspace_postfix']['config']['main']['milter_default_action']  = 'tempfail'
# default['rackspace_postfix']['config']['main']['milter_protocol']  = '6'
# default['rackspace_postfix']['config']['main']['smtpd_milters'] = ''
# default['rackspace_postfix']['config']['main']['non_smtpd_milters']  = ''
# default['rackspace_postfix']['config']['main']['sender_canonical_classes'] = nil
# default['rackspace_postfix']['config']['main']['recipient_canonical_classes'] = nil
# default['rackspace_postfix']['config']['main']['canonical_classes'] = nil
# default['rackspace_postfix']['config']['main']['sender_canonical_maps'] = nil
# default['rackspace_postfix']['config']['main']['recipient_canonical_maps'] = nil
# default['rackspace_postfix']['config']['main']['canonical_maps'] = nil

# Master.cf attributes
default['rackspace_postfix']['config']['master']['submission'] = false
