# encoding: UTF-8

require 'spec_helper'

describe 'rackspace_postfix::aliases' do
  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'centos', version: '6.4') do |node|
      node.set['rackspace_postfix']['sasl_auth_template_source'] = 'rackspace_postfix'
    end.converge(described_recipe)
  end

  before do
  	stub_command("/usr/bin/test /etc/alternatives/mta -ef /usr/sbin/sendmail.postfix").and_return(true)
  end

  it 'creates /etc/aliases from database' do
    expect(chef_run).to create_template('/etc/aliases')
  end
end