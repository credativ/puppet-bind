require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'

describe 'bind' do
  context "With default facts" do
    it {
      should contain_class('bind')
    }
  end

  context "With invalid forward" do
    let (:params) { { :forward => 'invalid' } }

    it {
      expect { should compile }.to raise_error(Puppet::Error, /invalid/)
    }
  end
end
