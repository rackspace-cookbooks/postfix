# encoding: UTF-8

require 'spec_helper'

describe 'rackspace_postfix::sasl_auth' do
  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'centos', version: '6.4') do |node|
      node.set['rackspace_postfix']['sasl_auth_template_source'] = 'rackspace_postfix'
    end.converge(described_recipe)
  end

  before do
    stub_command('/usr/bin/test /etc/alternatives/mta -ef /usr/sbin/sendmail.postfix').and_return(true)
  end

  it 'installs cyrus-sasl package' do
    expect(chef_run).to install_package('cyrus-sasl')
  end

  it 'installs cyrus-sasl-plain package' do
    expect(chef_run).to install_package('cyrus-sasl-plain')
  end

  it 'installs ca-certificates package' do
    expect(chef_run).to install_package('ca-certificates')
  end

  it 'creates /etc/postfix/sasl_passwd from template with attributes' do
    expect(chef_run).to create_template('/etc/postfix/sasl_passwd').with(
      user: 'root',
      group: 'root'
    )
  end
end
