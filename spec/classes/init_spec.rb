require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'

describe 'bind' do
  context "With default facts" do
    it {
      should contain_class('bind')
      should_not contain_file('/etc/bind/named.conf.options')
    }
  end

  context "With config" do
    let (:params) { { :manage_config => true, :forwarders => [] } }

    it {
      should contain_file('/etc/bind/named.conf.options')
        .without_content(%r{^\s*forward\s+})
    }
  end

  context "With valid forward" do
    let (:params) { { :manage_config => true, :forwarders => [], :forward => 'only' } }

    it {
      should contain_file('/etc/bind/named.conf.options')
        .with_content(%r{^\s*forward\s+only;})
    }
  end

  context "With empty forward" do
    let (:params) { { :manage_config => true, :forwarders => [], :forward => '' } }

    it {
      should contain_file('/etc/bind/named.conf.options')
        .without_content(%r{^\s*forward\s+})
    }
  end

  context "With invalid forward" do
    let (:params) { { :forward => 'invalid' } }

    it {
      expect { should compile }.to raise_error(Puppet::Error, /invalid/)
    }
  end
end
