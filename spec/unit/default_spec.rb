# encoding: UTF-8

require 'spec_helper'

describe 'rackspace_postfix::default' do
  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'centos', version: '6.4') do |node|
      node.set['rackspace_postfix']['conf_dir'] = '/etc/postfix'
    end.converge(described_recipe)
  end

  before do
    stub_command('/usr/bin/test /etc/alternatives/mta -ef /usr/sbin/sendmail.postfix').and_return(true)
  end

  it 'creates /etc/postfix/main.cf from template with attributes' do
    expect(chef_run).to create_template('/etc/postfix/main.cf').with(
      user: 'root',
      group: 'root'
    )
  end

  it 'creates /etc/postfix/master.cf from template with attributes' do
    expect(chef_run).to create_template('/etc/postfix/master.cf').with(
      user: 'root',
      group: 'root'
    )
  end

  it 'ensure postfix is enabled' do
    expect(chef_run).to enable_service('postfix')
  end

  it 'ensure postfix is started' do
    expect(chef_run).to start_service('postfix')
  end
end
