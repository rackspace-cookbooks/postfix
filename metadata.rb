# encoding: utf-8
name              'rackspace_postfix'
description       'Installs and configures postfix for client or outbound relayhost, or to do SASL auth'
maintainer        'Rackspace, US Inc.'
maintainer_email  'rackspace-cookbooks@rackspace.com'
license           'Apache 2.0'
version           '4.0.1'
recipe            'rackspace_postfix', 'Installs and configures postfix'
recipe            'rackspace_postfix::sasl_auth', 'Set up postfix to auth to a server with sasl'
recipe            'rackspace_postfix::aliases', 'Manages /etc/aliases'
recipe            'rackspace_postfix::client', 'Searches for the relayhost based on an attribute'
recipe            'rackspace_postfix::server', 'Sets the mail_type attribute to master'

%w{ubuntu debian redhat centos}.each do |os|
  supports os
end
